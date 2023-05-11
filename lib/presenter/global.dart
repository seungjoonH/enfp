import 'package:enfp/presenter/model/user.dart';
import 'package:enfp/presenter/page/camera.dart';
import 'package:enfp/presenter/page/friend/friend.dart';
import 'package:enfp/presenter/page/friend/search.dart';
import 'package:enfp/presenter/page/home.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:enfp/presenter/page/ranking.dart';
import 'package:enfp/presenter/page/register.dart';
import 'package:enfp/presenter/page/setting.dart';
import 'package:enfp/presenter/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalP extends GetxController {
  static Future init() async {
    final globalP = Get.find<GlobalP>();
    globalP.navIndex = 0;
    globalP.update();
  }

  ThemeMode mode = ThemeMode.light;

  void toggleThemeMode() {
    mode = ThemeMode.values[3 - mode.index];
    update();
  }

  int navIndex = 0;

  void navigate(int index) {
    [
      HomeP.toHome, FriendP.toFriend,
      RankingP.toRanking, SettingP.toSetting,
    ][index]();
    navIndex = index;
    update();
  }

  static void initControllers() {
    Get.put(GlobalP());

    Get.put(UserP());

    Get.put(LangP());
    Get.put(RegisterP());
    Get.put(HomeP());
    Get.put(FriendP());
    Get.put(SearchP());
    Get.put(RankingP());
    Get.put(SettingP());
    Get.put(CameraP());

    Get.put(InputP());
  }
}