import 'package:flutter/material.dart';

enum AppTheme {
  light,
}

CusomTheme get customTheme => _theme;

abstract class CusomTheme {
  Color get backInfoTextClr;
  MaterialColor get primarySwatch;
}

class _LightTheme implements CusomTheme {
  @override
  Color get backInfoTextClr => Colors.grey;

  @override
  MaterialColor get primarySwatch => Colors.blue;
}

CusomTheme _theme = new _LightTheme();
