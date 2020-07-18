import 'package:flutter/material.dart';
import 'package:flutterthanossnapexample/read_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReadListScreen(),
    );
  }
}
