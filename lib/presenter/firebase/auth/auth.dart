import 'package:enfp/model/user.dart';
import 'package:enfp/presenter/firebase/auth/google.dart';
import 'package:enfp/presenter/global.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:enfp/presenter/page/home.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

enum LoginType { google }

class AuthP {
  static final userP = Get.find<UserP>();

  // static const storage = FlutterSecureStorage();
  static late String uid;

  /// static methods
  // static Future<bool> versionCheck() async {
  //   var json = (await f.collection('versions').doc(versionNumber).get()).data();
  //   return json != null && json['available'];
  // }

  // 로그인 형식에 따른 피트윈 로그인
  static Future eLogin(LoginType type) async {
    UserCredential? userCredential;
    Map<String, dynamic>? json;

    // 로그인 형식에 따른 로그인 방식
    switch (type) {
      case LoginType.google:
        userCredential = await GoogleAuth.signInWithGoogle();
        break;
    }

    if (userCredential == null) return;
    uid = userCredential.user!.uid;

    // 파이어베이스 데이터
    json = (await UserP.collection.doc(uid).get()).data() ?? {};

    // 파이어베이스에 문서가 없거나 json 데이터에 닉네임이 없을 경우 신규 회원
    bool isNewcomer = json == null || json['nickname'] == null;

    Map<String, dynamic> data = {};
    data['uid'] = userCredential.user!.uid;
    data['name'] = userCredential.user!.displayName;
    data['email'] = userCredential.user!.email;

    userP.data = {...data};

    Map<String, dynamic> uidJson = {'uid': data['uid']};
    json ??= uidJson;

    // 신규 회원일 경우
    if (isNewcomer) {
      // 회원가입 페이지로 이동
      LangP.toLang();
    }

    // 기존 회원일 경우
    else {
      // 파이어베이스 데이터로 로그인
      EUser stranger = EUser.fromJson(json);

      // final loginP = Get.find<LoginP>();

      // loginP.loadStart();

      // if (networkResult != ConnectivityResult.none) {
      await userP.login(stranger);

      // await storeLoginData(userP.data);
      await GlobalP.init();
      // }


      // loginP.loadEnd();

      HomeP.toHome();
      await HomeP.init();
    }
  }

  // 피트윈 로그아웃
  static void eLogout() {
    Get.offAllNamed('/login');
    userP.logout();
    // eliminateLoginData();
  }

  // 피트윈 계정삭제
  static void eDeleteAccount() {
    userP.delete();
    eLogout();
  }

  // static void loadLoginData() async {
  //   String? userInfo = await storage.read(key: 'login');
  //   bool beenLogged = userInfo != null;
  //
  //   // 자동 로그인
  //   if (!beenLogged) return;
  //
  //   userP.data = jsonDecode(userInfo);
  //   String uid = userP.data['uid'];
  //
  //   userP.loggedUser.uid = uid;
  //
  //   final loginP = Get.find<LoginP>();
  //
  //   loginP.loadStart();
  //
  //   // if (networkResult != ConnectivityResult.none) {
  //     await userP.load();
  //
  //     await GlobalP.init();
  //   // }
  //
  //   loginP.loadEnd();
  //
  //   HomeP.toHome();
  // }

  // // 로그인 데이터 전송
  // static Future storeLoginData(Map<String, dynamic> data) async {
  //   await storage.write(
  //     key: 'login',
  //     value: jsonEncode(data),
  //   );
  // }
  //
  // // 로그인 데이터 삭제
  // static Future eliminateLoginData() async {
  //   await storage.delete(key: 'login');
  // }
}
