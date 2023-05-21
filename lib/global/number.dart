import 'package:intl/intl.dart';

var f = NumberFormat('###,###,###,###');
String toLocalString(dynamic number) => f.format(number);

double? stringToNum(String string) {
  try { return double.parse(string); }
  catch(_) { return null; }
}

bool similar(num n1, num n2) => (n1 - n2).abs() < .001;

num sum(List<num> list) {
  List<num> temp = [...list];
  return temp.reduce((a, b) => a + b);
}

num average(List<num> list) {
  return sum(toDoubleList(list)) / list.length;
}

List<double> toDoubleList(List<num> list) {
  return list.map((e) => e.toDouble()).toList();
}

bool isSorted(List<num> list, {bool desc = false}) {
  bool result = true;
  for (int i = 0; i < list.length - 1; i++) {
    if (list[i] == list[i + 1]) { result &= true; continue; }
    bool gt = list[i] > list[i + 1];
    result &= desc ? gt : !gt;
  }
  return result;
}

String sign(num n) => n < 0 ? '-' : '+';
String withSign(num n) => '${sign(n)}${(n).abs()}';