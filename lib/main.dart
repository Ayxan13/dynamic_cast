import 'package:dynamic_cast/gui/screens/sign_in/sign_in_or_up.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TheApp());
}

class TheApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInOrUpScreen(),
    );
  }
}
