import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis/Firebase/send_message.dart';
import 'package:thesis/GUI/Chat/speech_bubble_painter.dart';

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

  @override
  void initState() {
    super.initState();
    _retrievedMessages = RetrieveMessages(
        chatId: widget.chatId); // Initialize the message service
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatting...'),
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
                        CustomPaint(
                          painter: SpeechBubblePainter(
                            color: chatDocs[index]['senderId'] ==
                                    FirebaseAuth.instance.currentUser?.uid
                                ? Theme.of(context)
                                    .colorScheme
                                    .primaryContainer // Color for sender's message
                                : Colors
                                    .grey[300]!, // Color for receiver's message
                            isSender: chatDocs[index]['senderId'] ==
                                FirebaseAuth.instance.currentUser?.uid,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 10.0),
                            child: Text(
                              chatDocs[index]['text'],
                              style: TextStyle(
                                color: Colors.black,
                              ),
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
