import 'dart:ui';

import 'package:enfp/model/class/painter/edge.dart';
import 'package:enfp/model/class/painter/inference.dart';
import 'package:enfp/model/class/painter/limb.dart';
import 'package:enfp/model/enum/part.dart';
import 'package:enfp/util/handler.dart';
import 'package:flutter/material.dart';

class LimbPainter extends CustomPainter {
  late Map<Part, Inference> inferences;

  LimbPainter({required this.inferences});

  // 점 (색상, 굵기 적용)
  Paint partConfig = Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8.0;
  // 선 (색상, 굵기 적용)
  Paint edgeConfig = Paint()
    ..color = Colors.grey
    ..strokeWidth = 5.0;

  @override
  void paint(Canvas canvas, Size size) {
    renderEdges(canvas);
    renderPoints(canvas);
  }

  // 점을 화면에 그리기
  void renderPoints(Canvas canvas) {
    List<Offset> points = inferences.values.map((inf) => inf.offset).toList();
    List<Offset> refinedPoints = [];

    for (Part part in Part.values) {
      bool contain = false;
      for (Limb limb in ExerciseHandler.limbs) {
        contain |= limb.containsPart(part);
      }
      if (contain) refinedPoints.add(points[part.index]);
    }
    canvas.drawPoints(PointMode.points, refinedPoints, partConfig);
  }
  // 선을 화면에 그리기
  void renderEdges(Canvas canvas) {
    for (Edge edge in Edges.list) {
      Offset? p1 = inferences[edge.part1]?.offset;
      Offset? p2 = inferences[edge.part2]?.offset;
      if (p1 == null || p2 == null) continue;

      bool contain = false;
      for (Limb limb in ExerciseHandler.limbs) {
        contain |= limb.containsEdge(edge);
      }

      if (contain) canvas.drawLine(p1, p2, edgeConfig);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}