import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis/Firebase/retrieve_chats.dart';
import 'package:thesis/Firebase/send_message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RetrieveChats _retrieveChats =
      RetrieveChats(); // Create an instance of RetrieveChats

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
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: _retrieveChats.getUserChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const Center(
              child: Text('No chats yet'),
            );
          } else {
            final chatDocs = snapshot.data;
            return ListView.builder(
              itemCount: chatDocs?.length,
              itemBuilder: (ctx, index) {
                final chatId = chatDocs?[index].id;
                final participants = chatDocs?[index]['participants'];

                return ListTile(
                  title: Text('Chat $chatId'),
                  subtitle: Text('Participants: ${participants.join(", ")}'),
                  onTap: () {
                    print('pressed');
                  },
                );
              },
            );
          }
        },
      ),
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
