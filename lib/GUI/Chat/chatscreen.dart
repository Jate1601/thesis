import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thesis/Encryption/encryption_handler.dart';
import 'package:thesis/Firebase/send_message.dart';
import 'package:thesis/GUI/Chat/speech_bubble_painter.dart';
import 'package:thesis/KeyHandling/key_handling.dart';

import '../../Firebase/retrieve_messages.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String receiverId;

  const ChatScreen({super.key, required this.chatId, required this.receiverId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late RetrieveMessages _retrievedMessages;
  late EncryptionHandler _encryptionHandler;

  @override
  void initState() {
    super.initState();
    _retrievedMessages = RetrieveMessages(
        chatId: widget.chatId); // Initialize the message service
    _encryptionHandler = EncryptionHandler(KeyStorage());
  }

  Future<String> _decryptText(String encryptedText) async {
    try {
      // Fetch shared secret for session from storage or calculate it
      var sharedSecret =
          await _encryptionHandler.generateSharedSecret(widget.receiverId);
      return await _encryptionHandler.decryptMessage(
          encryptedText, sharedSecret);
    } catch (e) {
      print("Error decrypting message: $e");
      return "Error in decryption";
    }
  }

  Widget _buildMessage(String encryptedText) {
    return FutureBuilder(
      future: _decryptText(encryptedText),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Text(snapshot.data!,
                style: const TextStyle(color: Colors.black));
          } else if (snapshot.hasError) {
            return const Text("Error in message",
                style: TextStyle(color: Colors.red));
          }
        }
        return const CircularProgressIndicator(); // Show loading indicator while decrypting
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatting...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _retrievedMessages.getMessages(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatDocs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Row(
                      mainAxisAlignment: chatDocs[index]['senderId'] ==
                              FirebaseAuth.instance.currentUser?.uid
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomPaint(
                            painter: SpeechBubblePainter(
                              color: chatDocs[index]['senderId'] ==
                                      FirebaseAuth.instance.currentUser?.uid
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer // Color for sender's message
                                  : Colors.grey[
                                      300]!, // Color for receiver's message
                              isSender: chatDocs[index]['senderId'] ==
                                  FirebaseAuth.instance.currentUser?.uid,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 10.0),
                              child: _buildMessage(chatDocs[index]['text']),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Send a message...',
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () async {
                    sendMessage(_messageController.text, widget.chatId,
                        widget.receiverId);
                    _messageController.clear();
                  },
                ),
              ),
              onSubmitted: (_) => {
                sendMessage(
                    _messageController.text, widget.chatId, widget.receiverId),
                _messageController.clear(),
              },
            ),
          ),
        ],
      ),
    );
  }
}
