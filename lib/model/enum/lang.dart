enum Lang {
  eng, kor;
  String get en => ['English', 'Korean'][index];
  String get kr => ['영어', '한국어'][index];
  Lang get inverse => values[1 - index];
  static Lang toEnum(String string) =>
      Lang.values.firstWhere((sex) => sex.name == string);
}
