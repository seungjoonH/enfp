import 'dart:ui';

import 'package:enfp/model/class/painter/edge.dart';
import 'package:enfp/model/class/painter/inference.dart';
import 'package:enfp/model/class/painter/limb.dart';
import 'package:enfp/model/enum/part.dart';
import 'package:enfp/model/enum/workout.dart';
import 'package:enfp/presenter/page/camera.dart';
import 'package:enfp/util/handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LimbPainter extends CustomPainter {
  final cameraP = Get.find<CameraP>();


  LimbPainter({
    required Map<Part, Inference> inferences,
    required List<Limb> limbs,
  }) {
    cameraP.inferences = inferences;
    cameraP.limbs = limbs;
  }

  Paint pointGrey = Paint()
    ..color = Colors.grey.withOpacity(.8)
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  Paint edgeGrey = Paint()
    ..color = Colors.grey.withOpacity(.3)
    ..strokeWidth = 5;

  Paint pointBlue = Paint()
    ..color = Colors.blue.withOpacity(.8)
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  Paint edgeBlue = Paint()
    ..color = Colors.blue.withOpacity(.3)
    ..strokeWidth = 5;

  Paint pointGreen = Paint()
    ..color = Colors.green.withOpacity(.8)
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  Paint edgeGreen = Paint()
    ..color = Colors.green.withOpacity(.3)
    ..strokeWidth = 5;

  Paint pointYellow = Paint()
    ..color = Colors.yellow.withOpacity(.8)
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  Paint edgeYellow = Paint()
    ..color = Colors.yellow.withOpacity(.3)
    ..strokeWidth = 5;

  Paint pointRed = Paint()
    ..color = Colors.red.withOpacity(.8)
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  Paint edgeRed = Paint()
    ..color = Colors.red.withOpacity(.3)
    ..strokeWidth = 5;

  Paint get pointColor {
    final cameraP = Get.find<CameraP>();
    return Paint()
      ..color = cameraP.posture.color.withOpacity(.8)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;
  }

  Paint get edgeColor {
    final cameraP = Get.find<CameraP>();
    return Paint()
      ..color = cameraP.posture.color.withOpacity(.3)
      ..strokeWidth = 5;
  }

  Paint area = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.white.withOpacity(.8)
    ..strokeWidth = 5;

  bool get humanDetected {
    return Get.find<CameraP>().humanDetected;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (!humanDetected) return;
    renderEdges(canvas);
    renderPoints(canvas);
  }

  void renderPoints(Canvas canvas) {
    List<Offset> points = cameraP.inferences!.values.map((inf) => inf.offset).toList();
    List<Offset> refinedPoints = [];

    for (Part part in Part.values) {
      bool contain = false;
      for (Limb limb in ExerciseHandler.limbs) {
        contain |= limb.containsPart(part);
      }
      if (contain) refinedPoints.add(points[part.index]);
    }
    canvas.drawPoints(PointMode.points, refinedPoints, {
      WorkoutPosture.unbent: pointGrey,
      WorkoutPosture.perfect: pointBlue,
      WorkoutPosture.great: pointGreen,
      WorkoutPosture.good: pointYellow,
      WorkoutPosture.wrong: pointRed,
      WorkoutPosture.fast: pointRed,
    }[Get.find<CameraP>().posture]!);
  }

  void renderEdges(Canvas canvas) {
    for (Edge edge in Edges.list) {
      Offset? p1 = cameraP.inferences![edge.part1]?.offset;
      Offset? p2 = cameraP.inferences![edge.part2]?.offset;
      if (p1 == null || p2 == null) continue;
      bool contain = false;
      for (Limb limb in ExerciseHandler.limbs) {
        contain |= limb.containsEdge(edge);
      }

      if (!contain) continue;
      canvas.drawLine(p1, p2, {
        WorkoutPosture.unbent: edgeGrey,
        WorkoutPosture.perfect: edgeBlue,
        WorkoutPosture.great: edgeGreen,
        WorkoutPosture.good: edgeYellow,
        WorkoutPosture.wrong: edgeRed,
        WorkoutPosture.fast: edgeRed,
      }[Get.find<CameraP>().posture]!);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}