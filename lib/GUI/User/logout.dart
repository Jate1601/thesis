import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../Firestore/firebase_handlers.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  Widget _generateQRCode() {
    if (FirebaseAuth.instance.currentUser!.uid != null) {
      return SizedBox(
        width: 200.0,
        height: 200.0,
        child: QrImageView(
          data: FirebaseAuth.instance.currentUser!.uid,
          version: QrVersions.auto,
          size: 200.0,
          /*
            eyeStyle: const QrEyeStyle(
            color: Colors.black,
            eyeShape: QrEyeShape.square,
          ),
          dataModuleStyle: const QrDataModuleStyle(
            color: Colors.black,
            dataModuleShape: QrDataModuleShape.square,
          ),*/
          eyeStyle: QrEyeStyle(
            color: Theme.of(context).colorScheme.primary,
            eyeShape: QrEyeShape.circle,
          ),
          dataModuleStyle: QrDataModuleStyle(
            color: Theme.of(context).colorScheme.primary,
            dataModuleShape: QrDataModuleShape.circle,
          ),
        ),
      );
    } else {
      return const Text('Error: User is not logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'User settings',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        'Your QR Code',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: _generateQRCode(),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Close',
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('QR Code'),
            ),
            ElevatedButton(
              child: const Text('Logout'),
              onPressed: () async {
                await signOut().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User successfully signed out'),
                    ),
                  );
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
