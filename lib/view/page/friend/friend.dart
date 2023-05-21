import 'package:enfp/global/string.dart';
import 'package:enfp/global/theme.dart';
import 'package:enfp/model/class/user.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:enfp/presenter/page/friend/search.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:enfp/view/widget/bottom_bar.dart';
import 'package:enfp/view/widget/card.dart';
import 'package:enfp/view/widget/input_field.dart';
import 'package:enfp/view/widget/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserP>(
      builder: (userP) {
        List<EUser> friends = userP.loggedUser!.friends;

        return Scaffold(
          appBar: AppBar(
            leading: Container(),
            title: Material(
              color: Theme.of(context).colorScheme.outlineVariant.withOpacity(.5),
              borderRadius: BorderRadius.circular(8.0),
              child: InkWell(
                onTap: SearchP.toSearch,
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  width: 250.0, height: 30.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LangP.find('search'),
                        style: textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      Icon(
                        Icons.search,
                        size: 20.0,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ECard(
                    title: capitalizeFirstChar(LangP.find('friend')),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: friends.map((friend) => Container(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              ProfileImageWidget(user: friend),
                              const SizedBox(width: 20.0),
                              SizedBox(
                                width: 180.0,
                                child: Text(friend.nickname, style: textTheme.titleLarge),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const EBottomNavigationBar(),
        );
      }
    );
  }
}
