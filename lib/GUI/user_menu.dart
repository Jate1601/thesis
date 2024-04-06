import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thesis/GUI/user_signup.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userNameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
              textAlign: TextAlign.center,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              children: [
                ElevatedButton(
                  child: const Text(
                    'Create account',
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => UserSignup(),
                    );
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  child: const Text(
                    'Login',
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            /*
            ElevatedButton(
              onPressed: () {},
              child: Text('Logout'),
            ),
             */
          ],
        ));
  }
}
