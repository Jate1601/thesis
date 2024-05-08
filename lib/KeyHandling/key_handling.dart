import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:pointycastle/export.dart' as pc;

class KeyStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String?> retrievePrivateKey() async {
    return await _storage.read(
        key: '${FirebaseAuth.instance.currentUser!.uid}_private');
  }

  Future<String?> retrievePublicKey() async {
    return await _storage.read(
        key: '${FirebaseAuth.instance.currentUser!.uid}_public');
  }

  Future<void> generateAndStoreKeyPair() async {
    var random = pc.FortunaRandom();
    var seed =
        _createUint8ListFromRandom(32); // Ensure exactly 32 bytes are generated
    random.seed(pc.KeyParameter(seed)); // Seed the FortunaRandom

    var keyParams = pc.ECKeyGeneratorParameters(pc.ECCurve_secp256k1());
    var keyGen = pc.KeyGenerator("EC")
      ..init(pc.ParametersWithRandom(keyParams, random));
    var keyPair = keyGen.generateKeyPair();

    pc.ECPrivateKey privateKey = keyPair.privateKey as pc.ECPrivateKey;
    pc.ECPublicKey publicKey = keyPair.publicKey as pc.ECPublicKey;

    String encodedPrivateKey = base64Encode(_intToBytes(privateKey.d!));
    String encodedPublicKey = base64Encode(publicKey.Q!.getEncoded());

    // Ensure keys are saved with a unique identifier for public and private
    await _saveKey('${FirebaseAuth.instance.currentUser!.uid}_private',
        encodedPrivateKey, false);
    await _saveKey('${FirebaseAuth.instance.currentUser!.uid}_public',
        encodedPublicKey, true);
  }

  Uint8List _createUint8ListFromRandom(int length) {
    final secureRandom = Random.secure();
    return Uint8List.fromList(
        List<int>.generate(length, (_) => secureRandom.nextInt(256)));
  }

  Uint8List _intToBytes(BigInt? number) {
    if (number == null) {
      throw ArgumentError("BigInt cannot be null");
    }
    int bytes = (number.bitLength + 7) >> 3;
    BigInt b256 = BigInt.from(256);
    Uint8List result = Uint8List(bytes);
    BigInt num = number;
    for (int i = 0; i < bytes; i++) {
      result[bytes - i - 1] = (num % b256).toInt();
      num = num >> 8;
    }
    return result;
  }

  Future<void> _saveKey(String alies, String key, bool public) async {
    await _storage.write(key: alies, value: key);
    if (public) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'public_key': key,
        'email': FirebaseAuth.instance.currentUser!.email,
      });
    }
  }

  Future<void> ensureKeyExists() async {
    String? privateKey = await retrievePrivateKey();
    String? publicKey = await retrievePublicKey();

    if (privateKey == null && publicKey == null) {
      generateAndStoreKeyPair();
    }
  }

  Future<String> getPublicKeyFromFirebase(String userId) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      var publicKey = snapshot.data()?['public_key'];
      if (publicKey is String) {
        return publicKey;
      } else {
        throw Exception(
            'Public key is not in the expected format or is missing.');
      }
    } catch (e) {
      print('Error fetching public key: $e');
      throw Exception('Failed to fetch public key from Firebase.');
    }
  }

  // NEVER CALL THIS METHOD IN PRODUCTION, ONLY IN TESTING ENVIRONMENT
  Future<void> deleteKeys() async {
    await _storage.delete(
        key: '${FirebaseAuth.instance.currentUser!.uid}_private');
    await _storage.delete(
        key: '${FirebaseAuth.instance.currentUser!.uid}_public');
    print('Current users keys are deleted');
  }

  // DO NOT EVER CALL THIS
  Future<void> deleteAllKeys() async {
    await _storage.deleteAll();
    print('All keys deleted');
  }
}
