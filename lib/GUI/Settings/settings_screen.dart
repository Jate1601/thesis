import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricAuthenticationEnabled = false;
  bool _authenticationAppEnabled = false;

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
                  // Save the state to the device (e.g., SharedPreferences)
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
                  // Save the state to the device (e.g., SharedPreferences)
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
