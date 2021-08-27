import 'package:dynamic_cast/constants.dart';
import 'package:dynamic_cast/gui/components/input_boxes.dart';
import 'package:dynamic_cast/i18n/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _State createState() {
    return _State();
  }
}

class _State extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(str.signUp),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              makeEmailInput(context),
              SizedBox(height: 20),
              PasswordTextField(),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(LARGE_BUTTON_PADDING),
                  ),
                  onPressed: () => {
                    if (_formKey.currentState!.validate())
                      {
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
    );
  }
}
