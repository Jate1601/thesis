import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thesis/Firebase/send_message.dart';

import '../../Firebase/retrieve_messages.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late MessageService _messageService;

  @override
  void initState() {
    super.initState();
    _messageService =
        MessageService(chatId: widget.chatId); // Initialize the message service
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
              stream: _messageService.getMessages(),
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
                    title: Text(chatDocs[index]['text']),
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
                  onPressed: () {
                    sendMessage(_messageController.text, widget.chatId);
                    _messageController.clear();
                  },
                ),
              ),
              onSubmitted: (_) => {
                sendMessage(_messageController.text, widget.chatId),
                _messageController.clear(),
              },
            ),
          ),
        ],
      ),
    );
  }
}
