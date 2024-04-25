import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:pointycastle/export.dart' as pc;

class KeyStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Retrieve key using the Firebase UID as alias
  Future<String?> _retrieveKey() async {
    return await _storage.read(key: FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> generateAndStoreKeyPair() async {
    var random = pc.FortunaRandom();
    random.seed(pc.KeyParameter(_createUint8ListFromRandom(32)));

    var keyParams = pc.ECKeyGeneratorParameters(pc.ECCurve_secp256k1());
    var keyGen = pc.KeyGenerator("EC")
      ..init(pc.ParametersWithRandom(keyParams, random));
    var keyPair = keyGen.generateKeyPair();

    pc.ECPrivateKey privateKey = keyPair.privateKey as pc.ECPrivateKey;
    pc.ECPublicKey publicKey = keyPair.publicKey as pc.ECPublicKey;

    String encodedPrivateKey = base64Encode(_intToBytes(privateKey.d!));
    String encodedPublicKey = base64Encode(publicKey.Q!.getEncoded());

    await _saveKey('${FirebaseAuth.instance.currentUser!.uid}_private',
        encodedPrivateKey, false);
    await _saveKey('${FirebaseAuth.instance.currentUser!.uid}_public',
        encodedPublicKey, true);
  }

  Uint8List _createUint8ListFromRandom(int length) {
    final rnd = pc.SecureRandom("Fortuna");
    var seedSource = DateTime.now().microsecondsSinceEpoch;
    var seed = Uint8List.fromList(utf8.encode(seedSource.toString()));
    rnd.seed(pc.KeyParameter(seed));
    var randomBytes = Uint8List(length);
    for (int i = 0; i < length; i++) {
      randomBytes[i] = rnd.nextUint8();
    }
    return randomBytes;
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
          .doc(FirebaseAuth.instance.currentUser!.email)
          .set({
        'public_key': key,
      });
    }
  }

  // Generate and save a new key if one does not already exist
  Future<void> ensureKeyExists() async {
    String? key = await _retrieveKey();
    if (key == null) {
      generateAndStoreKeyPair();
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
