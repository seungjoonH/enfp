enum Sex {
  male, female;
  static Sex toEnum(String string) =>
      Sex.values.firstWhere((sex) => sex.name == string);
}
