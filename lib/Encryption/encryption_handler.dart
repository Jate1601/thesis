import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' as pc;
import '../KeyHandling/key_handling.dart'; // Import path needs to be correct

class EncryptionHandler {
  final KeyStorage keyStorage;
  final Random secureRandom = Random.secure();

  EncryptionHandler(this.keyStorage);

  Future<Uint8List> generateSharedSecret(String remoteUserId) async {
    String? localPrivateKeyBase64 = await keyStorage.retrievePrivateKey();
    String remotePublicKeyBase64 =
        await keyStorage.getPublicKeyFromFirebase(remoteUserId);

    if (localPrivateKeyBase64 == null)
      throw Exception("Local private key is null");

    pc.ECPrivateKey localPrivateKey =
        _decodeECPrivateKey(localPrivateKeyBase64);
    pc.ECPublicKey remotePublicKey = _decodeECPublicKey(remotePublicKeyBase64);

    var generator = pc.ECDHBasicAgreement();
    generator.init(localPrivateKey);
    BigInt agreementResult = generator.calculateAgreement(remotePublicKey);
    return bigIntToUint8List(agreementResult);
  }

  pc.ECPrivateKey _decodeECPrivateKey(String base64Key) {
    Uint8List privateKeyBytes = base64Decode(base64Key);
    return pc.ECPrivateKey(
        decodeBigInt(privateKeyBytes), pc.ECCurve_secp256k1());
  }

  pc.ECPublicKey _decodeECPublicKey(String base64Key) {
    Uint8List publicKeyBytes = base64Decode(base64Key);
    pc.ECDomainParameters params = pc.ECCurve_secp256k1();
    return pc.ECPublicKey(params.curve.decodePoint(publicKeyBytes), params);
  }

  BigInt decodeBigInt(Uint8List bytes) {
    return BigInt.parse(
        bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(),
        radix: 16);
  }

  Uint8List deriveKey(Uint8List sharedSecret) {
    var digest = pc.Digest('SHA-256');
    return Uint8List.fromList(digest.process(sharedSecret));
  }

  Future<String> encryptMessage(String message, Uint8List sharedSecret) {
    var key = deriveKey(sharedSecret);
    var iv = generateRandomIV();
    var keyParam = pc.KeyParameter(key);
    var ivParam = pc.ParametersWithIV<pc.KeyParameter>(keyParam, iv);
    var paddedBlockParam = pc.PaddedBlockCipherParameters(
        ivParam, null); // Correctly specify parameters

    var paddedCipher = pc.PaddedBlockCipher("AES/CBC/PKCS7")
      ..init(true, paddedBlockParam); // true for encryption

    var ciphertext = paddedCipher.process(utf8.encode(message));
    var combinedIVAndCiphertext = Uint8List.fromList(
        iv + ciphertext); // Combine IV and ciphertext for transmission
    return Future.value(base64Encode(combinedIVAndCiphertext));
  }

  Future<String> decryptMessage(
      String encryptedMessage, Uint8List sharedSecret) async {
    var key = deriveKey(sharedSecret);
    var combinedIVAndCiphertext = base64Decode(encryptedMessage);
    var iv = Uint8List.fromList(
        combinedIVAndCiphertext.sublist(0, 16)); // Extract the IV
    var ciphertext =
        combinedIVAndCiphertext.sublist(16); // Extract the ciphertext

    var keyParam = pc.KeyParameter(key);
    var ivParam = pc.ParametersWithIV<pc.KeyParameter>(keyParam, iv);
    var paddedBlockParam = pc.PaddedBlockCipherParameters(
        ivParam, null); // Correctly specify parameters

    var paddedCipher = pc.PaddedBlockCipher("AES/CBC/PKCS7")
      ..init(false, paddedBlockParam); // false for decryption

    var decryptedBytes = paddedCipher.process(ciphertext);
    return utf8.decode(decryptedBytes);
  }

  Uint8List bigIntToUint8List(BigInt bigInt) {
    // Get the byte array in big-endian form
    var bigIntBytes =
        bigInt.toRadixString(16).padLeft((bigInt.bitLength + 7) >> 3 << 1, '0');
    // Convert hex string to byte array
    return Uint8List.fromList(Iterable.generate(
            bigIntBytes.length ~/ 2,
            (i) =>
                int.parse(bigIntBytes.substring(i * 2, i * 2 + 2), radix: 16))
        .toList());
  }

  Uint8List generateRandomIV() {
    return Uint8List.fromList(
        List<int>.generate(16, (_) => secureRandom.nextInt(256)));
  }
}
