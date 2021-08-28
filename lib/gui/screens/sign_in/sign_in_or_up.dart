import 'package:dynamic_cast/constants.dart';
import 'package:dynamic_cast/gui/custom_theme.dart';
import 'package:dynamic_cast/gui/screens/sign_in/credential_screen.dart';
import 'package:dynamic_cast/i18n/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInOrUpScreen extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                // TODO: Implement skip
              },
              icon: Icon(Icons.close))
        ],
      ),
      body: _SignInOrUpBody(),
    );
  }
}

class _SignInOrUpBody extends StatelessWidget {
  Widget _accountLogo(final BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.7,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Icon(
          Icons.add_reaction_sharp,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _accountLogoCaption() {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 5, 30, 5),
      child: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                str.signInOrUp,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 23,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              str.signUpBenefits,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: customTheme.backInfoTextClr,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _signUpButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(LARGE_BUTTON_PADDING),
      ),
      onPressed: () => {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (final context) {
            return CredentialScreen(SignType.SignUp);
          }),
        ),
      },
      child: Text(str.signUp),
    );
  }

  Widget _skipSignInButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        // TODO: implement
      },
      child: Text(str.skip),
    );
  }

  Widget _signInButton(BuildContext context) {
    return TextButton(
      onPressed: () => {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (final context) {
            return CredentialScreen(SignType.SignIn);
          }),
        ),
      },
      child: Text(str.signIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _accountLogo(context),
            _accountLogoCaption(),
            Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _signUpButton(context),
                  _signInButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
