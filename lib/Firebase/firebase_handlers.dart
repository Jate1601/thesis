import 'package:firebase_auth/firebase_auth.dart';

Future<void> signUp(String email, String pass) async {
  try {
    final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );
    // Handle success //TODO
  } catch (e) {
    // handle error //TODO
    rethrow;
  }
}
