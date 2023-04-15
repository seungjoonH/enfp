import 'package:enfp/global/theme.dart';
import 'package:enfp/presenter/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EBottomNavigationBar extends StatelessWidget {
  const EBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(40.0)),
      child: GetBuilder<GlobalP>(
        builder: (globalP) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).colorScheme.background,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: globalP.navIndex,
            onTap: globalP.navigate,
            items: List.generate(4, (index) => BottomNavigationBarItem(
              icon: Icon([
                Icons.home, Icons.person, Icons.star, Icons.settings
              ][index]),
              label: ['Home', 'Friend', 'Ranking', 'Setting'][index],
            )),
          );
        }
      ),
    );
  }
}