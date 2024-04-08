import 'package:customer/navigation/route_generator.dart';
import 'package:customer/ui/booking_details/presentation/widgets/rework/cubit/rework_cubit.dart';
import 'package:customer/ui/services/cubit/overview_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../data/model/booking_slot/booking_slots_response.dart';
import '../../../../../../data/model/services/single_service_response.dart';
import '../../../../../../data/provider/bookings_provider.dart';
import '../../../../../../data/provider/schedule_provider.dart';
import '../../../../../../utils/helper/helper_functions.dart';
import '../../../../../../utils/helper/helper_widgets.dart';
import '../../../../../services/cubit/calculate_service_cost_cubit.dart';
import '../../../../../services/widgets/2_build_schedule/bloc/schedule_bloc.dart';
import '../../../../../services/widgets/2_build_schedule/widgets/1_month_and_date_view.dart';
import '../../../../../services/widgets/2_build_schedule/widgets/2_booking_slots_view.dart';
import '../../../../../services/widgets/3_build_payment/bloc/checkout_bloc/checkout_bloc.dart';
import '../../../../model/single_booking_details_response.dart';

class ReworkService extends StatefulWidget {
  final GetBookingServiceItem serviceItem;
  const ReworkService({
    Key? key,
    required this.serviceItem,
  }) : super(key: key);

  @override
  State<ReworkService> createState() => _ReworkServiceState();
}

class _ReworkServiceState extends State<ReworkService> {
  DateTime? fullBookingDate;
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  double? bottom;

  TextEditingController commentTextController = TextEditingController();
  final FocusNode _commentMsgNode = FocusNode();
  bool addheight = false;

  bool isLoading = false;
  List<String> timeHours = [];
  String? timeMin;
  String? timeHr;
  String? endHr;
  String? endMin;

  dynamic unitPrice;
  late BillingOption billingOption;

  @override
  void initState() {
    billingOption = BillingOption(
        id: widget.serviceItem.bookingService.serviceBillingOptionId,
        code: "code",
        name: "name",
        description: "description",
        recurring: false,
        recurringPeriod: "recurringPeriod",
        autoAssignPartner: false,
        unitPrice: UnitPrice(
            commission: 0,
            partnerPrice: 0,
            unitPrice: 0,
            commissionTax: 0,
            partnerTax: 0,
            total: 0,
            totalTax: 0),
        unit: "unit",
        minUnit: 1,
        maxUnit: 1,
        serviceAdditionalPayments: []);
    BlocProvider.of<OverviewDataCubit>(context)
        .setSelectedBillingOption(billingOption);

    _commentMsgNode.addListener(() {
      bool hasFocus = _commentMsgNode.hasFocus;
      if (hasFocus)
        setState(() {
          addheight = true;
        });
      else
        setState(() {
          addheight = false;
        });
    });

    super.initState();
  }

  void clearCubit() {
    if (mounted) {
      BlocProvider.of<CheckoutBloc>(context).add(ChangeStateToInitial());
      BlocProvider.of<OverviewDataCubit>(context).clearAllSelection();
      BlocProvider.of<CalculatedServiceCostCubit>(context)
          .clearTotalCalculation();
    }
  }

