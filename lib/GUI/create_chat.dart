import 'package:flutter/material.dart';

class CreateChat extends StatefulWidget {
  const CreateChat({super.key});

  @override
  _CreateChatState createState() => _CreateChatState();
}

class _CreateChatState extends State<CreateChat> {
  final _receiverIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Add new chat...',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _receiverIdController,
              decoration: const InputDecoration(
                labelText: 'ID of receiving user',
              ),
              textAlign: TextAlign.center,
              obscureText: false,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
