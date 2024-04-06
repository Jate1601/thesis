import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Homescreen'),
        actions: [
          IconButton(
            tooltip: 'Press here to manage your user',
            onPressed: () {
              Navigator.pushNamed(context, '/User');
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: const Center(
        child: Text('Initiating connection with firebase....'),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            print('testing');
          },
          label: Text('Press me')),
    );
  }
}
