import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserMenu extends StatefulWidget {
  @override
  _UserMenuState createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.secondary),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Auth menu',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        body: Column(
          children: [
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Create account'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Logout'),
            ),
          ],
        ));
  }
}
