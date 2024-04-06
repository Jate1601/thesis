import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Homescreen',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Press here to manage your user',
            onPressed: () {
              User? user = FirebaseAuth.instance.currentUser;
              user == null
                  ? Navigator.pushNamed(context, '/Login')
                  : Navigator.pushNamed(context, '/Logout');
            },
            icon: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Initiating connection with firebase....'),
      ),
    );
  }
}
