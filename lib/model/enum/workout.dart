import 'package:enfp/presenter/page/lang.dart';
import 'package:flutter/material.dart';

enum WorkoutStage {
  down, up;
  String get message => [
    LangP.makeSentence('stg-down'),
    LangP.makeSentence('stg-up'),
  ][index];
}
enum WorkoutPosture {
  fast, wrong, unbent, good, great, perfect;
  String get message => [
    LangP.makeSentence('fast'),
    LangP.makeSentence('wrong'), '',
    LangP.makeSentence('good'),
    LangP.makeSentence('great'),
    LangP.makeSentence('perfect'),
  ][index];
  int get indexAlt => index - 2;
  Color get color => [
    Colors.red, Colors.red, Colors.grey,
    Colors.yellow, Colors.green, Colors.blue,
  ][index];
  int get score => [0, 0, 0, 20, 25, 30][index];
}
enum HumanDistance {
  undetected, middle, near, far;
  String get message => [
    LangP.makeSentence('hm-und'), '',
    LangP.makeSentence('near'),
    LangP.makeSentence('far'),
  ][index];
}
enum TimerState { stop, run }