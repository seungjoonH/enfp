import 'package:enfp/global/string.dart';
import 'package:enfp/model/enum/lang.dart';
import 'package:enfp/presenter/firebase/auth/auth.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:enfp/view/widget/bottom_bar.dart';
import 'package:enfp/view/widget/card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LangP>(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ECard(
                  width: double.infinity,
                  title: capitalizeFirstChar(LangP.find('language')),
                  child: const Center(child: LanguageSelectButton()),
                ),
                ElevatedButton(
                  onPressed: AuthP.eLogout,
                  child: Text(LangP.find('logout')),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const EBottomNavigationBar(),
        );
      }
    );
  }
}

class LanguageSelectButton extends StatelessWidget {
  const LanguageSelectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LangP>(
      builder: (langP) {
        return Container(
          width: 200.0,
          child: SegmentedButton<Lang>(
            segments: Lang.values.map((lang) => ButtonSegment<Lang>(
              value: lang,
              label: Text(lang.inverseString),
            )).toList(),
            selected: <Lang>{ LangP.lang },
            onSelectionChanged: (langSet) => langP.setLang(langSet.first),
          ),
        );
      }
    );
  }
}

