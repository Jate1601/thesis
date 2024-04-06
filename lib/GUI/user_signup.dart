import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Firebase/firebase_handlers.dart';
import '../support/supporting_functions.dart';

//TODO once sign in is set up, fix encryption on Password and email

class UserSignup extends StatefulWidget {
  @override
  _UserSignupState createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: const Text('User sign up'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              autocorrect: false,
              textAlign: TextAlign.center,
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
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  child: const Text('Confirm'),
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    final String email = _emailController.text.trim();
                    final String password = _passwordController.text.trim();
                    if (!isValidEmail(email)) {
                      showSnackBar("Please enter a valid email address.");
                      return;
                    }
                    if (!isValidPasswordLength(password)) {
                      showSnackBar("Password must be at least 9 characters.");
                      return;
                    }
                    if (!isValidPasswordFormat(password)) {
                      showSnackBar(
                          "Password must contain a capital letter, a number and a symbol.");
                      return;
                    }
                    showSnackBar("Account created. Window now closing.");
                    await signUp(email, password).then(
                      (_) {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
