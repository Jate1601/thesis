import 'package:cloud_firestore/cloud_firestore.dart';

class RetrieveMessages {
  final String chatId;

  RetrieveMessages({required this.chatId});

  Stream<QuerySnapshot> getMessages() {
    return FirebaseFirestore.instance
        .collection('Chats')
        .doc(chatId)
        .collection('message_chain')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
