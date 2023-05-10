import 'package:enfp/model/enum/rank_type.dart';
import 'package:enfp/model/user.dart';
import 'package:enfp/presenter/firebase/firebase.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:get/get.dart';

class RankingP extends GetxController {
  static get collection => f.collection('users');

  static void toRanking() => Get.offAllNamed('/ranking');

  RankType currentType = RankType.friend;
  List<EUser> users = [];

  List<EUser> get rankUsers {
    EUser loggedUser = Get.find<UserP>().loggedUser;
    switch (currentType) {
      case RankType.friend:
        return users.where((user) => loggedUser.uid == user.uid
            || loggedUser.friendUids.contains(user.uid)).toList();
      case RankType.entire: return users;
    }
  }

  void changeType(RankType type) async {
    currentType = type;
    await loadUsers();
    update();
  }

  Future loadUsers() async {
    var dataList = await collection.orderBy('score', descending: true).get();

    users = [];
    for (var data in dataList.docs) {
      var json = data.data();
      users.add(EUser.fromJson(json));
    }

    update();
  }
}