import 'package:dynamic_cast/constants.dart';
import 'package:dynamic_cast/gui/components/input_boxes.dart';
import 'package:dynamic_cast/i18n/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SignType {
  SignIn,
  SignUp,
}

class CredentialScreen extends StatefulWidget {
  final SignType type;
  CredentialScreen(SignType type) : this.type = type;

  @override
  _State createState() {
    return _State(type);
  }
}

class _State extends State<CredentialScreen> {
  final _formKey = GlobalKey<FormState>();
  final SignType type;

  _State(SignType type) : this.type = type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type == SignType.SignUp ? str.signUp : str.signIn),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                makeEmailInput(context),
                SizedBox(height: 20),
                PasswordTextField(hasHint: type == SignType.SignUp),
                if (type == SignType.SignIn)
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: TextButton(
                      onPressed: () {/* TODO: Implement */},
                      child: Text(str.forgotPassword),
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(LARGE_BUTTON_PADDING),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        /* TODO: Implement */
                      }
                    },
                    child: Text(str.next),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
