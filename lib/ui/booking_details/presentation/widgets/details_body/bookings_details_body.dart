import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:recase/recase.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/strings.dart';
import '../../../../../data/model/booking_slot/booking_slots_response.dart';
import '../../../../../data/model/checkout/update_payment/payment_update_request.dart';
import '../../../../../navigation/route_generator.dart';
import '../../../../../utils/buttons/favourite/favourite_button.dart';
import '../../../../../utils/helper/helper_dialog.dart';
import '../../../../../utils/helper/helper_functions.dart';
import '../../../../../utils/helper/helper_widgets.dart';
import '../../../../services/widgets/3_build_payment/bloc/checkout_bloc/checkout_bloc.dart';
import '../../../../success_booking/widgets/bloc/review_bloc.dart';
import '../../../../success_booking/widgets/rating_star.dart';
import '../../../data/bloc/booking_details_bloc.dart';
import '../../../data/cubit/accept_or_decline_cubit/accept_or_decline_cubit.dart';
import '../../../model/single_booking_details_response.dart';
import '../booking_widget_item/booking_wifdget_item.dart';

class DetailsBody extends StatefulWidget {
  const DetailsBody({Key? key}) : super(key: key);

  @override
  State<DetailsBody> createState() => _DetailsBodyState();
}

class _DetailsBodyState extends State<DetailsBody> {
  ValueNotifier<int> starRating = ValueNotifier(-1);
  ValueNotifier<bool> showReviewBottomView = ValueNotifier(false);
  ValueNotifier<bool> showReviewOption = ValueNotifier(false);
  TextEditingController reviewTextController = TextEditingController();

  ValueNotifier<bool> showRescheduleView = ValueNotifier(false);
  ValueNotifier<List<AdditionalWork>> addonListNotifier =
      ValueNotifier(List.empty(growable: true));
  ValueNotifier<bool> pendingPaymentNotifier = ValueNotifier(false);
  ValueNotifier<String> orderIdNotifier = ValueNotifier("");
  ValueNotifier<String> bookingStatusNotifier = ValueNotifier("");
  ValueNotifier<GetServiceBookingSlot> serviceWorkTimeNotifier = ValueNotifier(
      GetServiceBookingSlot(
          start: DateTime.now(), end: DateTime.now(), available: false));
  final screenshotController = ScreenshotController();

  final _razorpay = Razorpay();

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Logger().i(PaymentConfirmGqlInput(
            bookingPaymentId: orderIdNotifier.value,
            paymentId: response.paymentId ?? "",
            signature: response.signature ?? "")
        .toJson());

