import 'package:enfp/global/date.dart';
import 'package:enfp/model/class/user.dart';
import 'package:enfp/model/enum/sex.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:enfp/presenter/widget/input.dart';
import 'package:get/get.dart';

class MyInfoP extends GetxController {
  static void toMyInfo() {
    final myInfoP = Get.find<MyInfoP>();
    Get.toNamed('/myInfo');
    myInfoP.init();
  }

  void init() {
    final inputP = Get.find<InputP>();
    inputP.init(); update();
  }

  void submit() async {
    final userP = Get.find<UserP>();
    final inputP = Get.find<InputP>();

    inputP.validate('nickname');
    inputP.validate('birth');
    inputP.validate('height');
    inputP.validate('weight');
    inputP.validate('goal');

    late EUser updated;

    if (inputP.valid) {
      updated = EUser.fromJson({
        'uid': userP.data['uid'],
        'nickname': inputP.nickname,
        'sex': userP.loggedUser!.sex.name,
        'birth': toTimestamp(inputP.birth),
        'height': inputP.height,
        'weight': inputP.weight,
        'goal': inputP.goal,
        'imageUrl': userP.loggedUser!.imageUrl,
        'regDate': toTimestamp(userP.loggedUser!.regDate),
        'records': userP.loggedUser!.records,
        'friendUids': userP.loggedUser!.friendUids,
      });

      userP.loggedUser = updated;
      userP.save();

      Get.back();
    }
  }
}