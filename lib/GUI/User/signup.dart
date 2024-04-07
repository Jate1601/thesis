import 'package:flutter/material.dart';
import '../../Firestore/firebase_handlers.dart';
import '../../support/supporting_functions.dart';

//TODO once sign in is set up, fix encryption on Password and email

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                      showSnackBar(
                          "Please enter a valid email address.", context);
                      return;
                    }
                    if (!isValidPasswordLength(password)) {
                      showSnackBar(
                          "Password must be at least 9 characters.", context);
                      return;
                    }
                    if (!isValidPasswordFormat(password)) {
                      showSnackBar(
                          "Password must contain a capital letter, a number and a symbol.",
                          context);
                      return;
                    }
                    showSnackBar(
                        "Account created. Window now closing.", context);
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
