import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thesis/support/app_config.dart';

Future<void> sendMessage(String text, String chatId) async {
  final messageBlock = createMessageBlock(text: text, receiverId: '2');
  await FirebaseFirestore.instance
      .collection('Chats')
      .doc(chatId)
      .collection(dbCollection)
      .add(messageBlock);
}
