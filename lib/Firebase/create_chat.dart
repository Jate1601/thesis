import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../support/supporting_functions.dart';

void createChat(String receiverId, BuildContext context) async {
  if (FirebaseAuth.instance.currentUser == null ||
      receiverId == '' ||
      receiverId.isEmpty) {
    return;
  }
  if (FirebaseAuth.instance.currentUser?.uid == receiverId) {
    //TODO Make error window popup
    showSnackBar('Cannot create chat with one self', context);
    return;
  }
  final chatDocRef = FirebaseFirestore.instance.collection('Chats').doc();
  await chatDocRef.set(
    {
      'participants': [
        FirebaseAuth.instance.currentUser?.uid,
        receiverId,
      ],
      'created': FieldValue.serverTimestamp(),
    },
  );
  Navigator.of(context).pop();
}
