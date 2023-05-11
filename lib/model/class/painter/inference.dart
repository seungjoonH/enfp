import 'package:flutter/material.dart';

class Inference {
  // 측정 위치 및 확률
  late int x;
  late int y;
  late double prob;

  /* 생성자 */
  Inference(this.x, this.y, this.prob);
  Inference.list(List<dynamic> list) {
    x = list[0];
    y = list[1];
    prob = list[2];
  }

  // 위치를 Offset 형태로 반환
  Offset get offset => Offset(x.toDouble(), y.toDouble());

  // 비율에 맞게 좌표 수정
  void adjustRatio(double width, double height) {
    x = (x * width).round();
    y = (y * height).round();
  }

  // 문자열 변환 (디버깅)
  @override
  String toString() {
    return 'pos:($x, $y), prob: ${prob.toStringAsFixed(2)}';
  }
}