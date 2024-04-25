import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveUser() async {
  String? email = FirebaseAuth.instance.currentUser?.email;
  String public_key = FirebaseAuth.instance.currentUser!.uid;
}

class User {
  final String email;
  final String public_key;

  User({required this.email, required this.public_key});
}
