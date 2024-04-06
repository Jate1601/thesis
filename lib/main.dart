import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thesis/GUI/homescreen.dart';
import 'GUI/user_menu.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/User': (context) => UserMenu(),
      },
      title: 'Thesis Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.deepPurpleAccent,
          secondary: Colors.greenAccent,
          brightness: Brightness.dark,
          background: Colors.grey,
        ),
        useMaterial3: true,
      ),
    );
  }
}
