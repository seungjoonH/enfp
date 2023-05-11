import 'package:enfp/presenter/page/lang.dart';
import 'package:get/get.dart';

enum Lang {
  eng, kor;
  String get en => ['English', 'Korean'][index];
  String get kr => ['영어', '한국어'][index];
  Lang get inverse => values[1 - index];
  String get directString {
    switch (LangP.lang) {
      case eng: return en;
      case kor: return kr;
    }
  }
  String get inverseString {
    switch (LangP.lang) {
      case eng: return kr;
      case kor: return en;
    }
  }
  static Lang toEnum(String string) =>
      Lang.values.firstWhere((lang) => lang.name == string);
}
