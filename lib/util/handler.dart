import 'package:enfp/global/number.dart';
import 'package:enfp/model/class/painter/inference.dart';
import 'package:enfp/model/class/painter/limb.dart';
import 'package:enfp/model/class/painter/part.dart';
import 'package:enfp/model/enum/part.dart';
import 'package:enfp/model/enum/workout.dart';
import 'package:image/image.dart';

class AngleRange {
  late double min;
  late double max;

  AngleRange(this.min, this.max);

  bool inRange(double angle) => angle >= min && angle <= max;
}

class ExerciseHandler {
  static List<double> angles = [];
  static List<WorkoutPosture> postures = [];

  static double get angle {
    if (angles.isEmpty) return .0;
    return average(angles).toDouble();
  }
  static WorkoutPosture get posture {
    if (postures.any((p) => p == WorkoutPosture.fast)) return WorkoutPosture.fast;
    if (postures.any((p) => p == WorkoutPosture.wrong)) return WorkoutPosture.wrong;
    int score = sum(postures.map((p) => p.indexAlt).toList()).toInt();
    return WorkoutPosture.values[score ~/ 2 + 2];
  }

  // 신체 구성 Parts
  static late Parts parts;

  // 구부러짐 판단 limb 리스트
  static List<Limb> limbs = [];
  // 각각의 limb 의 구부러진 각도 리스트
  static List<AngleRange> perfectRanges = [];
  static List<AngleRange> greatRanges = [];
  static List<AngleRange> goodRanges = [];
  // 사람 여부를 판단할 Part 리스트
  static List<Part> probAvailParts = [];

  // 초기 설정
  static void squat() {
    limbs = [];
    // 양쪽 엉덩이-무릎-발목을 잇는 limb 의 각도를 측정
    limbs.add(Limb(Part.hipL, Part.kneeL, Part.ankleL));
    limbs.add(Limb(Part.hipR, Part.kneeR, Part.ankleR));
    // 다리 부분으로 사람 여부 판단
    probAvailParts = [
      Part.hipL, Part.kneeL, Part.ankleL,
      Part.hipR, Part.kneeR, Part.ankleR,
    ];
    // 측정 각도의 hitting 범위를 설정
    perfectRanges = List.generate(limbs.length, (_) => AngleRange(50, 130));
    greatRanges = List.generate(limbs.length, (_) => AngleRange(40, 140));
    goodRanges = List.generate(limbs.length, (_) => AngleRange(30, 150));

    postures = List.generate(limbs.length, (_) => WorkoutPosture.unbent);
  }

  // 특정 각도 범위 내로 구부러짐 여부 판단
  static void checkLimbs(Map<Part, Inference> inference) {
    bool isCorrect = true;
    angles = [];
    postures = List.generate(limbs.length, (_) => WorkoutPosture.unbent);
    parts = Parts(inference);

    for (int i = 0; i < limbs.length; i++) {
      Part p1 = limbs[i].part1;
      Part p2 = limbs[i].part2;
      Part p3 = limbs[i].part3;

      Point point1 = parts.points[p1]!;
      Point point2 = parts.points[p2]!;
      Point point3 = parts.points[p3]!;

      double angle = Limb.getAngle(point1, point2, point3);

      angles.add(angle);
      if (goodRanges[i].inRange(angle)) postures[i] = WorkoutPosture.good;
      if (greatRanges[i].inRange(angle)) postures[i] = WorkoutPosture.great;
      if (perfectRanges[i].inRange(angle)) postures[i] = WorkoutPosture.perfect;

      isCorrect &= Parts.similar(point2.x, point3.x);
    }

    isCorrect &= Parts.similar(
      parts.points[limbs[0].part3]!.y,
      parts.points[limbs[1].part3]!.y,
    );

    if (!isCorrect) postures.first = WorkoutPosture.wrong;
  }
}