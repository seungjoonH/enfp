import 'package:enfp/model/class/painter/inference.dart';
import 'package:enfp/model/enum/part.dart';
import 'package:image/image.dart';

class Parts {
  Map<Part, Point> points = {};
  Map<Part, double> probs = {};

  Parts(Map<Part, Inference> inferences) {
    for (Part part in Part.values) {
      points[part] = Point(inferences[part]!.x, inferences[part]!.y);
      probs[part] = inferences[part]!.prob.toDouble();
    }
  }

  static bool similar(num n1, num n2) => (n1 - n2).abs() < 40.0;
}