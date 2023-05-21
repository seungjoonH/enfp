import 'package:enfp/model/class/user.dart';
import 'package:enfp/presenter/firebase/firebase.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserP extends GetxController {
  static get collection => f.collection('users');

  /// static methods
  static Future<EUser?> loadUser(String uid) async {
    var json = (await collection.doc(uid).get()).data();
    if (json == null) return null;
    return EUser.fromJson(json);
  }

  static void saveUser(EUser user) async {
    collection.doc(user.uid).set(user.toJson());
  }

  Map<String, dynamic> data = {};

  EUser? loggedUser;

  bool get isLogged => loggedUser != null;

  /// methods
  Future login(EUser user) async {
    Map<String, dynamic> json = user.toJson();
    loggedUser = EUser.fromJson(json);
    final langP = Get.find<LangP>();
    langP.loadLang();
    save();
  }

  void logout() => loggedUser = EUser();

  Future load() async {
    var json = (await collection
        .doc(loggedUser!.uid).get()).data();
    if (json == null) return;
    loggedUser = EUser.fromJson(json);
  }

  void save() => collection
      .doc(loggedUser!.uid)
      .set(loggedUser!.toJson());

  void delete() => collection
      .doc(loggedUser!.uid).delete();


  void setThemeMode(ThemeMode mode) {
    loggedUser!.themeMode = mode;
    save(); update();
  }
}