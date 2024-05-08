import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thesis/KeyHandling/key_handling.dart';
import 'package:thesis/support/app_config.dart';

import '../Encryption/encryption_handler.dart';

Future<void> sendMessage(String text, String chatId, String receiverId) async {
  KeyStorage keyStorage =
      KeyStorage(); // Assuming KeyStorage has a default constructor.
  EncryptionHandler encryptionHandler = EncryptionHandler(keyStorage);

  String receiverPublicKey =
      await keyStorage.getPublicKeyFromFirebase(receiverId);

  Uint8List sharedSecret =
      await encryptionHandler.generateSharedSecret(receiverId);
  String encryptedMessage =
      await encryptionHandler.encryptMessage(text, sharedSecret);

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
