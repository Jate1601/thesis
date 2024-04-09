import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis/Firebase/retrieve_chats.dart';
import 'package:thesis/GUI/Chat/chatscreen.dart';
import 'package:thesis/support/app_config.dart';

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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Column(
          children: [
            Text(
              'Homescreen ',
            ),
            Text(
              FirebaseAuth.instance.currentUser!.uid, // TODO Remove this line
              overflow: TextOverflow.fade,
            ),
          ],
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
                // TODO make this look better
                return ListTile(
                  tileColor: Theme.of(context).colorScheme.primaryContainer,
                  title: Text('Chat $chatId'),
                  subtitle: Text('Participants: ${participants.join(", ")}'),
                  onTap: () {
                    final String receiverId;
                    if (chatDocs?[index]['participants'][0] ==
                        FirebaseAuth.instance.currentUser?.uid) {
                      receiverId = chatDocs?[index]['participants'][1];
                    } else {
                      receiverId = chatDocs?[index]['participants'][0];
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                            chatId: orgChatId, receiverId: receiverId),
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  textColor: Theme.of(context).colorScheme.secondary,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pushNamed(context, '/CreateChat');
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add_box_outlined,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
