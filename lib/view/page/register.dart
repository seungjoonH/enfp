import 'package:enfp/global/string.dart';
import 'package:enfp/model/enum/sex.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:enfp/presenter/page/register.dart';
import 'package:enfp/view/widget/card.dart';
import 'package:enfp/view/widget/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterP>(
      builder: (registerP) {
        return Scaffold(
          appBar: AppBar(
            title: Text(capitalizeFirstChar(LangP.find('register'))),
            actions: [
              // GetBuilder<GlobalP>(
              //   builder: (globalP) {
              //     return IconButton(
              //       icon: Icon([null, Icons.dark_mode, Icons.light_mode][globalP.mode.index]),
              //       onPressed: globalP.toggleThemeMode,
              //     );
              //   },
              // ),
              IconButton(
                icon: Text(LangP.find('next')),
                onPressed: registerP.submit,
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
                  ECard(
                    title: LangP.find('sex').toUpperCase(),
                    child: SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<Sex>(
                        segments: Sex.values.map((sex) => ButtonSegment(
                          value: sex,
                          label: Text(LangP.find(sex.name)),
                          icon: Icon([Icons.man, Icons.woman][sex.index]),
                        )).toList(),
                        selected: registerP.sexSet,
                        onSelectionChanged: registerP.selectSex,
                        emptySelectionAllowed: true,
                      ),
                    ),
                  ),
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