import 'package:flutter/material.dart';

enum AppTheme {
  light,
}

CusomTheme get customTheme => _theme;

abstract class CusomTheme {
  Color get backInfoTextClr;
  Color get primaryClr;
  MaterialColor get primarySwatch;
  Color get disabledColor;
}

class _LightTheme implements CusomTheme {
  @override
  Color get backInfoTextClr => Colors.grey;

  @override
  MaterialColor get primarySwatch => Colors.blue;

  @override
  Color get disabledColor => Colors.blue.shade300;

  @override
  Color get primaryClr => Colors.blue.shade500;
}

CusomTheme _theme = new _LightTheme();
