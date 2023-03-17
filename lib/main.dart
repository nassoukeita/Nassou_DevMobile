import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login/pageLogin.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const Color miagedColor = Color(0xFF137f8b);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Miage',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: PageLogin(),
    );
  }
}