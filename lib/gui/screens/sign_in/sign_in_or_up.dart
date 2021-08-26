import 'package:dynamic_cast/gui/theme.dart';
import 'package:dynamic_cast/i18n/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInOrUpScreen extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(str.appName),
      ),
      body: _SignInOrUpBody(),
    );
  }
}

class _SignInOrUpBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Expanded(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  Icons.add_reaction_sharp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 5, 30, 5),
            child: Center(
              child: Column(
                children: [
                  Text(
                    str.signInOrUp,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    str.signUpBenefits,
                    style: TextStyle(
                      color: customTheme.backInfoTextClr,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Container(
            margin: const EdgeInsets.all(15),
            // width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => {/* TODO: Implement */},
                  child: Text(str.signUp),
                ),
                TextButton(
                  onPressed: () => {/* TODO: Implement */},
                  child: Text(str.signIn),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
