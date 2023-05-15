import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enfp/global/date.dart';
import 'package:enfp/model/enum/lang.dart';
import 'package:enfp/model/enum/sex.dart';

class EUser {
  static int defaultWeight = 60;
  static int defaultHeight = 170;
  static int heightMax = 220;
  static int heightMin = 100;
  static int weightMax = 220;
  static int weightMin = 30;

  static bool heightInRange(int height) {
    return height >= heightMin && height <= heightMax;
  }
  static bool weightInRange(int weight) {
    return weight >= weightMin && weight <= weightMax;
  }

  late String uid;
  late String nickname;
  late Sex sex;
  late int height;
  late int weight;
  late Timestamp _birth;
  late Timestamp _regDate;
  String? imageUrl;

  late Lang lang;

  late int goal;
  late int score;
  List<Map<String, dynamic>> records = [];

  List<String> friendUids = [];
  List<EUser> friends = [];

  DateTime get birth => _birth.toDate();
  set birth(DateTime b) => toTimestamp(b);
  DateTime get regDate => _regDate.toDate();
  set regDate(DateTime r) => toTimestamp(r);

  EUser();

  EUser.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    nickname = json['nickname'];
    sex = Sex.toEnum(json['sex']);
    height = json['height'];
    weight = json['weight'];
    _birth = json['birth'];
    _regDate = json['regDate'];
    imageUrl = json['imageUrl'];
    lang = Lang.toEnum(json['lang'] ?? 'eng');
    goal = json['goal'] ?? 0;
    score = json['score'] ?? 0;
    records = json['records']?.cast<Map<String, dynamic>>() ?? [];
    friendUids = json['friendUids']?.cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['nickname'] = nickname;
    json['sex'] = sex.name;
    json['height'] = height;
    json['weight'] = weight;
    json['birth'] = _birth;
    json['regDate'] = _regDate;
    json['imageUrl'] = imageUrl;
    json['lang'] = lang.name;
    json['goal'] = goal;
    json['score'] = score;
    json['records'] = records;
    json['friendUids'] = friendUids;
    return json;
  }

  int getAmount([DateTime? srtDate, DateTime? endDate]) {
    int amount = 0;
    DateTime sDate = srtDate ?? regDate;
    DateTime eDate = nextDay(endDate ?? today);

    for (Map<String, dynamic> record in records) {
      if (!isInDateRange(record['date']!.toDate(), sDate, eDate)) continue;
      amount += record['amount'] as int;
    }

    return amount;
  }

  bool getCompleted(DateTime date) {
    for (Map<String, dynamic> record in records) {
      if (isSameDate(record['date']!.toDate(), date)) return record['completed'] ?? false;
    }
    return false;
  }

  void addFriend(EUser friend) => friends.add(friend);

}