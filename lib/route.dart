import 'package:enfp/view/page/camera.dart';
import 'package:enfp/view/page/friend/friend.dart';
import 'package:enfp/view/page/friend/search.dart';
import 'package:enfp/view/page/home.dart';
import 'package:enfp/view/page/lang.dart';
import 'package:enfp/view/page/login.dart';
import 'package:enfp/view/page/my_info.dart';
import 'package:enfp/view/page/profile_image.dart';
import 'package:enfp/view/page/ranking.dart';
import 'package:enfp/view/page/register.dart';
import 'package:enfp/view/page/setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// class
class ERoute {
  /// static variables
  static const Transition transition = Transition.fadeIn;

  // 화면 전환 지속시간
  static const Duration duration = Duration(milliseconds: 100);

  /// static methods
  // 라우트 문자열, 페이지 매핑
  static Map<String, Widget> get pages => {
    '/lang': const LangPage(),
    '/register': const RegisterPage(),
    '/login': const LoginPage(),
    '/home': const HomePage(),
    '/friend': const FriendPage(),
    '/friend/search': const SearchPage(),
    '/ranking': const RankingPage(),
    '/setting': const SettingPage(),
    '/camera': const CameraPage(),
    '/profileImage': const ProfileImagePage(),
    '/myInfo': const MyInfoPage(),
  };

  // 겟페이지 리스트
  static List<GetPage> get getPages => pages.entries.map((page) {
    return GetPage(
      name: page.key,
      page: () => page.value,
      transition: transition,
      transitionDuration: duration,
    );
  }).toList();
}
