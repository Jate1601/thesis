import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thesis/support/app_config.dart';

Future<void> sendMessage(String text, String chatId, String receiverId) async {
  final messageBlock = createMessageBlock(text: text, receiverId: receiverId);
  await FirebaseFirestore.instance
      .collection('Chats')
      .doc(chatId)
      .collection(dbCollection)
      .add(messageBlock);
  await FirebaseFirestore.instance
      .collection('Chats')
      .doc(chatId)
      .update({'last_message': messageBlock['timestamp']});
}
