import 'package:flutter/material.dart';
import 'package:thesis/Firebase/create_chat.dart';
import 'package:thesis/GUI/QR/QRView.dart';

class CreateChatScreen extends StatefulWidget {
  const CreateChatScreen({Key? key}) : super(key: key);

  @override
  _CreateChatScreenState createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  final _receiverIdController = TextEditingController();

  void onBarCodeScanned(String scannedValue) {
    setState(() {
      _receiverIdController.text = scannedValue;
    });
  }

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
              onPressed: () {
                createChat(_receiverIdController.text.trim(), context);
                _receiverIdController.clear();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BarcodeScannerWithController(
                onBarcodeScanned: onBarCodeScanned,
              ),
            ),
          );
        },
        backgroundColor: Colors.white,
        label: Text(
          'Scan QR Code',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        icon: Icon(
          Icons.camera,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
