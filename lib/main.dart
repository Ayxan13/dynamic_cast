import 'package:dynamic_cast/gui/custom_theme.dart';
import 'package:dynamic_cast/gui/screens/dashboards/dashboard.dart';
import 'package:dynamic_cast/i18n/translation.dart';
import 'package:flutter/material.dart';

void main() => runApp(TheApp());

class TheApp extends StatelessWidget {
  const TheApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: str.appName,
      theme: ThemeData(
        primaryColor: customTheme.primaryClr,
        primarySwatch: customTheme.primarySwatch,
      ),
      home: DashBoard(),
    );
  }
}
