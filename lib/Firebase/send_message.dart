import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thesis/KeyHandling/key_handling.dart';
import 'package:thesis/support/app_config.dart';

import '../Encryption/encryption_handler.dart';

Future<void> sendMessage(String text, String chatId, String receiverId) async {
  KeyStorage keyStorage = KeyStorage();
  EncryptionHandler encryptionHandler = EncryptionHandler();

  String receiverPublicKey =
      await keyStorage.getPublicKeyFromFirebase(receiverId);

  String encryptedMessage =
      await encryptionHandler.encryptMessage(text, receiverPublicKey);

  final messageBlock =
      createMessageBlock(text: encryptedMessage, receiverId: receiverId);
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
