import 'package:enfp/model/enum/rank_type.dart';
import 'package:enfp/model/class/user.dart';
import 'package:enfp/presenter/firebase/firebase.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:get/get.dart';

class RankingP extends GetxController {
  static get collection => f.collection('users');

  static void toRanking() async {
    final rankP = Get.find<RankingP>();
    await rankP.loadUsers();
    Get.offAllNamed('/ranking');
  }

  RankType currentType = RankType.friend;
  List<EUser> users = [];

  List<EUser> get rankUsers => _getRankUsers(currentType);

  List<EUser> _getRankUsers(RankType type) {
    EUser loggedUser = Get.find<UserP>().loggedUser!;
    switch (type) {
      case RankType.friend:
        return users.where((user) => loggedUser.uid == user.uid
            || loggedUser.friendUids.contains(user.uid)).toList();
      case RankType.entire: return users;
    }
  }

  int _getMyRank(RankType type) {
    EUser loggedUser = Get.find<UserP>().loggedUser!;
    List<EUser> users = _getRankUsers(type);
    return users.indexWhere((user) => user.uid == loggedUser.uid) + 1;
  }
  int get myEntireRank => _getMyRank(RankType.entire);
  int get myFriendRank => _getMyRank(RankType.friend);

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