  @override
  Widget build(BuildContext context) {
    bottom = MediaQuery.of(context).viewInsets.bottom;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ScheduleBloc(
              scheduleProvider:
                  RepositoryProvider.of<ScheduleProvider>(context)),
        ),
        BlocProvider(
            create: (context) => ReworkCubit(
                bookingsProvider:
                    RepositoryProvider.of<BookingsProvider>(context))),
      ],
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: AppColors.zimkeyOrange,
              title: const Text(
                'Rework service',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.zimkeyWhite,
                ),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.zimkeyWhite,
                  size: 18,
                ),
                onPressed: () {
                  clearCubit();
                  Navigator.pushReplacementNamed(
                      context, RouteGenerator.singleBookingDetailScreen,
                      arguments: BookingDetailScreenArg(
                        id: widget.serviceItem.id,
                        fromPaymentPending: false,
                      ));
                },
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
            ),
            backgroundColor: AppColors.zimkeyWhite,
            body: BlocConsumer<ReworkCubit, ReworkState>(
              listener: (context, reworkState) {
                if (reworkState is ReworkRequestedState) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteGenerator.homeScreen, (route) => false,
                      arguments: HomeNavigationArg(bottomNavIndex: 2));
                }
              },
              builder: (context, reworkState) {
                if (reworkState is ReworkLoadingState) {
                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    child: Center(child: HelperWidgets.progressIndicator()),
                  );
                }
                return SingleChildScrollView(
                  child: SafeArea(
                    bottom: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // height: addheight
                          //     ? MediaQuery.of(context).size.height / 1.25
                          //     : MediaQuery.of(context).size.height + 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: AppColors.zimkeyBodyOrange,
                                    borderRadius: BorderRadius.circular(5)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Booking Service ',
                                            style: TextStyle(
                                              color: AppColors.zimkeyDarkGrey
                                                  .withOpacity(1.0),
                                              fontSize: 13,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          widget.serviceItem.bookingService
                                              .service.name,
                                          style: TextStyle(
                                            color: AppColors.zimkeyDarkGrey
                                                .withOpacity(1),
                                            fontSize: 13,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Date & Time ',
                                            style: TextStyle(
                                              color: AppColors.zimkeyDarkGrey
                                                  .withOpacity(1.0),
                                              fontSize: 13,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        HelperWidgets.buildText(
                                          text:
                                              '${widget.serviceItem.startDateTime.day}-${widget.serviceItem.startDateTime.month}-${widget.serviceItem.startDateTime.year} | ${HelperFunctions.filterTimeSlot(GetServiceBookingSlot(start: widget.serviceItem.startDateTime, end: widget.serviceItem.endDateTime, available: false))}',
                                          color: AppColors.zimkeyDarkGrey,
                                          fontSize: 13,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, left: 20, right: 20),
                                child: Text(
                                  'Select date',
                                  style: TextStyle(
                                    color: AppColors.zimkeyDarkGrey
                                        .withOpacity(0.7),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const MonthAndDateView(),
                              const BookingSlotView(),
                              const SizedBox(
                                height: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                  'Additional comments, if any',
                                  style: TextStyle(
                                    color: AppColors.zimkeyDarkGrey
                                        .withOpacity(0.7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.zimkeyLightGrey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  controller: commentTextController,
                                  focusNode: _commentMsgNode,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  // scrollPadding: EdgeInsets.only(bottom: bottom),
                                  maxLength: 300,
                                  maxLines: 5,
                                  style: const TextStyle(
                                    color: AppColors.zimkeyDarkGrey,
                                    // fontSize: 14,
                                  ),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    counterText: '',
                                    border: InputBorder.none,
                                    hintText: 'Enter your comments here',
                                    hintStyle: TextStyle(
                                      color: AppColors.zimkeyDarkGrey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<OverviewDataCubit, OverviewDataCubitState>(
                          builder: (context, overViewState) {
                            return Center(
                                child: InkWell(
                              onTap: () {
                                if (overViewState
                                    .selectedSlotTiming.available) {
                                  BlocProvider.of<ReworkCubit>(context)
                                      .requestRework(
                                          bookingServiceItemId:
                                              widget.serviceItem.id,
                                          scheduleTime: overViewState
                                              .selectedSlotTiming.start,
                                          scheduleEndDateTime: overViewState
                                              .selectedSlotTiming.end,
                                          modificationReason:
                                              commentTextController.text);
                                } else {
                                  HelperWidgets.showTopSnackBar(
                                      context: context,
                                      title: "Oops",
                                      message:
                                          "Please select Time slot to continue",
                                      icon: const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 28,
                                      ),
                                      isError: false);
                                }
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width - 190,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: AppColors.zimkeyOrange,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.zimkeyLightGrey
                                            .withOpacity(0.1),
                                        blurRadius: 5.0, // soften the shadow
                                        spreadRadius: 2.0, //extend the shadow
                                        offset: const Offset(
                                          1.0, // Move to right 10  horizontally
                                          1.0, // Move to bottom 10 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                  child: const Text(
                                    'Confirm',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.zimkeyWhite,
                                      fontFamily: 'Inter',
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ));
                          },
                        ),
                        SizedBox(
                          height: addheight
                              ? MediaQuery.of(context).size.height / 4.5
                              : 40,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

// confirmationNextSlotDialog(
//     String title, String msg, Widget nextPage, String billingoptionId) {
//   showGeneralDialog(
//       barrierColor: Colors.black.withOpacity(0.5),
//       transitionBuilder: (context, a1, a2, widget) {
//         return Transform.scale(
//           scale: a1.value,
//           child: Opacity(
//             opacity: a1.value,
//             child: AlertDialog(
//               contentTextStyle: TextStyle(
//                 color: AppColors.zimkeyBlack,
//                 fontWeight: FontWeight.normal,
//                 fontSize: 15,
//               ),
//               titlePadding: EdgeInsets.symmetric(
//                 vertical: 0,
//                 horizontal: 0,
//               ),
//               contentPadding: EdgeInsets.symmetric(
//                 vertical: 15,
//                 horizontal: 0,
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(20.0),
//                 ),
//               ),
//               title: Container(
//                 padding: EdgeInsets.only(left: 20, right: 15, top: 15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         '$title',
//                         style: TextStyle(
//                           color: AppColors.zimkeyDarkGrey,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         if (nextPage != null)
//                           Navigator.push(
//                             context,
//                             PageTransition(
//                               type: PageTransitionType.bottomToTop,
//                               child: nextPage,
//                               duration: Duration(milliseconds: 300),
//                             ),
//                           );
//                         else
//                           Get.back();
//                       },
//                       child: Container(
//                         width: 30,
//                         height: 30,
//                         decoration: BoxDecoration(
//                           color: AppColors.zimkeyDarkGrey.withOpacity(0.1),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.clear,
//                           color: AppColors.zimkeyDarkGrey,
//                           size: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               content: Container(
//                 padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
//                 child: new Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       '$msg',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: AppColors.zimkeyDarkGrey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 new InkWell(
//                   onTap: () async {
//                     // if (nextPage != null)
//                     //   Navigator.push(
//                     //     context,
//                     //     PageTransition(
//                     //       type: PageTransitionType.bottomToTop,
//                     //       child: Dashboard(),
//                     //       duration: Duration(milliseconds: 300),
//                     //     ),
//                     //   );
//                     // else {
//                     //   // setState(() {
//                     //   //   fullBookingDate =
//                     //   //       fullBookingDate.add(new Duration(days: 1));
//                     //   //   selectedDate = fullBookingDate;
//                     //   // });
//                     //   Get.back();
//                     //   await getBookingTimeSlots(
//                     //       billingoptionId, true, nextPage);
//                     // }
//                   },
//                   child: Container(
//                     width: MediaQuery.of(context).size.width / 2,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: AppColors.zimkeyOrange,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.zimkeyDarkGrey.withOpacity(0.1),
//                           blurRadius: 5.0, // soften the shadow
//                           spreadRadius: 1.0, //extend the shadow
//                           offset: Offset(
//                             2.0, // Move to right 10  horizontally
//                             3.0, // Move to bottom 10 Vertically
//                           ),
//                         )
//                       ],
//                     ),
//                     padding:
//                     EdgeInsets.symmetric(horizontal: 20, vertical: 13),
//                     child: const Text(
//                       'Confirm',
//                       style: TextStyle(
//                         color: AppColors.zimkeyOrange,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       transitionDuration: Duration(milliseconds: 250),
//       barrierDismissible: true,
//       barrierLabel: '',
//       context: context,
//       pageBuilder: (context, animation1, animation2) {});
// }
}
