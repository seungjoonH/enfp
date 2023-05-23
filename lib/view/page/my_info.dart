import 'package:enfp/global/string.dart';
import 'package:enfp/model/enum/sex.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:enfp/presenter/page/my_info.dart';
import 'package:enfp/view/widget/card.dart';
import 'package:enfp/view/widget/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({Key? key}) : super(key: key);

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyInfoP>(
        builder: (myInfoP) {
          return Scaffold(
            appBar: AppBar(
              title: Text(capitalizeFirstChar(LangP.find('myInfo'))),
              actions: [
                IconButton(
                  icon: Text(LangP.find('save')),
                  onPressed: myInfoP.submit,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    InputCard(keyword: 'nickname'),
                    const SizedBox(height: 20.0),
                    InputCard(keyword: 'birth'),
                    const SizedBox(height: 20.0),
                    InputCard(keyword: 'height', keyboardType: TextInputType.number),
                    const SizedBox(height: 20.0),
                    InputCard(keyword: 'weight', keyboardType: TextInputType.number),
                    const SizedBox(height: 20.0),
                    InputCard(keyword: 'goal', keyboardType: TextInputType.number),
                    const SizedBox(height: 100.0),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}