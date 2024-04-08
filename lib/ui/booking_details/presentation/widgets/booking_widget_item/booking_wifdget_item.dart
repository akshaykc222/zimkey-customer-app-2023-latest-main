import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:recase/recase.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/strings.dart';
import '../../../../../data/model/booking_slot/booking_slots_response.dart';
import '../../../../../data/model/checkout/update_payment/payment_update_request.dart';
import '../../../../../navigation/route_generator.dart';
import '../../../../../utils/helper/helper_dialog.dart';
import '../../../../../utils/helper/helper_functions.dart';
import '../../../../../utils/helper/helper_widgets.dart';
import '../../../../../utils/object_factory.dart';
import '../../../../profile/widgets/html_view/html_view_screen.dart';
import '../../../../services/widgets/3_build_payment/bloc/checkout_bloc/checkout_bloc.dart';
import '../../../data/bloc/booking_details_bloc.dart';
import '../../../data/cubit/accept_or_decline_cubit/accept_or_decline_cubit.dart';
import '../../../data/cubit/call_service_partner/call_partner_cubit.dart';
import '../../../data/cubit/pending_payment/pending_payment_cubit.dart';
import '../../../model/single_booking_details_response.dart';

class BookingDetailsItem extends StatefulWidget {
  final GetBookingServiceItem getBookingServiceItem;
  final ValueNotifier<String> bookingStatusNotifier;
  final ValueNotifier<GetServiceBookingSlot> serviceWorkTimeNotifier;
  final ValueNotifier<bool> showRescheduleView;
  final ValueNotifier<bool> pendingPaymentNotifier;
  final ValueNotifier<String> orderIdNotifier;
  final ValueNotifier<List<AdditionalWork>> addonListNotifier;

  const BookingDetailsItem(
      {Key? key,
      required this.getBookingServiceItem,
      required this.bookingStatusNotifier,
      required this.serviceWorkTimeNotifier,
      required this.showRescheduleView,
      required this.orderIdNotifier,
      required this.pendingPaymentNotifier,
      required this.addonListNotifier})
      : super(key: key);

  @override
  State<BookingDetailsItem> createState() => _BookingDetailsItemState();
}

class _BookingDetailsItemState extends State<BookingDetailsItem> {
  final ValueNotifier<bool> expandPaymentDetailsNotifier = ValueNotifier(true);

  final _razorpay = Razorpay();
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Logger().i(PaymentConfirmGqlInput(
            bookingPaymentId: widget.orderIdNotifier.value,
            paymentId: response.paymentId ?? "",
            signature: response.signature ?? "")
        .toJson());

