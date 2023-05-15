import 'package:enfp/global/string.dart';
import 'package:enfp/global/theme.dart';
import 'package:enfp/model/enum/lang.dart';
import 'package:enfp/presenter/firebase/auth/auth.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:enfp/view/widget/profile_image.dart';
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
        final userP = Get.find<UserP>();

        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ECard(
                  width: double.infinity,
                  title: capitalizeFirstChar(LangP.find('profile')),
                  child: Row(
                    children: [
                      ProfileImageWidget(size: 80.0),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 180.0,
                        child: Text(userP.loggedUser.nickname, style: textTheme.titleLarge),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20.0),
                ECard(
                  width: double.infinity,
                  title: capitalizeFirstChar(LangP.find('language')),
                  child: const Center(child: LanguageSelectButton()),
                ),
                const SizedBox(height: 20.0),
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

