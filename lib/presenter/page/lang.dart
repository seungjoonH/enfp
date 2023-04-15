import 'package:enfp/global/string.dart';
import 'package:enfp/model/enum/lang.dart';
import 'package:get/get.dart';

class LangP extends GetxController {
  static void toLang() => Get.toNamed('/lang');
  static void init() {}

  static const Map<String, List<String>> _words = {
    'birth'     : ['birth', '생년월일'],
    'female'    : ['female', '여성'],
    'goal'      : ['goal', '목표'],
    'google'    : ['google', '구글'],
    'height'    : ['height', '신장'],
    'language'  : ['language', '언어'],
    'male'      : ['male', '남성'],
    'next'      : ['next', '다음'],
    'nickname'  : ['nickname', '별명'],
    'register'  : ['register', '회원가입'],
    'sex'       : ['sex', '성별'],
    'weight'    : ['weight', '체중'],
  };

  static Map<String, List<String>> _sentences(String word) {
    String found = find(word);
    return {
      'enter'     : ['Enter your $found', '$found${eulReul(found)} 입력하세요'],
      'login'     : ['Continue with $found', '$found계정으로 로그인'],
      'less-2'    : ['Enter at least two characters', '두 글자 이상 입력해주세요'],
      'more-10'   : ['Enter at most ten characters', '열 글자 이하 입력해주세요'],
      'has-scv'   : ['', '자음 모음은 단독으로 포함될 수 없습니다'],
      'has-space' : ['Cannot contains spaces', '공백을 포함할 수 없습니다'],
      'has-spc'   : ['Cannot contains special characters', '특수문자는 포함할 수 없습니다'],
      'only-num'  : ['Only numbers are not allowed', '영어나 한글을 포함해주세요'],
      'out-range' : ['Invalid range entered', '유효범위가 아닙니다'],
      'non-num'   : ['Non-numeric characters entered', '숫자만 입력해주세요'],
      'wr-ent'    : ['Wrong date entered', '잘못 입력하셨습니다'],
      'fut-ent'   : ['Cannot enter future day', '미래는 입력할 수 없습니다'],
      'tod-ent'   : ['Cannot enter today', '오늘은 입력할 수 없습니다'],
      'not-date'  : ['Entered date does not exist', '없는 날짜입니다'],
      'not-8'     : ['Enter eight letters', '여덟글자가 아닙니다'],
    };
  }

  static int _langIndex(Lang lang) => Lang.values.indexOf(lang);
  static String find(String keyword, [Lang? lang]) {
    final langP = Get.find<LangP>();
    return _words[keyword]![_langIndex(lang ?? langP.language)];
  }
  static String makeSentence(String keyword, String word, [Lang? lang]) {
    final langP = Get.find<LangP>();
    return _sentences(word)[keyword]![_langIndex(lang ?? langP.language)];
  }

  Lang language = Lang.kor;
  void setLang(Lang l) { language = l; update(); }
}