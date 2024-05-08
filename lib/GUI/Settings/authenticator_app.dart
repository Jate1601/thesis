/*

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:otp/otp.dart';

class AuthenticatorApp {
  final storage = FlutterSecureStorage();

  String generateSecretKey() {
    return OTP.randomSecret();
  }

  bool verifyOtp(String enteredOtp, String storedSecret) {
    // Get the current Unix timestamp in seconds
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    // Time step for TOTP is usually 30 seconds
    int timeStep = 30;
    // Adjusting for the correct time step
    int timeStamp = currentTime ~/ timeStep;

    // Generate the OTP using the secret and timestamp
    String generatedOtp = OTP.generateTOTPCodeString(storedSecret, timeStamp,
        algorithm: Algorithm.SHA1, length: 6);

    return enteredOtp == generatedOtp;
  }

  Future<void> storeSecretKey(String secret) async {
    await storage.write(key: 'totp_secret', value: secret);
  }

  Future<String?> getSecretKey() async {
    return await storage.read(key: 'totp_secret');
  }

  void enableAuthenticationApp() async {
    String secret = generateSecretKey();
    await storeSecretKey(secret);
    setState(() {
      _displaySecret = secret;
      _authenticationAppEnabled = true;
    });
    _saveSettings();
  }

  void verifyAndSaveAppSetup(Context context) async {
    String? storedSecret = await getSecretKey();
    if (storedSecret != null && verifyOtp(_otpController.text, storedSecret)) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Verification Successful'),
          content:
              const Text('Your authentication app is now linked successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Verification Failed'),
          content:
              const Text('The entered OTP is incorrect. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}
*/