    BlocProvider.of<CheckoutBloc>(context).add(UpdatePaymentStatus(
        paymentConfirmGqlInput: PaymentConfirmGqlInput(
            bookingPaymentId: widget.orderIdNotifier.value,
            paymentId: response.paymentId ?? "",
            signature: response.signature ?? "")));
  }

  void _handlePaymentError(PaymentFailureResponse response) {}

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    debugPrint('response wallet ....... $response');
  }

  @override
  void initState() {
    super.initState();
    //razorpay init---------
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    String bookingItemType;
    var address =
        widget.getBookingServiceItem.bookingService.booking.bookingAddress;
    var payment = widget.getBookingServiceItem.chargedPrice;
    bookingItemType = "bookingServiceItemType";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.zimkeyWhite,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.zimkeyDarkGrey.withOpacity(0.2),
            offset: const Offset(1.0, 3.0),
            blurRadius: 5.0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking ID: ${widget.getBookingServiceItem.bookingService.booking.userBookingNumber}',
                  style: TextStyle(
                    color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Code : ${widget.getBookingServiceItem.workCode}',
                  style: TextStyle(
                    color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          rescheduleServiceAcceptOrDecline(widget.getBookingServiceItem),
          pendingPaymentView(widget.getBookingServiceItem),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            decoration: BoxDecoration(
              color: AppColors.zimkeyLightGrey,
              borderRadius: BorderRadius.circular(7),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                billingOptionSection(widget.getBookingServiceItem.bookingService
                    .serviceBillingOption.name),
                buildAddressView(address),
                buildServiceReqView(widget.getBookingServiceItem),
                buildCancellationPolicy(context, widget.getBookingServiceItem),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          //Booking Service items
          // if (widget.bookingItem.bookingService != null &&
          //     widget.bookingItem.bookingService.bookingServiceItems != null &&
          //     widget.bookingItem.bookingService.bookingServiceItems.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.zimkeyLightGrey,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: widget.bookingStatusNotifier,
                        builder: (BuildContext context, value, Widget? child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              HelperWidgets.buildText(
                                  text: "Status", fontSize: 13),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.zimkeyGreen.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: HelperWidgets.buildText(
                                  text: value,
                                  color: AppColors.zimkeyDarkGrey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HelperWidgets.buildText(
                              text: "Service Type", fontSize: 13),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: widget.getBookingServiceItem
                                        .bookingServiceItemType ==
                                    "REWORK"
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.zimkeyOrange)
                                : null,
                            child: HelperWidgets.buildText(
                                text: widget.getBookingServiceItem
                                    .bookingServiceItemType,
                                fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ValueListenableBuilder(
                        valueListenable: widget.serviceWorkTimeNotifier,
                        builder:
                            (BuildContext context, workTime, Widget? child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              HelperWidgets.buildText(
                                  text: "Date & Time", fontSize: 13),
                              HelperWidgets.buildText(
                                text:
                                    '${workTime.start.day}-${workTime.start.month}-${workTime.start.year} | ${HelperFunctions.filterTimeSlot(workTime)}',
                                color: AppColors.zimkeyDarkGrey,
                                fontSize: 13,
                              )
                            ],
                          );
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      widget.getBookingServiceItem.propertyType == null
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HelperWidgets.buildText(
                                    text: "Property Type", fontSize: 13),
                                HelperWidgets.buildText(
                                    text: widget.getBookingServiceItem
                                        .propertyType!.title,
                                    fontSize: 13,
                                    color: AppColors.zimkeyDarkGrey),
                              ],
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      widget.getBookingServiceItem.room == null
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HelperWidgets.buildText(
                                    text: "Room Type", fontSize: 13),
                                HelperWidgets.buildText(
                                    text: widget
                                        .getBookingServiceItem.room!.title,
                                    fontSize: 13,
                                    color: AppColors.zimkeyDarkGrey),
                              ],
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      widget.getBookingServiceItem.propertyArea == null
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HelperWidgets.buildText(
                                    text: "Property Area", fontSize: 13),
                                HelperWidgets.buildText(
                                    text: widget.getBookingServiceItem
                                        .propertyArea!.title,
                                    fontSize: 13,
                                    color: AppColors.zimkeyDarkGrey),
                              ],
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      widget.getBookingServiceItem.isFurnished == null
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HelperWidgets.buildText(
                                    text: "Furnished", fontSize: 13),
                                HelperWidgets.buildText(
                                    text: widget.getBookingServiceItem
                                                .isFurnished ==
                                            true
                                        ? "Yes"
                                        : "No",
                                    fontSize: 13,
                                    color: AppColors.zimkeyDarkGrey),
                              ],
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     HelperWidgets.buildText(
                      //         text: "Service Type", fontSize: 13),
                      //     HelperWidgets.buildText(
                      //         text: widget
                      //             .getBookingServiceItem.bookingServiceItemType,
                      //         fontSize: 13),
                      //   ],
                      // ),
                      widget.getBookingServiceItem.isCancelled
                          ? Container()
                          : Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 0;
                                      i <
                                          widget.getBookingServiceItem
                                              .statusTracker.length;
                                      i++)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: widget.getBookingServiceItem
                                                  .statusTracker[i].statusValue
                                              ? AppColors.zimkeyOrange
                                              : AppColors.zimkeyDarkGrey
                                                  .withOpacity(0.7),
                                          size: 18,
                                        ),
                                        AutoSizeText(
                                          widget.getBookingServiceItem
                                              .statusTracker[i].statusLabel,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: widget
                                                    .getBookingServiceItem
                                                    .statusTracker[i]
                                                    .statusValue
                                                ? AppColors.zimkeyOrange
                                                : AppColors.zimkeyDarkGrey
                                                    .withOpacity(0.7),
                                          ),
                                          maxFontSize: 12,
                                          minFontSize: 9,
                                        ),
                                        if (i <
                                            widget.getBookingServiceItem
                                                    .statusTracker.length -
                                                1)
                                          Container(
                                            color: widget
                                                    .getBookingServiceItem
                                                    .statusTracker[i]
                                                    .statusValue
                                                ? AppColors.zimkeyOrange
                                                : AppColors.zimkeyDarkGrey2,
                                            height: 1.5,
                                            width: 25,
                                            constraints: const BoxConstraints(
                                                maxWidth: 50, minWidth: 2),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //reschedule

                            //reschedule
                            widget.getBookingServiceItem.canReschedule
                                ? Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        Navigator.pushReplacementNamed(context,
                                            RouteGenerator.reScheduleScreen,
                                            arguments:
                                                widget.getBookingServiceItem);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: AppColors.zimkeyWhite,
                                          // color: AppColors.buttonColor,
                                          // border: Border.all(
                                          //   color: zimkeyOrange.withOpacity(0.7),
                                          // ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.zimkeyDarkGrey
                                                  .withOpacity(0.1),
                                              blurRadius:
                                                  5.0, // soften the shadow
                                              spreadRadius:
                                                  1.0, //extend the shadow
                                              offset: const Offset(
                                                2.0, // Move to right 10  horizontally
                                                3.0, // Move to bottom 10 Vertically
                                              ),
                                            )
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 13),
                                        child: const Text(
                                          'Reschedule',
                                          style: TextStyle(
                                            color:
                                                AppColors.zimkeySecondaryColor,
                                            // color: AppColors.zimkeyWhite,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            //Rework button

                            widget.getBookingServiceItem.canRework
                                ? Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        Navigator.pushReplacementNamed(context,
                                            RouteGenerator.reworkScreen,
                                            arguments:
                                                widget.getBookingServiceItem);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: AppColors.zimkeyWhite,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.zimkeyDarkGrey
                                                  .withOpacity(0.1),
                                              blurRadius:
                                                  5.0, // soften the shadow
                                              spreadRadius:
                                                  1.0, //extend the shadow
                                              offset: const Offset(
                                                2.0, // Move to right 10  horizontally
                                                3.0, // Move to bottom 10 Vertically
                                              ),
                                            )
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 13),
                                        child: const Text(
                                          'Rework',
                                          style: TextStyle(
                                            color:
                                                AppColors.zimkeySecondaryColor,
                                            // color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            //cancel booking

                            widget.getBookingServiceItem.canCancel
                                ? Expanded(
                                    child: InkWell(
                                      onTap: () =>
                                          HelperDialog.confirmActionDialog(
                                              title: Strings.cancelBooking,
                                              context: context,
                                              msg: Strings.cancelBookingDetails,
                                              btn2Text: Strings.confirmText,
                                              btn1Text: Strings.cancel,
                                              btn2Pressed: () {
                                                BlocProvider.of<
                                                            BookingDetailsBloc>(
                                                        context)
                                                    .add(CancelWork(
                                                        bookingId: widget
                                                            .getBookingServiceItem
                                                            .id));
                                                Navigator.pop(context);
                                              },
                                              btn1Pressed: () =>
                                                  Navigator.pop(context)),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: AppColors.zimkeyWhite,
                                          // border: Border.all(
                                          //   color: zimkeyOrange.withOpacity(0.7),
                                          // ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.zimkeyDarkGrey
                                                  .withOpacity(0.1),
                                              blurRadius:
                                                  5.0, // soften the shadow
                                              spreadRadius:
                                                  1.0, //extend the shadow
                                              offset: const Offset(
                                                2.0, // Move to right 10  horizontally
                                                3.0, // Move to bottom 10 Vertically
                                              ),
                                            )
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 13),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color:
                                                AppColors.zimkeySecondaryColor,
                                            // color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      widget.getBookingServiceItem.canCallPartner
                          ? BlocConsumer<CallPartnerCubit, CallPartnerState>(
                              listener: (context, callPartnerState) {
                                if (callPartnerState
                                    is CallPartnerSuccessState) {
                                  HelperWidgets.showTopSnackBar(
                                      context: context,
                                      message:
                                          "Request Submitted. Partner will call soon. Please wait..",
                                      isError: false,
                                      icon: const Icon(
                                        Icons.check_box_outlined,
                                        color: Colors.green,
                                      ));
                                } else if (callPartnerState
                                    is CallPartnerErrorState) {
                                  HelperWidgets.showTopSnackBar(
                                      context: context,
                                      title: "Oops..",
                                      message:
                                          "Something went wrong. Cannot connect to partner right now..",
                                      isError: true,
                                      icon: const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ));
                                }
                              },
                              builder: (context, callPartnerState) {
                                return InkWell(
                                  onTap: () => callPartnerState
                                          is! CallPartnerLoadingState
                                      ? HelperDialog.confirmActionDialog(
                                          title: Strings.callRequest,
                                          context: context,
                                          msg: Strings.callRequestDetails,
                                          btn2Text: Strings.requestCall,
                                          btn1Text: Strings.cancel,
                                          btn2Pressed: () {
                                            BlocProvider.of<CallPartnerCubit>(
                                                    context)
                                                .callServicePartner(
                                                    id: widget
                                                        .getBookingServiceItem
                                                        .id);
                                            Navigator.pop(context);
                                          },
                                          btn1Pressed: () =>
                                              Navigator.pop(context))
                                      : {},
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 13, horizontal: 10),
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.zimkeyBodyOrange,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.zimkeyLightGrey
                                              .withOpacity(0.1),
                                          blurRadius: 2.0, // soften the shadow
                                          spreadRadius: 1.0, //extend the shadow
                                          offset: const Offset(
                                            2.0, // Move to right 10  horizontally
                                            2.0, // Move to bottom 10 Vertically
                                          ),
                                        )
                                      ],
                                    ),
                                    child: callPartnerState
                                            is CallPartnerLoadingState
                                        ? Center(
                                            child: SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: HelperWidgets
                                                    .progressIndicator()))
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/icons/newIcons/call.svg',
                                                color: AppColors.zimkeyOrange,
                                                height: 20,
                                              ),
                                              const SizedBox(width: 5),
                                              const Text(
                                                'Call Service Partner',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppColors.zimkeyOrange,
                                                  // color: AppColors.zimkeySecondaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                );
                              },
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ],
            ),
          ),

          //Cancellation Details
          widget.getBookingServiceItem.isCancelled &&
                  widget.getBookingServiceItem.bookingServiceItemType !=
                      "REWORK"
              ? cancellationDetails(widget.getBookingServiceItem.cancelDetails!)
              : const SizedBox(),
          //Payment details---
          widget.getBookingServiceItem.bookingServiceItemType == "REWORK"
              ? const SizedBox()
              : paymentDetailsSection(widget.getBookingServiceItem.chargedPrice,
                  widget.getBookingServiceItem.additionalWorks),
        ],
      ),
    );
  }

  BlocConsumer<AcceptOrDeclineCubit, AcceptOrDeclineState>
      rescheduleServiceAcceptOrDecline(
          GetBookingServiceItem getBookingServiceItem) {
    return BlocConsumer<AcceptOrDeclineCubit, AcceptOrDeclineState>(
      listener: (context, state) {
        if (state is AcceptOrDeclineSuccessState) {
          widget.showRescheduleView.value = false;
          widget.bookingStatusNotifier.value =
              state.acceptOrDeclineResponse.approveJob.bookingServiceItemStatus;
          widget.serviceWorkTimeNotifier.value = GetServiceBookingSlot(
              start: state.acceptOrDeclineResponse.approveJob.startDateTime,
              end: state.acceptOrDeclineResponse.approveJob.endDateTime,
              available: true);
        }
      },
      builder: (context, state) {
        return ValueListenableBuilder(
          valueListenable: widget.showRescheduleView,
          builder: (BuildContext context, value, Widget? child) {
            return Visibility(
                visible: value,
                child: Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                  decoration: BoxDecoration(
                    color: AppColors.zimkeyLightGrey,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HelperWidgets.buildText(
                          text: "Reschedule Request",
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      const SizedBox(
                        height: 10,
                      ),
                      HelperWidgets.buildText(
                          text: getBookingServiceItem
                                      .pendingRescheduleByPartner !=
                                  null
                              ? "Partner want to reschedule this work to \n${getBookingServiceItem.pendingRescheduleByPartner!.startDateTime.day}-${getBookingServiceItem.pendingRescheduleByPartner!.startDateTime.month}-${getBookingServiceItem.pendingRescheduleByPartner!.startDateTime.year} | ${HelperFunctions.filterTimeSlot(GetServiceBookingSlot(start: getBookingServiceItem.pendingRescheduleByPartner!.startDateTime, end: getBookingServiceItem.pendingRescheduleByPartner!.endDateTime, available: true))}"
                              : "",
                          overflow: TextOverflow.visible,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => HelperDialog.confirmActionDialog(
                                  title: Strings.rescheduleWork,
                                  context: context,
                                  msg: Strings.declineRescheduleBooking,
                                  btn2Text: Strings.confirmText,
                                  btn1Text: Strings.cancel,
                                  btn2Pressed: () {
                                    BlocProvider.of<AcceptOrDeclineCubit>(
                                            context)
                                        .acceptOrDeclineRequest(
                                            id: getBookingServiceItem.id,
                                            status: false);
                                    Navigator.pop(context);
                                  },
                                  btn1Pressed: () => Navigator.pop(context)),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.zimkeyWhite,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.zimkeyDarkGrey
                                          .withOpacity(0.1),
                                      blurRadius: 5.0, // soften the shadow
                                      spreadRadius: 1.0, //extend the shadow
                                      offset: const Offset(
                                        2.0, // Move to right 10  horizontally
                                        3.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 13),
                                child: const Text(
                                  'Decline',
                                  style: TextStyle(
                                    color: AppColors.zimkeyRed,
                                    // color: AppColors.zimkeyWhite,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => HelperDialog.confirmActionDialog(
                                  title: Strings.rescheduleWork,
                                  context: context,
                                  msg: Strings.rescheduleBooking,
                                  btn2Text: Strings.confirmText,
                                  btn1Text: Strings.cancel,
                                  btn2Pressed: () {
                                    BlocProvider.of<AcceptOrDeclineCubit>(
                                            context)
                                        .acceptOrDeclineRequest(
                                            id: getBookingServiceItem.id,
                                            status: true);
                                    Navigator.pop(context);
                                  },
                                  btn1Pressed: () => Navigator.pop(context)),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.zimkeyWhite,
                                  // color: AppColors.buttonColor,
                                  // border: Border.all(
                                  //   color: zimkeyOrange.withOpacity(0.7),
                                  // ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.zimkeyDarkGrey
                                          .withOpacity(0.1),
                                      blurRadius: 5.0, // soften the shadow
                                      spreadRadius: 1.0, //extend the shadow
                                      offset: const Offset(
                                        2.0, // Move to right 10  horizontally
                                        3.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 13),
                                child: const Text(
                                  'Accept',
                                  style: TextStyle(
                                    color: AppColors.zimkeyGreen,
                                    // color: AppColors.zimkeyWhite,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }

  BlocConsumer<CheckoutBloc, CheckoutState> pendingPaymentView(
      GetBookingServiceItem getBookingServiceItem) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, checkoutState) {
        if (checkoutState is CheckoutPaymentUpdatedState) {
          widget.bookingStatusNotifier.value = checkoutState
              .paymentUpdatedResponse.confirmPayment.booking.bookingStatus;
          widget.pendingPaymentNotifier.value = false;
        }
      },
      builder: (context, checkoutState) {
        if (checkoutState is CheckoutLoadingState) {
          return SizedBox(
            width: double.infinity,
            height: 40,
            child: Center(child: HelperWidgets.progressIndicator()),
          );
        } else if (checkoutState is CheckoutErrorState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: Center(
                  child: HelperWidgets.buildText(
                      text:
                          "Oops something went wrong.. \npayment status not updated.. please contact the customer care ..",
                      color: AppColors.zimkeyRed,
                      overflow: TextOverflow.visible)),
            ),
          );
        }
        return BlocConsumer<PendingPaymentCubit, PendingPaymentState>(
          listener: (context, pendingPaymentState) {
            if (pendingPaymentState is PendingPaymentLoadedState) {
              widget.orderIdNotifier.value = pendingPaymentState
                  .paymentResponse.createPendingPaymentOrder.id;
              var razorPayOptions = {
                'key': 'rzp_test_Nrqr7uX5TQY7rL',
                "order_id": pendingPaymentState
                    .paymentResponse.createPendingPaymentOrder.orderId,
                "currency": "INR",
                'amount': (pendingPaymentState
                        .paymentResponse.createPendingPaymentOrder.amount
                        .round()) *
                    100,
                'name':
                    'Zimkey - ${getBookingServiceItem.bookingService.service.name}',
                'retry': {'enabled': true, 'max_count': 1},
                'send_sms_hash': true,
                'prefill': {
                  'contact': getBookingServiceItem.bookingService.booking
                      .bookingAddress.alternatePhoneNumber,
                  'email': ObjectFactory().prefs.getUserData().email
                },
                'external': {
                  'wallets': ['paytm']
                }
              };
              _razorpay.open(razorPayOptions);
            }
          },
          builder: (context, pendingPaymentState) {
            return ValueListenableBuilder(
              valueListenable: widget.pendingPaymentNotifier,
              builder: (BuildContext context, isPaymentPending, Widget? child) {
                return ValueListenableBuilder(
                  valueListenable: widget.addonListNotifier,
                  builder: (BuildContext context, addonList, Widget? child) {
                    return Visibility(
                        visible: addonList.isNotEmpty && isPaymentPending ||
                            isPaymentPending,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0),
                          decoration: BoxDecoration(
                            color: AppColors.zimkeyLightGrey,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                addonList.isEmpty &&
                                        getBookingServiceItem.isPaymentPending
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: HelperWidgets.buildText(
                                            text: "Payment Pending",
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : const SizedBox(),
                                ...List.generate(
                                    addonList.length,
                                    (index) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            addonList[index]
                                                        .additionalHoursAmount !=
                                                    null
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      HelperWidgets.buildText(
                                                          text:
                                                              "Additional Hours",
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Expanded(
                                                            child: Text(
                                                              'Quantity',
                                                              style: TextStyle(
                                                                color: AppColors
                                                                    .zimkeyDarkGrey,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            '${addonList[index].additionalHoursUnits} hrs',
                                                            style:
                                                                const TextStyle(
                                                              color: AppColors
                                                                  .zimkeyDarkGrey,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Expanded(
                                                            child: Text(
                                                              'Total price',
                                                              style: TextStyle(
                                                                color: AppColors
                                                                    .zimkeyDarkGrey,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            '\u20B9 ${addonList[index].additionalHoursAmount!.grandTotal}',
                                                            style:
                                                                const TextStyle(
                                                              color: AppColors
                                                                  .zimkeyDarkGrey,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            HelperWidgets.buildText(
                                                text: "Booking Addons",
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                            const SizedBox(
                                              height: 4,
                                            ),

                                            ...List.generate(
                                                addonList[index]
                                                    .bookingAddons
                                                    .length,
                                                (addOnIndex) =>
                                                    bookingAddonsSection(
                                                        addonList[index]
                                                                .bookingAddons[
                                                            addOnIndex])),
                                            // HelperWidgets.buildText(
                                            //     text: "Booking Addons", fontSize: 14, fontWeight: FontWeight.bold),

                                            const Divider(
                                              thickness: 2,
                                            ),
                                            // const SizedBox(
                                            //   height: 4,
                                            // ),
                                            Row(
                                              children: [
                                                const Expanded(
                                                  child: Text(
                                                    'Grand Total',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .zimkeyDarkGrey,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                Text(
                                                  '\u20B9 ${getBookingServiceItem.amountDue}',
                                                  style: const TextStyle(
                                                      color: AppColors
                                                          .zimkeyDarkGrey,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        )),
                                Row(
                                  children: [
                                    // Expanded(
                                    //   child: Container(),
                                    // ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => pendingPaymentState
                                                is PendingPaymentLoadingState
                                            ? {}
                                            : BlocProvider.of<
                                                        PendingPaymentCubit>(
                                                    context)
                                                .payPendingPayment(
                                                    id: getBookingServiceItem
                                                        .id),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: AppColors.zimkeyBodyOrange,
                                            // color: AppColors.buttonColor,
                                            // border: Border.all(
                                            //   color: zimkeyOrange.withOpacity(0.7),
                                            // ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.zimkeyDarkGrey
                                                    .withOpacity(0.1),
                                                blurRadius:
                                                    5.0, // soften the shadow
                                                spreadRadius:
                                                    1.0, //extend the shadow
                                                offset: const Offset(
                                                  2.0, // Move to right 10  horizontally
                                                  3.0, // Move to bottom 10 Vertically
                                                ),
                                              )
                                            ],
                                          ),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 13),
                                          child: pendingPaymentState
                                                  is PendingPaymentLoadingState
                                              ? SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child: HelperWidgets
                                                      .progressIndicator())
                                              : Text(
                                                  'Complete Payment - \u20B9 ${getBookingServiceItem.amountDue}',
                                                  style: const TextStyle(
                                                    color:
                                                        AppColors.zimkeyOrange,
                                                    // color: AppColors.zimkeyWhite,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                        ));
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget billingOptionSection(String name) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Billing',
            style: TextStyle(
              color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Wrap(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: AppColors.zimkeyDarkGrey.withOpacity(1),
                      // fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  // if (billingQty != null)
                  //   Text(
                  //     ' - $billingQty ${billingUnit.toLowerCase()}(s)',
                  //     style: TextStyle(
                  //       color: AppColors.zimkeyDarkGrey.withOpacity(1),
                  //       // fontWeight: FontWeight.bold,
                  //       fontSize: 12,
                  //     ),
                  //     textAlign: TextAlign.right,
                  //   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildCancellationPolicy(
      BuildContext context, GetBookingServiceItem getBookingServiceItem) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteGenerator.htmlViewerScreen,
            arguments: HtmlViewerScreenArg(
                htmlData: getBookingServiceItem.cancellationPolicyCustomer,
                title: "Cancellation Policy"));
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 5, top: 13),
        child: const Text(
          'Cancellation Policy',
          style: TextStyle(
            color: AppColors.zimkeyOrange,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget commentsSection(String bookingNote) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            'Additional Comments',
            style: TextStyle(
              color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            bookingNote,
            style: const TextStyle(
              color: AppColors.zimkeyDarkGrey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Container buildServiceReqView(GetBookingServiceItem getBookingServiceItem) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          getBookingServiceItem.bookingService.serviceRequirements.isNotEmpty
              ? Text(
                  'Booking',
                  style: TextStyle(
                    color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            height: 7,
          ),
          Wrap(
            children: [
              for (int i = 0;
                  i <
                      getBookingServiceItem
                          .bookingService.serviceRequirements.length;
                  i++)
                Container(
                  margin: const EdgeInsets.only(right: 5, bottom: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                      color: AppColors.zimkeyWhite,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    getBookingServiceItem
                                .bookingService.serviceRequirements[i] ==
                            "Other"
                        ? getBookingServiceItem.bookingService.otherRequirements
                        : '${getBookingServiceItem.bookingService.serviceRequirements[i]}',
                    style: TextStyle(
                      color: AppColors.zimkeyDarkGrey.withOpacity(1.0),
                      fontSize: 13,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          //Booking Notes---------

          getBookingServiceItem.bookingService.booking.bookingNote.isNotEmpty
              ? commentsSection(
                  getBookingServiceItem.bookingService.booking.bookingNote)
              : const SizedBox(),
        ],
      ),
    );
  }

  Container buildAddressView(BookingAddress address) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Service Delivered To',
            style: TextStyle(
              color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.end,
              children: [
                Text(
                  "${ReCase(address.buildingName).originalText}, ",
                  style: TextStyle(
                    color: AppColors.zimkeyDarkGrey.withOpacity(1),
                    // fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "${ReCase(address.landmark).originalText}, ",
                  style: TextStyle(
                    color: AppColors.zimkeyDarkGrey.withOpacity(1.0),
                    // fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "${ReCase(address.area.name).titleCase}, ",
                  style: TextStyle(
                    color: AppColors.zimkeyDarkGrey.withOpacity(1.0),
                    // fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Kochi',
                  style: TextStyle(
                    color: AppColors.zimkeyDarkGrey.withOpacity(1.0),
                    // fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  " - ${ReCase(address.postalCode).titleCase}",
                  style: TextStyle(
                    color: AppColors.zimkeyDarkGrey.withOpacity(1.0),
                    // fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cancellationDetails(CancelDetails cancelDetails) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.zimkeyLightGrey,
        borderRadius: BorderRadius.circular(7),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Cancellation Details',
            style: TextStyle(
              color: AppColors.zimkeyDarkGrey,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Cancellation Charge(Inclusive GST)',
                  style: TextStyle(
                    color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '₹${cancelDetails.cancelAmount}',
                style: const TextStyle(
                  color: AppColors.zimkeyDarkGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 3),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Refund Amount',
                    style: TextStyle(
                      color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  '₹${cancelDetails.cancelTotalAmount}',
                  style: const TextStyle(
                    color: AppColors.zimkeyDarkGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bookingAddonsSection(BookingAddon addons) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.zimkeyWhite.withOpacity(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                addons.name,
                style: TextStyle(
                  color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Quantity',
                  style: TextStyle(
                    color: AppColors.zimkeyDarkGrey,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '${addons.units} unit',
                style: const TextStyle(
                  color: AppColors.zimkeyDarkGrey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total Price',
                  style: TextStyle(
                    color: AppColors.zimkeyDarkGrey,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '₹ ${addons.amount.grandTotal}',
                style: const TextStyle(
                  color: AppColors.zimkeyDarkGrey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 7,
          ),
        ],
      ),
    );
  }

  Widget paymentDetailsSection(
      ChargedPrice chargedPrice, List<AdditionalWork> additionalWorks) {
    return ValueListenableBuilder(
      valueListenable: expandPaymentDetailsNotifier,
      builder: (BuildContext context, bool expandPayment, Widget? child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.zimkeyLightGrey,
            borderRadius: BorderRadius.circular(7),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    expandPaymentDetailsNotifier.value =
                        !expandPaymentDetailsNotifier.value;
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Payment Details',
                      style: TextStyle(
                        color: AppColors.zimkeyDarkGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Icon(
                      expandPayment
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.zimkeyOrange,
                      size: 30,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              if (expandPayment)
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Sub Total',
                              style: TextStyle(
                                color:
                                    AppColors.zimkeyDarkGrey.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            '₹ ${chargedPrice.subTotal.toString()}',
                            style: TextStyle(
                              color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              // decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Discount',
                              style: TextStyle(
                                color:
                                    AppColors.zimkeyDarkGrey.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            '- ₹ ${chargedPrice.totalDiscount.toString()}',
                            style: TextStyle(
                              color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              // decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Total Taxes',
                            style: TextStyle(
                              color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          '₹ ${chargedPrice.totalGstAmount.toString()}',
                          style: TextStyle(
                            color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 10),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Net Price',
                              style: TextStyle(
                                color: AppColors.zimkeyDarkGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            '₹ ${chargedPrice.grandTotal.toString()}',
                            style: TextStyle(
                              color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...List.generate(
                        additionalWorks.length,
                        (index) => additionalWorks[index].isPaid
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Additional work ${index + 1}',
                                    style: const TextStyle(
                                      color: AppColors.zimkeyDarkGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Total price',
                                          style: TextStyle(
                                            color: AppColors.zimkeyDarkGrey
                                                .withOpacity(0.7),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '₹ ${additionalWorks[index].totalAdditionalWorkAmount!.grandTotal.toString()}',
                                        style: TextStyle(
                                          color: AppColors.zimkeyDarkGrey
                                              .withOpacity(0.7),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox())
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
