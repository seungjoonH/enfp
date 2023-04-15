import 'package:enfp/global/date.dart';
import 'package:enfp/global/theme.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:enfp/view/widget/bottom_bar.dart';
import 'package:enfp/view/widget/card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                ECard(
                  title: '오늘의 운동 현황',
                  width: double.infinity,
                  child: Builder(
                    builder: (context) {
                      final userP = Get.find<UserP>();
                      int goal = userP.loggedUser.goal;
                      int record = userP.loggedUser.getAmount(today);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearPercentIndicator(
                            percent: record / goal,
                            progressColor: Theme.of(context).colorScheme.secondary,
                            backgroundColor: Theme.of(context).colorScheme.background,
                            lineHeight: 35.0,
                            barRadius: const Radius.circular(5.0),
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: 5.0),
                          Text('$record / $goal회'),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                ECard(
                  title: '${today.month}월의 스트릭',
                  width: double.infinity,
                  child: SizedBox(
                    height: 43.0 * 6,
                    child: Builder(
                      builder: (context) {
                        DateTime firstDay = firstDayOfMonth(today);
                        int firstWeekday = firstDay.weekday;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (i) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(7, (j) {
                              int day = 7 * i + j - firstWeekday + 2;
                              bool avail = day == firstDay.add(Duration(days: day - 1)).day;

                              String dayString = avail ? '$day' : '';
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: avail
                                      ? Theme.of(context).colorScheme.background
                                      : Colors.transparent,
                                ),
                                width: 35.0, height: 35.0,
                                child: Center(
                                  child: Text(
                                    dayString,
                                    style: textTheme.titleMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          )),
                        );
                      }
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
