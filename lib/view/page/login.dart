import 'package:enfp/presenter/firebase/auth/auth.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:enfp/view/widget/button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/image/logo.png',
              width: 150.0,
              fit: BoxFit.fitHeight,
            ),
            Positioned(
              bottom: 100.0,
              child: EButton(
                text: LangP.makeSentence('login', 'google'),
                onPressed: () => AuthP.eLogin(LoginType.google),
              ),
            ),
          ],
        ),
      ),
    );
  }
}