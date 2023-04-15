import 'package:enfp/global/theme.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:enfp/presenter/page/register.dart';
import 'package:enfp/presenter/widget/input.dart';
import 'package:enfp/view/widget/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:get/get.dart';

class EInputField extends StatelessWidget {
  const EInputField({
    Key? key,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.invalid = false,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool invalid;

  @override
  Widget build(BuildContext context) {
    TextStyle style = textTheme.titleMedium!;
    Color errorColor = Theme.of(context).colorScheme.error;
    Color hintColor = Theme.of(context).colorScheme.outline;

    return ShakeWidget(
      autoPlay: invalid,
      shakeConstant: ShakeHorizontalConstant2(),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: invalid
              ? style.copyWith(color: errorColor)
              : style.copyWith(color: hintColor),
          filled: true,
          fillColor: Theme.of(context).colorScheme.background,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: invalid ? errorColor : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}


// ignore: must_be_immutable
class InputCard extends StatelessWidget {
  InputCard({
    Key? key,
    required this.keyword,
    this.keyboardType,
  }) : super(key: key);

  String keyword;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return ECard(
      title: LangP.find(keyword).toUpperCase(),
      child: GetBuilder<InputP>(
        builder: (inputP) {
          return EInputField(
            controller: inputP.getFields(keyword)!.controller,
            hintText: inputP.getFields(keyword)!.hintText, // LangP.makeSentence('enter', keyword),
            invalid: inputP.getFields(keyword)!.invalid,
            keyboardType: keyboardType,
          );
        }
      ),
    );
  }
}