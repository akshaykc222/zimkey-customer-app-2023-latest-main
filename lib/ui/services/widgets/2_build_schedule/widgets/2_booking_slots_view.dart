import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/strings.dart';
import '../../../../../utils/helper/helper_functions.dart';
import '../../../../../utils/helper/helper_widgets.dart';
import '../../../cubit/overview_data_cubit.dart';
import '../bloc/schedule_bloc.dart';

class BookingSlotView extends StatelessWidget {
  const BookingSlotView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleBloc, ScheduleState>(
      listener: (context, state) {
        if (state is ScheduleTimeSlotLoaded) {
          BlocProvider.of<OverviewDataCubit>(context).addSlotTimingList(
              state.bookingSlotsResponse.getServiceBookingSlots);
        }
      },
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return Center(child: HelperWidgets.progressIndicator());
        } else if (state is ScheduleTimeSlotLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HelperWidgets.buildTitle(Strings.selectTime),
              const SizedBox(height: 10),
              BlocBuilder<OverviewDataCubit, OverviewDataCubitState>(
                builder: (context, cubitState) {
                  return cubitState.slotTimingList.length < 6
                      ? Center(
                          child: Wrap(
                            children: List.generate(
                              cubitState.slotTimingList.length,
                              (index) => bookingTimeSlot(index: index),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            HelperWidgets.buildHorizontalListView(
                                length: cubitState.slotTimingList.length,
                                itemBuilder: bookingTimeSlot,
                                height: 50,
                                modValue: 2),
                            HelperWidgets.buildHorizontalListView(
                                length: cubitState.slotTimingList.length,
                                itemBuilder: bookingTimeSlot,
                                height: 50,
                                modValue: 2,
                                showAlternate: true),
                          ],
                        );
                },
              ),
              Visibility(
                  visible:
                      state.bookingSlotsResponse.getServiceBookingSlots.isEmpty,
                  child: HelperWidgets.dataEmptyWidget(
                      msg: Strings.bookingSlotsEmpty))
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget bookingTimeSlot({required int index}) {
    return BlocBuilder<OverviewDataCubit, OverviewDataCubitState>(
      builder: (context, cubitState) {
        return InkWell(
          onTap: () {
            BlocProvider.of<OverviewDataCubit>(context)
                .addSelectedSlotTiming(cubitState.slotTimingList[index]);
          },
          child: Container(
            width: (MediaQuery.of(context).size.width / 4),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 11),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                  color: cubitState.selectedSlotTiming ==
                          cubitState.slotTimingList[index]
                      ? AppColors.zimkeyOrange
                      : AppColors.zimkeyLightGrey),
              color: cubitState.selectedSlotTiming ==
                      cubitState.slotTimingList[index]
                  ? AppColors.zimkeyBodyOrange
                  : AppColors.zimkeyLightGrey,
              borderRadius: BorderRadius.circular(5),
            ),
            child: AutoSizeText(
              // serviceBookingSlot.start.toString(),
              HelperFunctions.filterTimeSlot(cubitState.slotTimingList[index]),
              minFontSize: 11,
              maxFontSize: 13,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.zimkeyDarkGrey,
              ),
            ),
          ),
        );
      },
    );
  }
}
