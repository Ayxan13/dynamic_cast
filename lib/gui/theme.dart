import 'package:flutter/material.dart';

enum AppTheme {
  light,
}

CusomTheme get customTheme => _theme;

abstract class CusomTheme {
  Color get backInfoTextClr;
}

class _LightTheme implements CusomTheme {
  @override
  Color get backInfoTextClr => Colors.grey;
}

CusomTheme _theme = new _LightTheme();
