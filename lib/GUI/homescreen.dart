import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis/Firebase/send_message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

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
      ///////////////////
      body: ListView(
        children: [
          ListTile(
            title: Text('Chat #1'),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            onTap: () {
              // TODO Navigate to the selected chat screen
            },
          ),
          ListTile(
            title: Text('Chat #2'),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            onTap: () {
              // TODO Navigate to the selected chat screen
            },
          ),
          Text('Initiating connection with firebase....'),
        ],
      ),
      ////////////////////
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await sendMessage('Hello there', 'RaXMardrsWXvX3wRxHuK');
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.send,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
