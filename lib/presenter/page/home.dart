import 'package:enfp/presenter/page/ranking.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeP {
  static Size screenSize = MediaQuery.of(Get.context!).size;

  static void toHome() async {
    await init();
    Get.offAllNamed('/home');
  }
  static Future init() async {
    final rankingP = Get.find<RankingP>();
    await rankingP.loadUsers();
    rankingP.update();
  }
}