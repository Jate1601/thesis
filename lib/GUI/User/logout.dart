import 'package:flutter/material.dart';
import 'package:thesis/Firebase/firebase_handlers.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
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
        child: ElevatedButton(
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
      ),
    );
  }
}
