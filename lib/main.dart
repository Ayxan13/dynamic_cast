import 'package:dynamic_cast/gui/custom_theme.dart';
import 'package:dynamic_cast/gui/screens/dashboards/dashboard.dart';
import 'package:dynamic_cast/i18n/translation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
// TODO: Performance tests

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

late FirebaseAnalytics firebaseAnalytics;

void main() {
  firebaseAnalytics = FirebaseAnalytics();

  try {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  } catch (error) {
    print(error);
  }

  runApp(TheApp());
}

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
