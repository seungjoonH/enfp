import 'package:enfp/global/date.dart';
import 'package:enfp/model/enum/sex.dart';
import 'package:enfp/model/class/user.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:enfp/presenter/page/home.dart';
import 'package:enfp/presenter/widget/input.dart';
import 'package:get/get.dart';

class RegisterP extends GetxController {
  static void toRegister() {
    final registerP = Get.find<RegisterP>();
    Get.toNamed('/register');
    registerP.init();
  }
  void init() {
    final registerP = Get.find<RegisterP>();
    final inputP = Get.find<InputP>();
    registerP.sexSelected = null;
    inputP.init(); update();
  }

  Sex? sexSelected;
  bool sexInvalid = true;

  Set<Sex> get sexSet {
    if (sexSelected == null) return {};
    return { sexSelected! };
  }
  void selectSex(Set<Sex> sex) {
    if (sex.isEmpty || sexSelected == sex.first) return;
    sexSelected = sex.first; update();
  }

  void sexValidate() {
    sexInvalid = sexSelected == null; update();
  }

  void submit() async {
    final userP = Get.find<UserP>();
    final inputP = Get.find<InputP>();

    inputP.validate('nickname');
    sexValidate();
    inputP.validate('birth');
    inputP.validate('height');
    inputP.validate('weight');
    inputP.validate('goal');

    late EUser stranger;

    if (inputP.valid) {
      stranger = EUser.fromJson({
        'uid': userP.data['uid'],
        'nickname': inputP.nickname,
        'sex': sexSelected!.name,
        'birth': toTimestamp(inputP.birth),
        'height': inputP.height,
        'weight': inputP.weight,
        'goal': inputP.goal,
        'regDate': toTimestamp(today),
        'records': [],
        'friendUids': [],
      });

      userP.login(stranger);
      HomeP.toHome();
      await HomeP.init();
    }
  }
}