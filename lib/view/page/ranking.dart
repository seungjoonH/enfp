import 'package:enfp/global/number.dart';
import 'package:enfp/global/string.dart';
import 'package:enfp/global/theme.dart';
import 'package:enfp/model/enum/rank_type.dart';
import 'package:enfp/model/class/user.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:enfp/presenter/page/ranking.dart';
import 'package:enfp/view/widget/bottom_bar.dart';
import 'package:enfp/view/widget/card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: GetBuilder<RankingP>(
          builder: (rankingP) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: RankType.values.map((type) => RankSelectionButton(
                    type: type, selected: type == rankingP.currentType,
                    onPressed: () => rankingP.changeType(type),
                  )).toList(),
                ),
                const SizedBox(height: 40.0),
                ECard(
                  title: capitalizeFirstChar(LangP.find('rank')),
                  width: double.infinity,
                  child: ListView.separated(
                    itemCount: rankingP.rankUsers.length,
                    itemBuilder: (context, index) {
                      EUser user = rankingP.rankUsers[index];
                      bool isMe = user.uid == Get.find<UserP>().loggedUser.uid;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 40.0, height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isMe
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.background,
                            ),
                            child: Center(
                              child: Text('${index + 1}',
                                style: textTheme.titleMedium?.copyWith(
                                  color: isMe
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onBackground,
                                  fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          SizedBox(
                            width: 86.0,
                            child: Text(
                              user.nickname,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleMedium?.copyWith(
                                color: isMe
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onBackground,
                                fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: Text(
                              '${toLocalString(user.score)} ${LangP.find('point')}',
                              textAlign: TextAlign.end,
                              style: textTheme.titleSmall?.copyWith(
                                color: isMe
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onBackground,
                                fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 20.0),
                    shrinkWrap: true,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const EBottomNavigationBar(),
    );
  }
}

class RankSelectionButton extends StatelessWidget {
  const RankSelectionButton({
    Key? key,
    required this.type,
    this.selected = false,
    this.onPressed,
  }) : super(key: key);

  final RankType type;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(20.0),
      elevation: 3.0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: 100.0,
          height: 50.0,
          alignment: Alignment.center,
          child: Text([
              capitalizeFirstChar(LangP.find('friend')),
              capitalizeFirstChar(LangP.find('entire')),
            ][type.index],
            style: textTheme.titleMedium!
                .copyWith(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}