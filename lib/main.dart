import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thesis/GUI/User/logout.dart';
import 'Firestore/auth_wrapper.dart';
import 'GUI/Settings/settings_screen.dart';
import 'GUI/User/login.dart';
import 'GUI/create_chat_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AuthWrapper(),
      routes: {
        '/Login': (context) => const Login(),
        '/Logout': (context) => const Logout(),
        '/CreateChat': (context) => const CreateChatScreen(),
        '/Settings': (context) => SettingsScreen(),
      },
      title: 'Thesis Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.indigo,
          secondary: Colors.black,
          primaryContainer: Colors.blueAccent,
          background: Colors.blueGrey,
        ),
        useMaterial3: true,
      ),
    );
  }
}
