import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rentales_books/add_book.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rentales',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: addBook(),
    );
  }
}



