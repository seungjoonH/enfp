import 'dart:math';

import 'package:enfp/model/class/painter/edge.dart';
import 'package:enfp/model/enum/part.dart';
import 'package:image/image.dart';

class Limb {
  // Limb 를 이루는 세 Parts
  late Part part1;
  late Part part2;
  late Part part3;

  /* 생성자 */
  Limb(this.part1, this.part2, this.part3);
  Limb.list(List<Part> list) {
    part1 = list[0];
    part2 = list[1];
    part3 = list[2];
  }
  Limb.intList(List<int> list) {
    part1 = Part.values[list[0]];
    part2 = Part.values[list[1]];
    part3 = Part.values[list[2]];
  }

  // Limb 를 두 개의 Edge 로 반환
  List<Edge> get edges => [Edge(part1, part2), Edge(part2, part3)];

  // 특정 Part 존재 여부
  bool containsPart(Part part) {
    return [part1, part2, part3].contains(part);
  }

  // 특정 Edge 존재 여부
  bool containsEdge(Edge edge) {
    bool result = false;
    for (Edge e in edges) { result |= e.equalTo(edge); }
    return result;
  }

  // 세 점이 이루는 각도를 반환 (0 ~ 180)
  static double getAngle(Point pointA, Point pointB, Point pointC) {
    double radians = atan2(pointC.y - pointB.y, pointC.x - pointB.x) -
        atan2(pointA.y - pointB.y, pointA.x - pointB.x);
    double angle = (radians * 180 / pi).abs();
    if (angle > 180) angle = 360 - angle;

    return angle;
  }
}