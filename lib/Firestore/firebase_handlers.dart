import 'package:firebase_auth/firebase_auth.dart';
import 'package:thesis/KeyHandling/key_handling.dart';

Future<void> signUp(String email, String pass) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );
    // Handle success //TODO
  } catch (e) {
    // handle error //TODO
    rethrow;
  }
  String key = await getKey();
  print(key);
}

Future<void> signIn(String email, String pass) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      throw Exception(
          'No user found with that combination of email and password');
    } else {
      throw Exception('Sign in failed: ${e.message}');
    }
  }
  String key = await getKey();
  print(key);
}

Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    throw Exception('Signing out failed: $e');
  }
}

Future<String> getKey() {
  KeyStorage keyStorage = KeyStorage();
  return keyStorage.ensureKeyExists();
}
