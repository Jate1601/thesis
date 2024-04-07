import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String dbCollection = 'message_chain';

Map<String, dynamic> createMessageBlock({
  required String text,
  required String receiverId,
}) {
  return {
    'text': text,
    'senderId': FirebaseAuth.instance.currentUser?.uid,
    'receiverId': receiverId, // TODO receiverId can already be set here?
    'timestamp': FieldValue.serverTimestamp(),
  };
}
