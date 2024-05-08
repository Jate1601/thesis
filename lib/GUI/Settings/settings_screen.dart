import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:otp/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as timezone;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences _prefs;
  bool _biometricAuthenticationEnabled = false;
  bool _authenticationAppEnabled = false;
  final storage = FlutterSecureStorage();
  String? _displaySecret;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _biometricAuthenticationEnabled =
          _prefs.getBool('biometricAuthenticationEnabled') ?? false;
      _authenticationAppEnabled =
          _prefs.getBool('authenticationAppEnabled') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    await _prefs.setBool(
        'biometricAuthenticationEnabled', _biometricAuthenticationEnabled);
    await _prefs.setBool('authenticationAppEnabled', _authenticationAppEnabled);
  }

  String generateSecretKey() {
    return OTP.randomSecret();
  }

  bool verifyOtp(String enteredOtp, String storedSecret) {
    final now = DateTime.now();
    int currentTime = now.millisecondsSinceEpoch ~/ 1000;
    int timeStep = 30;
    int timeStamp = currentTime ~/ timeStep;

    // Explicitly setting the interval to ensure it's used in the calculation
    String generatedOtp = OTP.generateTOTPCodeString(
      storedSecret,
      timeStamp,
      algorithm: Algorithm.SHA256,
      interval: timeStep,
      length: 6,
      isGoogle: true,
    );

    print("Current Time: $currentTime");
    print("Time Step: $timeStep");
    print("Time Stamp: $timeStamp");
    print("Generated OTP: $generatedOtp");
    print("Stored Secret: $storedSecret");
    print("Entered auth OTP : $enteredOtp");
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

  void verifyAndSaveAppSetup() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              subtitle: const Text('Facial recognition'),
              title: const Text('Biometric Authentication'),
              value: _biometricAuthenticationEnabled,
              inactiveTrackColor: Theme.of(context).colorScheme.error,
              activeTrackColor: Colors.greenAccent,
              onChanged: (value) {
                setState(() {
                  _biometricAuthenticationEnabled = value;
                  _saveSettings();
                });
              },
            ),
            SwitchListTile(
              title: const Text('Authentication App'),
              value: _authenticationAppEnabled,
              inactiveTrackColor: Theme.of(context).colorScheme.error,
              activeTrackColor: Colors.greenAccent,
              onChanged: (bool value) {
                if (value) {
                  enableAuthenticationApp();
                } else {
                  setState(() {
                    _authenticationAppEnabled = value;
                    _displaySecret = null;
                  });
                  _saveSettings();
                }
              },
            ),
            //if (_authenticationAppEnabled && _displaySecret != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () async {
                    Clipboard.setData(
                        ClipboardData(text: _displaySecret.toString()));
                  },
                  child: Text(
                    'Secret Key: $_displaySecret',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Enter this key into your authentication app manually, and enter the OTP here for verification:',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                TextField(
                  controller: _otpController,
                  decoration: InputDecoration(
                    labelText: 'OTP',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: verifyAndSaveAppSetup,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
