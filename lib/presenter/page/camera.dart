import 'dart:math';

import 'package:camera/camera.dart';
import 'package:enfp/global/number.dart';
import 'package:enfp/model/class/painter/inference.dart';
import 'package:enfp/model/class/painter/limb.dart';
import 'package:enfp/model/class/painter/part.dart';
import 'package:enfp/model/enum/part.dart';
import 'package:enfp/model/enum/workout.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:enfp/presenter/page/home.dart';
import 'package:enfp/util/classifier.dart';
import 'package:enfp/util/handler.dart';
import 'package:enfp/util/isolate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraP extends GetxController {
  static void toCamera() { Get.toNamed('/camera'); }

  static List<CameraDescription>? descriptions;
  CameraController? cameraController;

  static Orientation? orientation;

  static Size? presetSize;
  static Size? screenSize;
  static Size? get canvasSize {
    Size? size = presetSize;
    bool condition = size!.aspectRatio < screenSize!.aspectRatio;
    double width = condition ? screenSize!.width : screenSize!.height * size.aspectRatio;
    double height = condition ? screenSize!.width / size.aspectRatio : screenSize!.height;

    return Size(width, height);
  }

  static double get horizontalError => .5 * (screenSize!.width - canvasSize!.width);
  static double get verticalError => .5 * (screenSize!.height - canvasSize!.height);

  static late Classifier classifier;
  static late IsolateUtils isolate;

  Map<Part, Inference>? inferences;
  late List<Limb> limbs;

  int direction = 1;
  late double initZoom = 0;
  double zoom = 1.0;

  int count = 0;
  int score = 0;

  String message = '';
  String get postureMessage {
    String msg = posture.message;
    if (posture.score > 0) msg += ' +${posture.score}';
    return msg;
  }

  WorkoutStage stage = WorkoutStage.down;
  bool humanDetected = false;

  TimerState threeSecTimerState = TimerState.stop;
  int threeSecTimerSeconds = 3;

  List<WorkoutStage> stageHistory = [WorkoutStage.down];
  List<WorkoutStage> get subList => stageHistory
      .sublist(0, stageHistory.length - 1);

  WorkoutPosture posture = WorkoutPosture.unbent;

  HumanDistance get distance {
    if (distanceHistory.contains(HumanDistance.undetected)) { return HumanDistance.undetected; }
    else if (distanceHistory.contains(HumanDistance.near)) { return HumanDistance.near; }
    else if (distanceHistory.contains(HumanDistance.far)) { return HumanDistance.far; }
    return HumanDistance.middle;
  }

  static const int hisMaxStage = 5;
  static const int hisMaxAngle = 3;
  static const int hisMaxDistance = 5;

  List<double> angleHistory = List.generate(hisMaxAngle, (_) => .0);
  List<HumanDistance> distanceHistory = List.generate(hisMaxDistance, (_) => HumanDistance.middle);

  bool allowed = true;

  Future init() async {
    isolate = IsolateUtils();
    await isolate.start();

    classifier = Classifier();
    classifier.loadModel();

    await loadCamera(direction);
    loadAll();
    update();
  }

  Future toggleDirection() async {
    direction = 1 - direction;
    update();
  }

  Future loadCamera([direction = 0]) async {
    if (descriptions == null) return;

    cameraController = CameraController(
      descriptions![direction], ResolutionPreset.medium,
      enableAudio: false,
    );
    await cameraController!.initialize();
    await cameraController!.setZoomLevel(zoom);
  }

  void setInitZoom() => initZoom = zoom;

  Future setZoomLevel(ScaleUpdateDetails details) async {
    zoom = max(1.0, min(details.scale * initZoom, 189.0));
    await cameraController!.setZoomLevel(zoom);
  }

  void loadAll() {
    count = 0; score = 0;
    stage = WorkoutStage.down;
    distanceHistory = [HumanDistance.middle];
    update();
  }

  void submitButtonPressed() {
    final userP = Get.find<UserP>();
    userP.loggedUser!.addCount(count);
    userP.loggedUser!.addScore(score);
    userP.save(); HomeP.toHome();
    init();
  }

  void measureDistance() {
    message = '';
    humanDetected = false;
    if (inferences == null) return;

    double kneeLY = inferences![Part.kneeL]!.y.toDouble();
    double kneeRY = inferences![Part.kneeR]!.y.toDouble();
    double ankleLY = inferences![Part.ankleL]!.y.toDouble();
    double ankleRY = inferences![Part.ankleR]!.y.toDouble();
    double shinHeight = average([ankleLY, ankleRY]).toDouble() - average([kneeLY, kneeRY]);

    humanDetected = Parts(inferences!).humanDetected;

    bool bent = ExerciseHandler.posture != WorkoutPosture.unbent;
    bool near = shinHeight > 130.0;
    bool far = shinHeight < 60.0 - (bent ? 10.0 : .0);

    if (near) {
      addDistanceHistory(HumanDistance.near);
      posture = WorkoutPosture.unbent;
    }
    else if (far) {
      addDistanceHistory(HumanDistance.far);
      posture = WorkoutPosture.unbent;
    }
    else {
      addDistanceHistory(HumanDistance.middle);
    }

    if (!humanDetected) addDistanceHistory(HumanDistance.undetected);
  }

  void addStageHistory(WorkoutStage stage) {
    stageHistory.add(stage);
    if (stageHistory.length > hisMaxStage) stageHistory.removeAt(0);
  }

  void addAngleHistory(double angle) {
    angleHistory.add(angle);
    if (angleHistory.length > hisMaxAngle) angleHistory.removeAt(0);
  }

  void addDistanceHistory(HumanDistance distance) {
    distanceHistory.add(distance);
    if (distanceHistory.length > hisMaxDistance) distanceHistory.removeAt(0);
  }

  void setStage() {
    List<double> sub = angleHistory.sublist(0, angleHistory.length - 1).toList();
    bool descending = isSorted(sub, desc: true);
    bool ascending = isSorted(sub);

    bool unbent = ExerciseHandler.posture == WorkoutPosture.unbent;

    if (!unbent && descending && sub.last < angleHistory.last) {
      stage = WorkoutStage.up;
    }
    else if (unbent && ascending  && sub.last > angleHistory.last) {
      stage = WorkoutStage.down;
    }
    addStageHistory(stage);
  }

  bool get changedDownToUp {
    bool downToUp = true;
    downToUp &= ExerciseHandler.posture != WorkoutPosture.unbent;
    downToUp &= [...subList].every((s) => s == WorkoutStage.down);
    downToUp &= stageHistory.last == WorkoutStage.up;
    return downToUp;
  }

  bool get changedUpToDown {
    bool upToDown = true;
    upToDown &= ExerciseHandler.posture == WorkoutPosture.unbent;
    upToDown &= [...subList].every((s) => s == WorkoutStage.up);
    upToDown &= stageHistory.last == WorkoutStage.down;
    return upToDown;
  }

  void estimatePosture() async {
    if (changedDownToUp) {
      if (allowed) { posture = ExerciseHandler.posture; }
      else { posture = WorkoutPosture.fast; }
    }
    else if (changedUpToDown) {
      if (allowed) countUp();
      await Future.delayed(const Duration(milliseconds: 700), () {
        posture = WorkoutPosture.unbent; allowed = true; update();
      });
    }
  }

  void countUp() {
    allowed = false; count++;
    score += posture.score; update();
  }

  void staging() {
    setStage();

    measureDistance();
    if (distance == HumanDistance.middle) {
      if (humanDetected) {
        estimatePosture();
        message += stage.message;
      }
    }
    else { message = distance.message; }

    addAngleHistory(ExerciseHandler.angle);
    update();
  }
}