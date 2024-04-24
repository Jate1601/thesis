import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:math';

class KeyStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Save key using the Firebase UID as alias
  Future<void> saveKey(String key) async {
    await _storage.write(
        key: FirebaseAuth.instance.currentUser!.uid, value: key);
  }

  // Retrieve key using the Firebase UID as alias
  Future<String?> getKey() async {
    return await _storage.read(key: FirebaseAuth.instance.currentUser!.uid);
  }

  // Generate and save a new key if one does not already exist
  Future<String> ensureKeyExists() async {
    String? key = await getKey();
    if (key == null) {
      var random = Random.secure();
      var bytes = List<int>.generate(32, (_) => random.nextInt(256));
      key = base64Url.encode(bytes);
      await saveKey(key);
    }
    return key;
  }
}
