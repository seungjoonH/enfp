import 'package:enfp/global/theme.dart';
import 'package:enfp/presenter/page/friend/search.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:enfp/view/widget/bottom_bar.dart';
import 'package:enfp/view/widget/card.dart';
import 'package:enfp/view/widget/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchP>(
      builder: (searchP) {
        return Scaffold(
          appBar: AppBar(
            title: EInputField(
              controller: null,
              hintText: LangP.find('search'),
              mini: true,
              autofocus: true,
              onChanged: searchP.loadUsers,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: searchP.strangers.isEmpty ? Container() : ECard(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: searchP.strangers.map((user) => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          'https://pbs.twimg.com/profile_images/1485050791488483328/UNJ05AV8_400x400.jpg',
                          width: 40.0, height: 40.0,
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 160.0,
                        child: Text(user.nickname, style: textTheme.titleMedium),
                      ),
                      const SizedBox(width: 20.0),
                      TextButton(
                        onPressed: () => searchP.addFriend(user.uid),
                        child: Text(LangP.find('add')),
                      ),
                    ],
                  )).toList(),
                ),
              ),
            ),
          ),
          bottomNavigationBar: const EBottomNavigationBar(),
        );
      }
    );
  }
}
