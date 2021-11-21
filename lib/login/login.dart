import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:quizapp/services/auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Will have a logo for the Quiz, and the login buttons
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const FlutterLogo(
              size: 150,
            ),
            // Google login
            Flexible(
              child: LoginButton(
                icon: FontAwesomeIcons.google,
                text: 'Sign In with Google',
                loginMethod: AuthService().googleLogin,
                color: Colors.blue,
              ),
            ),
            // Anonymous login
            Flexible(
              child: LoginButton(
                icon: FontAwesomeIcons.userNinja,
                text: 'Continue as Guest',
                loginMethod: AuthService().anonLogin,
                color: Colors.deepPurple,
              ),
            ),
            // // Apple login (not in use)
            // FutureBuilder<Object>(
            //   future: SignInWithApple.isAvailable(),
            //   builder: (context, snapshot) {
            //     if (snapshot.data == true) {
            //       return SignInWithAppleButton(
            //         onPressed: () {
            //           AuthService().signInWithApple();
            //         },
            //       );
            //     } else {
            //       return Container();
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

// Generic button to be used for different logins
class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {Key? key,
      required this.text,
      required this.icon,
      required this.color,
      required this.loginMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      // Button calling the login method
      child: ElevatedButton.icon(
        onPressed: () => loginMethod(),
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(24),
          backgroundColor: color,
        ),
        label: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
