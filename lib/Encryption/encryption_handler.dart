import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' as pc;
import 'package:convert/convert.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/hkdf.dart';

import '../KeyHandling/key_handling.dart';

class EncryptionHandler {
  pc.ECPrivateKey parsePrivateKey(
      String base64PrivateKey, pc.ECDomainParameters params) {
    var privateKeyBytes = base64Decode(base64PrivateKey);
    var privateKeyInt = BigInt.parse(hex.encode(privateKeyBytes), radix: 16);
    return pc.ECPrivateKey(privateKeyInt, params);
  }

  pc.ECPublicKey parsePublicKey(
      String base64PublicKey, pc.ECDomainParameters params) {
    var publicKeyBytes = base64Decode(base64PublicKey);
    var q = params.curve.decodePoint(publicKeyBytes)!;
    return pc.ECPublicKey(q, params);
  }

  String encryptAES(String plainText, Uint8List key, Uint8List iv) {
    var paddedCipher = pc.PaddedBlockCipher("AES/CBC/PKCS7");
    // Use the PaddedBlockCipherParameters to correctly encapsulate both the key and IV
    pc.CipherParameters params = pc.PaddedBlockCipherParameters(
        pc.KeyParameter(key),
        pc.IVParameter(
            iv) // Correctly using IVParameter wrapped in the PaddedBlockCipherParameters
        );
    paddedCipher.init(true, params); // true for encryption
    Uint8List ptBytes = utf8.encode(plainText);
    Uint8List encrypted = paddedCipher.process(ptBytes);
    return base64Encode(encrypted);
  }

  //pc.ParametersWithIV(pc.KeyParameter(key), iv);

  Uint8List generateIV() {
    var secureRandom = pc.SecureRandom("Fortuna");
    secureRandom
        .seed(pc.KeyParameter(Uint8List.fromList(List.generate(32, (i) => i))));
    return secureRandom.nextBytes(16);
  }

  BigInt deriveSharedSecret(
      pc.ECPrivateKey privateKey, pc.ECPublicKey publicKey) {
    var dh = pc.ECDHBasicAgreement();
    dh.init(privateKey);
    return dh.calculateAgreement(publicKey);
  }

  Future<String> encryptMessage(
      String message, String recipientPublicKeyBase64) async {
    var params = pc.ECCurve_secp256k1();
    var recipientPublicKey = parsePublicKey(recipientPublicKeyBase64, params);

    var senderPrivateKeyBase64 = await KeyStorage().retrievePrivateKey();
    var senderPrivateKey = parsePrivateKey(senderPrivateKeyBase64!, params);

    BigInt sharedSecret =
        deriveSharedSecret(senderPrivateKey, recipientPublicKey);
    Uint8List aesKey = deriveKeyFromSecret(sharedSecret);

    Uint8List iv = generateIV(); // Generate a new IV for each message
    return encryptAES(message, aesKey, iv);
  }

  Uint8List deriveKeyFromSecret(BigInt sharedSecret, {int length = 32}) {
    var hmac = pc.HMac(pc.SHA256Digest(), 64);
    hmac.init(pc.KeyParameter(sharedSecret.toUint8Array()));
    var result = Uint8List(hmac.macSize);
    hmac.update(
        sharedSecret.toUint8Array(), 0, sharedSecret.toUint8Array().length);
    hmac.doFinal(result, 0);
    return result.sublist(0, length);
  }
}

extension BigIntExtension on BigInt {
  Uint8List toUint8Array() {
    String hexString = toRadixString(16);
    if (hexString.length % 2 != 0) hexString = '0' + hexString;
    return Uint8List.fromList(hex.decode(hexString));
  }
}
