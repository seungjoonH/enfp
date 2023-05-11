import 'package:enfp/model/class/painter/limb.dart';
import 'package:enfp/model/class/painter/part.dart';
import 'package:enfp/model/enum/part.dart';

class AngleRange {
  late double min;
  late double max;

  AngleRange(this.min, this.max);

  bool inRange(double angle) => angle >= min && angle <= max;
}

class ExerciseHandler {
  // 구부러짐 여부
  static bool bended = true;
  // 신체 구성 Parts
  static late Parts parts;

  // 구부러짐 판단 limb 리스트
  static List<Limb> limbs = [];
  // 각각의 limb 의 구부러진 각도 리스트
  static List<AngleRange> angleRanges = [];

  // 초기 설정
  static void init() {
    limbs = [];
    // 양쪽 엉덩이-무릎-발목을 잇는 limb 설정
    limbs.add(Limb(Part.hipL, Part.kneeL, Part.ankleL));
    limbs.add(Limb(Part.hipR, Part.kneeR, Part.ankleR));
  }
}