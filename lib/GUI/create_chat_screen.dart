import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:thesis/Firebase/create_chat.dart';

class CreateChatScreen extends StatefulWidget {
  const CreateChatScreen({Key? key}) : super(key: key);

  @override
  _CreateChatScreenState createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen>
    with WidgetsBindingObserver {
  final _receiverIdController = TextEditingController();
  final MobileScannerController _mobileScannerController =
      MobileScannerController(
    facing: CameraFacing.back,
  );

  StreamSubscription<Object?>? _streamSubscription;

  void _handleBarcode(Barcode barcode) {
    if (barcode != null) {
      print(barcode.rawValue ?? "No Data found in QR");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _streamSubscription =
            _mobileScannerController.barcodes.listen(_handleBarcode);

        unawaited(_mobileScannerController.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_streamSubscription?.cancel());
        _streamSubscription = null;
        unawaited(_mobileScannerController.stop());
    }
  }

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _streamSubscription =
        _mobileScannerController.barcodes.listen(_handleBarcode);

    // Finally, start the scanner itself.
    unawaited(_mobileScannerController.start());
  }

  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_streamSubscription?.cancel());
    _streamSubscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    //await _mobileScannerController.dispose();
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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: SizedBox(
                  height: 200.0,
                  width: 200.0,
                  child: MobileScanner(onDetect: (barcode, _) {
                    if (barcode != null) {
                      print(barcode.rawValue ?? "No Data found in QR");
                    }
                  }),
                ),
              );
            },
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
