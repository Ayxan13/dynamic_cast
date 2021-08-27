import 'package:dynamic_cast/constants.dart';
import 'package:dynamic_cast/i18n/translation.dart';
import 'package:flutter/material.dart';

OutlineInputBorder _textInputOutline(final Color color, final bool focused) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: color,
      width: focused ? 2 : 1,
    ),
  );
}

TextFormField makeEmailInput(BuildContext context) {
  final theme = Theme.of(context);
  return TextFormField(
    validator: (value) {
      if (value == null || value.isEmpty) {
        return str.enterEmail;
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: str.email,
      focusedBorder: _textInputOutline(theme.accentColor, true),
      enabledBorder: _textInputOutline(theme.disabledColor, false),
      prefixIcon: Icon(Icons.email_outlined),
    ),
  );
}

class PasswordTextField extends StatefulWidget {
  late final _PasswordTextFieldState state;

  @override
  State<StatefulWidget> createState() {
    state = _PasswordTextFieldState();
    return state;
  }
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _passwordIsVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      validator: (value) {
        if (value == null || value.length < PASSWORD_MIN_LENGTH)
          return str.passwordHasMinSize;

        return null;
      },
      enableSuggestions: false,
      autocorrect: false,
      obscureText: !_passwordIsVisible,
      decoration: InputDecoration(
          labelText: str.password,
          focusedBorder: _textInputOutline(theme.accentColor, true),
          enabledBorder: _textInputOutline(theme.disabledColor, false),
          prefixIcon: Icon(Icons.vpn_key),
          suffixIcon: GestureDetector(
            child: Icon(
              !_passwordIsVisible ? Icons.visibility : Icons.visibility_off,
              color: theme.disabledColor,
            ),
            onTap: () {
              setState(() {
                _passwordIsVisible = !_passwordIsVisible;
              });
            },
          ),
          helperText: str.passwordHasMinSize,
          helperStyle: TextStyle(
            color: theme.disabledColor,
          )),
    );
  }
}
