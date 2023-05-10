import 'package:enfp/model/user.dart';
import 'package:enfp/presenter/firebase/firebase.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:enfp/presenter/page/friend/friend.dart';
import 'package:get/get.dart';

class SearchP extends GetxController {
  static get collection => f.collection('users');

  static void toSearch() async {
    await init();
    Get.toNamed('/friend/search');
  }
  static Future init() async  {
    final searchP = Get.find<SearchP>();
    searchP.users = [];
    searchP.update();
  }

  static bool access = false;

  List<EUser> users = [];
  List<EUser> get strangers {
    final userP = Get.find<UserP>();
    List<EUser> usrs = [...users];
    usrs.removeWhere((usr) => userP.loggedUser.friendUids.contains(usr.uid));
    usrs.removeWhere((usr) => userP.loggedUser.uid == usr.uid);
    return usrs;
  }
  
  Future loadUsers(String keyword) async {
    users = [];

    if (keyword.isEmpty) return;
    var dataList = await collection
        .where('nickname', isGreaterThanOrEqualTo: keyword)
        .where('nickname', isLessThan: '${keyword}z')
        .orderBy('nickname').get();

    for (var data in dataList.docs) {
      var json = data.data();
      users.add(EUser.fromJson(json));
    }

    deleteDuplicate();
    update();
  }

  void deleteDuplicate() {
    List<EUser> tempUsers = [...users];
    for (int i = 0; i < tempUsers.length - 1; i++) {
      if (tempUsers[i].uid == tempUsers[i + 1].uid) tempUsers.removeAt(i);
    }
    users = [...tempUsers];
  }

  void addFriend(String uid) async {
    final userP = Get.find<UserP>();
     userP.loggedUser.friendUids.add(uid);
     userP.save();
     FriendP.toFriend();
     update();
  }

}