import 'package:enfp/model/user.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:get/get.dart';

class FriendP extends GetxController {
  static void toFriend() async {
    await init();
    Get.offAllNamed('/friend');
  }
  static Future init() async {
    final friendP = Get.find<FriendP>();
    final userP = Get.find<UserP>();
    await userP.load();
    await friendP.loadFriends();
    friendP.update();
  }

  Future loadFriends() async {
    final userP = Get.find<UserP>();
    userP.loggedUser.friends = [];
    for (var uid in userP.loggedUser.friendUids) {
      EUser friend = (await UserP.loadUser(uid))!;
      userP.loggedUser.addFriend(friend);
    }
    update();
  }
}