import 'package:cloud_firestore/cloud_firestore.dart';

class FindChatId {
  final List users;

  FindChatId({required this.users});

  String getChatId() {
    return FirebaseFirestore.instance
        .collection('Chats')
        .where(
          'participants',
          arrayContains: users[0],
        )
        .where('participants', arrayContains: users[1])
        .snapshots()
        .toString();
  }
}
