import 'dart:math';

import 'package:enfp/global/date.dart';
import 'package:enfp/global/number.dart';
import 'package:enfp/global/string.dart';
import 'package:enfp/global/theme.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:enfp/view/widget/bottom_bar.dart';
import 'package:enfp/view/widget/card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserP>();
    int goal = userP.loggedUser.goal;
    int record = userP.loggedUser.getAmount(today);
    DateTime firstDay = firstDayOfMonth(today);
    int firstWeekday = firstDay.weekday;
    int rows = today.difference(firstDay).inDays ~/ 7 + 1;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ECard(
                        title: capitalizeFirstChar(LangP.find('score')),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 100.0, height: 48.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: Theme.of(context).colorScheme.background,
                              ),
                              child: Center(
                                child: Text(toLocalString(userP.loggedUser.score)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: ECard(
                        title: capitalizeFirstChar(LangP.find('rank')),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 48.0, height: 48.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.background,
                              ),
                              child: Center(
                                child: Text('1000'),
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Container(
                              width: 48.0, height: 48.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.background,
                              ),
                              child: Center(
                                child: Text('1000'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ECard(
                  title: capitalizeFirstChar(LangP.makeSentence('ex-stat', 'today')),
                  width: double.infinity,
                  onPressed: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearPercentIndicator(
                        percent: min(record / goal, 1),
                        progressColor: Theme.of(context).colorScheme.secondary,
                        backgroundColor: Theme.of(context).colorScheme.background,
                        lineHeight: 35.0,
                        barRadius: const Radius.circular(5.0),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 5.0),
                      Text('$record / $goal ${LangP.find('times')}'),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                ECard(
                  title: LangP.makeSentence('cal-of', '${today.month}-month'),
                  width: double.infinity,
                  child: SizedBox(
                    height: 43.0 * rows,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(rows, (i) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (j) {
                          int day = 7 * i + j - firstWeekday + 2;
                          DateTime date = firstDay.add(Duration(days: day - 1));
                          bool avail = day == date.day && isInDateRange(date, firstDay, today);
                          bool completed = userP.loggedUser.getCompleted(date);
                          String dayString = avail ? '$day' : '';
                          Color color = avail
                              ? Theme.of(context).colorScheme.background
                              : Colors.transparent;
                          Color textColor = Theme.of(context).colorScheme.outline;

                          if (completed) {
                            color = Theme.of(context).colorScheme.secondary;
                            textColor = Theme.of(context).colorScheme.onSecondary;
                          }

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: color,
                            ),
                            width: 35.0, height: 35.0,
                            child: Center(
                              child: Text(
                                dayString,
                                style: textTheme.titleMedium?.copyWith(
                                  color: textColor,
                                ),
                              ),
                            ),
                          );
                        }),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const EBottomNavigationBar(),
    );
  }
}
