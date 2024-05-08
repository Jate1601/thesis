import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences _prefs;
  bool _prefsInitialized = false;
  bool _biometricAuthenticationEnabled = false;
  bool _authenticationAppEnabled = false;

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
      _prefsInitialized = true;
    });
  }

  Future<void> _saveSettings() async {
    await _prefs.setBool(
        'biometricAuthenticationEnabled', _biometricAuthenticationEnabled);
    await _prefs.setBool('authenticationAppEnabled', _authenticationAppEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Settings',
          ),
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
                onChanged: (value) {
                  setState(() {
                    _authenticationAppEnabled = value;
                    _saveSettings();
                  });
                },
              ),
            ],
          ),
        ));
  }
}
