import 'package:enfp/global/string.dart';
import 'package:enfp/global/theme.dart';
import 'package:enfp/model/enum/lang.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:enfp/presenter/page/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LangPage extends StatelessWidget {
  const LangPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LangP>(
      builder: (langP) {
        return Scaffold(
          appBar: AppBar(
            title: Text(capitalizeFirstChar(LangP.find('language'))),
            actions: [
              IconButton(
                onPressed: RegisterP.toRegister,
                icon: Text(LangP.find('next')),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Lang.values.map<Widget>((l) => LangSelectionButton(
                type: l,
                selected: l == LangP.lang,
                onPressed: () => LangP.lang = l,
              )).toList()..insert(1, const SizedBox(height: 30.0)),
            ),
          ),
        );
      },
    );
  }
}

class LangSelectionButton extends StatelessWidget {
  const LangSelectionButton({
    Key? key,
    required this.type,
    this.selected = false,
    this.onPressed,
  }) : super(key: key);

  final Lang type;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(20.0),
      elevation: 5.0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: 200.0,
          height: 200.0,
          alignment: Alignment.center,
          child: Text(
            type == Lang.eng ? 'English' : '한국어',
            style: textTheme.titleLarge!
                .copyWith(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
