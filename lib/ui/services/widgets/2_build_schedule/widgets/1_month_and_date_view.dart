import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/strings.dart';
import '../../../../../utils/helper/helper_widgets.dart';
import '../../../cubit/overview_data_cubit.dart';
import '../bloc/schedule_bloc.dart';

class MonthAndDateView extends StatefulWidget {
  const MonthAndDateView({Key? key}) : super(key: key);

  @override
  State<MonthAndDateView> createState() => _MonthAndDateViewState();
}

class _MonthAndDateViewState extends State<MonthAndDateView> {
  ValueNotifier<List<String>> tempMonthNotifier =
      ValueNotifier(List.empty(growable: true));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateMonths();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewDataCubit, OverviewDataCubitState>(
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 15),
            ValueListenableBuilder(
              valueListenable: tempMonthNotifier,
              builder: (BuildContext context, value, Widget? child) {
                return HelperWidgets.buildHorizontalListView(
                    length: value.length, itemBuilder: buildMonth, height: 50);
              },
            ),
            const SizedBox(height: 10),
            buildDatePicker(),
            const SizedBox(height: 15),
          ],
        );
      },
    );
  }

  Widget buildMonth({required int index}) {
    return InkWell(
      onTap: () async {
        BlocProvider.of<OverviewDataCubit>(context)
            .addSelectedMonth(tempMonthNotifier.value[index]);
        await calculateDays();
      },
      child: BlocBuilder<OverviewDataCubit, OverviewDataCubitState>(
        builder: (context, state) {
          return Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(
              minWidth: 70,
              maxWidth: 100,
            ),
            margin: const EdgeInsets.only(right: 5, top: 3, bottom: 3),
            width: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: state.selectedMonth == tempMonthNotifier.value[index]
                    ? AppColors.zimkeyOrange
                    : AppColors.zimkeyLightGrey,
              ),
              color: state.selectedMonth == tempMonthNotifier.value[index]
                  ? AppColors.zimkeyBodyOrange
                  : AppColors.zimkeyLightGrey,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 10),
            child: HelperWidgets.buildText(
                text: tempMonthNotifier.value[index].toString().substring(0, 3),
                fontSize: 13),
          );
        },
      ),
    );
  }

  Widget buildDatePicker() {
    return BlocBuilder<OverviewDataCubit, OverviewDataCubitState>(
      builder: (context, state) {
        print(state.selectedDay);
        return HelperWidgets.buildHorizontalListView(
            length: state.daysList.length,
            itemBuilder: ({required int index}) {
              return InkWell(
                onTap: () async {
                  if (!checkDate(
                      selectedDay: state.selectedDay,
                      listedDay: state.daysList[index])) {
                    BlocProvider.of<OverviewDataCubit>(context)
                        .addSelectedDay(state.daysList[index]);
                    print("biiling id :${state.selectedBillingOption.length}");

                    BlocProvider.of<ScheduleBloc>(context).add(LoadTimeSlots(
                        billingId: state.selectedBillingOption.first.id,
                        date: state.daysList[index].toString()));
                  }
                },
                child: Container(
                  width: 50,
                  constraints: const BoxConstraints(
                    maxWidth: 80,
                    minWidth: 40,
                  ),
                  margin: const EdgeInsets.only(right: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: checkDate(
                            selectedDay: state.selectedDay,
                            listedDay: state.daysList[index])
                        ? AppColors.zimkeyBodyOrange
                        : AppColors.zimkeyLightGrey,
                    border: Border.all(
                      color: checkDate(
                              selectedDay: state.selectedDay,
                              listedDay: state.daysList[index])
                          ? AppColors.zimkeyOrange
                          : AppColors.zimkeyLightGrey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HelperWidgets.buildText(
                        text: formatDate(state.daysList[index], [d])
                            .toUpperCase(),
                        color: AppColors.zimkeyDarkGrey,
                        fontSize: 13,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      HelperWidgets.buildText(
                        text: formatDate(state.daysList[index], [D])
                            .substring(0, 3)
                            .toUpperCase(),
                        color: AppColors.zimkeyDarkGrey,
                        fontSize: 10,
                      ),
                    ],
                  ),
                ),
              );
            },
            height: 50);
      },
    );
  }

  void calculateMonths() {
    final monthIndex =
        Strings.months.indexOf(Strings.months[DateTime.now().month - 1]);
    tempMonthNotifier.value = Strings.months.sublist(monthIndex);
    final monthNo = monthIndex;
    if (monthNo >= Strings.months.length - 2) {
      tempMonthNotifier.value.addAll([Strings.months[0], Strings.months[1]]);
    }
    calculateDays();
  }

  Future<void> calculateDays() async {
    final now = DateTime.now();
    final selectedMonthValue =
        BlocProvider.of<OverviewDataCubit>(context).cubitState.selectedMonth;

    DateTime startDate;
    DateTime endDate;

    if (selectedMonthValue == Strings.months[now.month - 1]) {
      final lastDayDateTime = DateTime(now.year, now.month + 1, 0);
      startDate = now.isAfter(DateTime(now.year, now.month, now.day, 15))
          ? DateTime(now.year, now.month, now.day + 1)
          : now;
      endDate = lastDayDateTime;
    } else {
      final monthIn = Strings.months.indexOf(selectedMonthValue);
      final month = monthIn + 1;
      final lastDayDateTime = month < 12
          ? DateTime(now.year, month + 1, 0)
          : DateTime(now.year + 1, 1, 0);
      startDate = DateTime(month < now.month ? now.year + 1 : now.year, month);
      endDate = lastDayDateTime;
    }
    // if (now.month==endDate.month &&now.day == endDate.day && now.hour >= 15) {
    //   final lastMonthIndex = Strings.months.indexOf(Strings.months[endDate.month - 1]);
    //   tempMonthNotifier.value = Strings.months.sublist(lastMonthIndex + 1);
    // }
    calculateDaysInterval(startDate, endDate);
  }

  void calculateDaysInterval(DateTime startDate, DateTime endDate) {
    final days = <DateTime>[];
    final now = DateTime.now();
    final isCurrentMonth =
        startDate.month == now.month && startDate.year == now.year;

    final startDay =
        isCurrentMonth && now.day == startDate.day && now.hour >= 15
            ? startDate.day + 1
            : startDate.day;
    final totalDays = endDate
        .difference(DateTime(startDate.year, startDate.month, startDay))
        .inDays;

    for (int i = 0; i <= totalDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    BlocProvider.of<OverviewDataCubit>(context).addDaysList(days);
  }

  bool checkDate({required DateTime selectedDay, required DateTime listedDay}) {
    return selectedDay.day == listedDay.day &&
        selectedDay.month == listedDay.month &&
        selectedDay.year == listedDay.year;
  }
}
