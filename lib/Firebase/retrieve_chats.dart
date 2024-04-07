import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RetrieveChats {
  Stream<List<QueryDocumentSnapshot<Object?>>> getUserChats() {
    return FirebaseFirestore.instance
        .collection('Chats')
        .where('participants',
            arrayContains: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }
}
