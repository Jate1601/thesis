import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteChat {
  static Future<void> deleteChat(String chatId) async {
    print(chatId);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference messages =
        firestore.collection('Chats').doc(chatId).collection('message_chain');
    WriteBatch batch = firestore.batch();

    try {
      QuerySnapshot snapshot = await messages.get();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      batch.delete(firestore.collection('Chats').doc(chatId));
      await batch.commit();
      print('Successfully deleted the chat');
    } catch (e) {
      print('Error deleting chat: $e');
    }
  }
}
