import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sbbwu_firebase/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDoDP97wsUQsjDA_tKvNbpYwjZMOIEaLD8',
      appId: '1:592549218872:android:467cb4c24a3e6d90f174cd',
      messagingSenderId: '592549218872',
      projectId: 'sbbwu-todo',
      storageBucket: 'sbbwu-todo.appspot.com'
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
