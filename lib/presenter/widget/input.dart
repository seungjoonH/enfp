import 'package:enfp/global/date.dart';
import 'package:enfp/global/string.dart';
import 'package:enfp/model/class/user.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Field {
  bool invalid = false;
  bool completed = false;
  String? hintText;
  late TextEditingController controller;

  Field(this.controller);
}

class InputP extends GetxController {
  Map<String, String> get initHintTexts => {
    'nickname': LangP.makeSentence('enter', 'nickname'),
    'birth': 'YYYYMMDD',
    'height': LangP.makeSentence('enter', 'height'),
    'weight': LangP.makeSentence('enter', 'weight'),
    'goal': LangP.makeSentence('enter', 'goal'),
  };

  final Map<String, Field> _fields = {
    'nickname': Field(TextEditingController()),
    'birth': Field(TextEditingController()),
    'height': Field(TextEditingController()),
    'weight': Field(TextEditingController()),
    'goal': Field(TextEditingController()),
  };

  Field? getFields(String keyword) => _fields[keyword];

  String get nickname => getFields('nickname')!.controller.text;
  DateTime get birth => stringToDate(getFields('birth')!.controller.text)!;
  int get height => int.parse(getFields('height')!.controller.text);
  int get weight => int.parse(getFields('weight')!.controller.text);
  int get goal => int.parse(getFields('goal')!.controller.text);

  set nickname(String text) => getFields('nickname')!.controller.text = text;
  set birth(DateTime date) => getFields('birth')!.controller.text = dateToString('yyyyMMdd', date)!;
  set height(int value) => getFields('height')!.controller.text = '$value';
  set weight(int value) => getFields('weight')!.controller.text = '$value';
  set goal(int value) => getFields('goal')!.controller.text = '$value';

  bool get valid => _fields.values.map((field) => field.invalid).every((e) => !e);

  Map<String, bool> getConditions(String type, String text) {
    DateTime? date = stringToDate(text);
    return {
      'nickname': {
        // '별명이 중복됩니다': await UserP.duplicatedNickname(text),
        'less-2'   : text.length < 2,
        'more-10'  : text.length > 10,
        'has-scv'  : hasSeparatedConsonantOrVowel(text),
        // 'has-space': text.contains(' '),
        'has-spc'  : RegExp(r'[`~!@#$%^&*|"' r"'‘’””;:/?]").hasMatch(text),
        'only-num' : int.tryParse(text) != null,
        'enter'    : text == '',
      },
      'birth': {
        'wr-ent'   : (today.year - (date?.year ?? 0)) > 99,
        'fut-ent'  : today.isBefore(date ?? (today)),
        'tod-ent'  : isSameDate(today, date ?? today),
        'not-date' : date == null,
        'not-8'    : text.length != 8,
        'only-num' : int.tryParse(text) == null,
        'enter'    : text == '',
      },
      'height': {
        'out-range': !heightInRange(text),
        'non-num'  : int.tryParse(text) == null,
        'enter'    : text == '',
      },
      'weight': {
        'out-range': !weightInRange(text),
        'non-num'  : int.tryParse(text) == null,
        'enter'    : text == '',
      },
      'goal': {
        'non-num'  : int.tryParse(text) == null,
        'enter'    : text == '',
      },
    }[type]!;
  }

  void init() {
    final userP = Get.find<UserP>();
    if (userP.loggedUser == null) {
      _fields.forEach((keyword, field) {
        field.hintText = initHintTexts[keyword];
        field.controller.clear();
      });
    }
    else {
      nickname = userP.loggedUser!.nickname;
      birth = userP.loggedUser!.birth;
      height = userP.loggedUser!.height;
      weight = userP.loggedUser!.weight;
      goal = userP.loggedUser!.goal;
    }
    update();
  }

  void validate(String type) async {
    Field field = _fields[type]!;
    String text = field.controller.text;

    Map<String, bool> conditions = getConditions(type, text);

    conditions.forEach((message, condition) {
      if (condition) field.hintText = LangP.makeSentence(message, type);
    });

    if (conditions.values.any((condition) => condition)) {
      field.controller.clear();
      field.invalid = true;
      update();
      await Future.delayed(const Duration(milliseconds: 700), () {
        field.invalid = false;
        update();
      });
      await Future.delayed(const Duration(milliseconds: 500), () {
        field.controller.text = text;
        update();
        field.hintText = initHintTexts[type];
      });
    }
    update();
  }

  bool heightInRange(String heightString) {
    if (int.tryParse(heightString) == null) return false;
    return EUser.heightInRange(int.parse(heightString));
  }

  bool weightInRange(String weightString) {
    if (int.tryParse(weightString) == null) return false;
    return EUser.weightInRange(int.parse(weightString));
  }

}