    BlocProvider.of<CheckoutBloc>(context).add(UpdatePaymentStatus(
        paymentConfirmGqlInput: PaymentConfirmGqlInput(
            bookingPaymentId: orderIdNotifier.value,
            paymentId: response.paymentId ?? "",
            signature: response.signature ?? "")));
  }

  void _handlePaymentError(PaymentFailureResponse response) {}

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    debugPrint('response wallet ....... $response');
  }

  void handleReviewBlocState(ReviewState reviewState) {
    if (reviewState is ReviewAddedState) {
      showReviewOption.value = false;
      HelperWidgets.showTopSnackBar(
          context: context,
          message: "Review Added Successfully",
          isError: false,
          title: "Success",
          icon: const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
          ));
    } else if (reviewState is ReviewErrorState) {
      HelperWidgets.showTopSnackBar(
        context: context,
        message: "Something went wrong",
        isError: true,
        title: "Oops",
      );
    }
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
    return BlocConsumer<ReviewBloc, ReviewState>(
      listener: (context, reviewState) {
        handleReviewBlocState(reviewState);
      },
      builder: (context, reviewState) {
        return BlocConsumer<BookingDetailsBloc, BookingDetailsState>(
          listener: (context, bookingState) {
            if (bookingState is BookingDetailsLoadedState) {
              showReviewOption.value =
                  bookingState.getBookingServiceItem.canRateBooking;
              bookingStatusNotifier.value =
                  bookingState.getBookingServiceItem.bookingServiceItemStatus;
              addonListNotifier.value =
                  bookingState.getBookingServiceItem.additionalWorks;
              pendingPaymentNotifier.value =
                  bookingState.getBookingServiceItem.isPaymentPending;
              serviceWorkTimeNotifier.value = GetServiceBookingSlot(
                  start: bookingState.getBookingServiceItem.startDateTime,
                  end: bookingState.getBookingServiceItem.endDateTime,
                  available: true);
              if (bookingState
                  .getBookingServiceItem.isRescheduleByPartnerPending) {
                showRescheduleView.value = true;
              }
            }
          },
          builder: (context, bookingState) {
            if (bookingState is BookingDetailsLoadedState) {
              return bookingDetailsLoadedView(context, bookingState);
            } else if (bookingState is BookingDetailsLoadingState) {
              return Center(child: HelperWidgets.progressIndicator());
            } else {
              return Container();
            }
          },
        );
      },
    );
  }

  Stack bookingDetailsLoadedView(
      BuildContext context, BookingDetailsLoadedState bookingState) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    bookingServiceName(bookingState),
                    const SizedBox(height: 15),
                    Screenshot(
                        controller: screenshotController,
                        child: BookingDetailsItem(
                          getBookingServiceItem:
                              bookingState.getBookingServiceItem,
                          bookingStatusNotifier: bookingStatusNotifier,
                          serviceWorkTimeNotifier: serviceWorkTimeNotifier,
                          showRescheduleView: showRescheduleView,
                          addonListNotifier: addonListNotifier,
                          orderIdNotifier: orderIdNotifier,
                          pendingPaymentNotifier: pendingPaymentNotifier,
                        )),
                    const SizedBox(height: 25),
                    Column(
                      children: [
                        bookAgain(bookingState),
                        const SizedBox(height: 20),
                        rateExperience(bookingState),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        buildBackDropFilter(),
        buildFirstBookingReview(bookingState.getBookingServiceItem.id),
      ],
    );
  }

  Row bookingServiceName(BookingDetailsLoadedState bookingState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ReCase(bookingState
                        .getBookingServiceItem.bookingService.service.name)
                    .originalText,
                style: const TextStyle(
                  // color: AppColors.zimkeyWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        FavoriteButton(
          serviceId:
              bookingState.getBookingServiceItem.bookingService.service.id,
          isFavourite: bookingState
              .getBookingServiceItem.bookingService.service.isFavorite,
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () => HelperFunctions.takeScreenShot(
              screenshotController, bookingState.getBookingServiceItem.id),
          child: SvgPicture.asset(
            'assets/images/icons/newIcons/share.svg',
            colorFilter: const ColorFilter.mode(
                AppColors.zimkeyDarkGrey, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }

  Widget bookAgain(BookingDetailsLoadedState bookingState) {
    return bookingState.getBookingServiceItem.canBookAgain
        ? InkWell(
            onTap: () => Navigator.pushNamed(
                context, RouteGenerator.serviceDetailsScreen,
                arguments: bookingState
                    .getBookingServiceItem.bookingService.service.id),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              decoration: BoxDecoration(
                color: AppColors.zimkeyBodyOrange,
                // border: Border.all(color: AppColors.zimkeyOrange),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.zimkeyLightGrey.withOpacity(0.1),
                    blurRadius: 4.0, // soften the shadow
                    spreadRadius: 1.0, //extend the shadow
                    offset: const Offset(
                      2.0, // Move to right 10  horizontally
                      2.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              child: const Text(
                'Book Again',
                style: TextStyle(
                  color: AppColors.zimkeyOrange,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget rateExperience(BookingDetailsLoadedState bookingState) {
    return ValueListenableBuilder(
      valueListenable: showReviewOption,
      builder: (BuildContext context, value, Widget? child) {
        return Visibility(
          visible: value,
          child: InkWell(
            onTap: () {
              setState(() {
                // showReviewDialog = true;
                showReviewBottomView.value = true;
              });
            },
            child: const Text(
              'Rate Your Experience',
              style: TextStyle(
                color: AppColors.zimkeyOrange,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  ValueListenableBuilder<bool> buildBackDropFilter() {
    return ValueListenableBuilder(
      valueListenable: showReviewBottomView,
      builder: (BuildContext context, bool value, Widget? child) {
        return Visibility(
          visible: value,
          child: InkWell(
            onTap: () => showReviewBottomView.value = false,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                child: Container(
                  // width: 200.0,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: AppColors.zimkeyDarkGrey.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildFirstBookingReview(String id) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ValueListenableBuilder(
        valueListenable: showReviewBottomView,
        builder: (BuildContext context, bool value, Widget? child) {
          return Visibility(
            visible: value,
            child: Container(
              decoration: const BoxDecoration(
                  color: AppColors.zimkeyWhite,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Service Review',
                            style: TextStyle(
                                color: AppColors.zimkeyDarkGrey.withOpacity(1),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            right: 20,
                          ),
                          alignment: Alignment.centerRight,
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              starRating.value = -1;
                              reviewTextController.clear();
                              showReviewBottomView.value = false;
                            },
                            child: const Icon(
                              Icons.clear,
                              color: AppColors.zimkeyDarkGrey,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: AppColors.zimkeyWhite,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, bottom: 10, top: 10),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            left: 10,
                            right: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Rate your Zimkey booking service',
                              style: TextStyle(
                                color: AppColors.zimkeyDarkGrey.withOpacity(1),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ValueListenableBuilder(
                              valueListenable: starRating,
                              builder: (BuildContext context, int value,
                                  Widget? child) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int i = 0; i < 5; i++)
                                      RatingStar(
                                        index: i,
                                        rating: value,
                                        starHeight: 40,
                                        updateRating: (int newRate) {
                                          starRating.value = newRate;
                                        },
                                      ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.zimkeyLightGrey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: reviewTextController,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      maxLength: 300,
                                      maxLines: 4,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.zimkeyDarkGrey,
                                      ),
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        counterText: "",
                                        hintText: 'Leave a review',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.zimkeyDarkGrey,
                                        ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  if (starRating.value != -1) {
                                    debugPrint(
                                        "star rating :${starRating.value + 1}");
                                    final request = <String, dynamic>{
                                      "type": "BOOKING",
                                      "bookingServiceItemId": id,
                                      "rating": starRating.value + 1,
                                      "review": reviewTextController.text,
                                    };
                                    BlocProvider.of<ReviewBloc>(context).add(
                                        AddFirstBookingReview(
                                            request: request));
                                    showReviewBottomView.value = false;
                                    starRating.value = -1;
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.zimkeyOrange,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width - 250,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: AppColors.zimkeyWhite,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  BlocConsumer<AcceptOrDeclineCubit, AcceptOrDeclineState>
      rescheduleServiceAcceptOrDecline(
          GetBookingServiceItem getBookingServiceItem) {
    return BlocConsumer<AcceptOrDeclineCubit, AcceptOrDeclineState>(
      listener: (context, state) {
        if (state is AcceptOrDeclineSuccessState) {
          showRescheduleView.value = false;
          bookingStatusNotifier.value =
              state.acceptOrDeclineResponse.approveJob.bookingServiceItemStatus;
          serviceWorkTimeNotifier.value = GetServiceBookingSlot(
              start: state.acceptOrDeclineResponse.approveJob.startDateTime,
              end: state.acceptOrDeclineResponse.approveJob.endDateTime,
              available: true);
        }
      },
      builder: (context, state) {
        return ValueListenableBuilder(
          valueListenable: showRescheduleView,
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
}
