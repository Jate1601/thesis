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
          title: Text('Auth menu'),
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
