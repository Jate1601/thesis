import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  final String chatId;

  MessageService({required this.chatId});

  Stream<QuerySnapshot> getMessages() {
    return FirebaseFirestore.instance
        .collection('Chats')
        .doc(chatId)
        .collection('message_chain')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
