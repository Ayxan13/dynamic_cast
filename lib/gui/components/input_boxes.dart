import 'package:dynamic_cast/constants.dart';
import 'package:dynamic_cast/i18n/translation.dart';
import 'package:email_validator/email_validator.dart';
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

      if (!EmailValidator.validate(value)) return str.emailFormatWrong;

      return null;
    },
    decoration: InputDecoration(
      labelText: str.email,
      focusedBorder: _textInputOutline(theme.accentColor, true),
      enabledBorder: _textInputOutline(theme.disabledColor, false),
      focusedErrorBorder: _textInputOutline(theme.errorColor, true),
      errorBorder: _textInputOutline(theme.errorColor, false),
      prefixIcon: Icon(Icons.email_outlined),
    ),
  );
}

class PasswordTextField extends StatefulWidget {
  late final _PasswordTextFieldState state;
  final bool _hasHint;

  PasswordTextField({bool hasHint = true}) : this._hasHint = hasHint;

  @override
  State<StatefulWidget> createState() {
    state = _PasswordTextFieldState(hasHint: _hasHint);
    return state;
  }
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _passwordIsVisible = false;
  final bool _hasHint;

  _PasswordTextFieldState({bool hasHint = true}) : this._hasHint = hasHint;

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
          focusedErrorBorder: _textInputOutline(theme.errorColor, true),
          errorBorder: _textInputOutline(theme.errorColor, false),
          prefixIcon: Icon(Icons.password_outlined),
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
          helperText: _hasHint ? str.passwordHasMinSize : null,
          helperStyle: TextStyle(
            color: theme.disabledColor,
          )),
    );
  }
}
