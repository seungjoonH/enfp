import 'package:enfp/presenter/firebase/auth/auth.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:enfp/view/widget/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: AuthP.eLogout,
            child: Text(LangP.find('logout')),
          ),
        ),
      ),
      bottomNavigationBar: const EBottomNavigationBar(),
    );
  }
}
