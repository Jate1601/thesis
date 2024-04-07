import 'package:flutter/material.dart';
import 'package:thesis/Firebase/firebase_handlers.dart';
import 'package:thesis/GUI/User/signup.dart';

import '../../support/supporting_functions.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Login menu',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            textAlign: TextAlign.center,
            obscureText: true,
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
                    builder: (context) => const Signup(),
                  );
                },
              ),
              const Spacer(),
              ElevatedButton(
                child: const Text(
                  'Login',
                ),
                onPressed: () async {
                  final String email = _emailController.text.trim();
                  final String pass = _passwordController.text.trim();
                  try {
                    await signIn(email, pass);
                    showSnackBar('User successfully logged in', context);
                  } catch (e) {
                    showSnackBar(e.toString(), context);
                  }
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _passwordController.text = "Test123@!";
          _emailController.text = "test@test.com";
        },
        label: Text('Deets'),
      ),
    );
  }
}
