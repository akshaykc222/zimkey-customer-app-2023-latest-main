import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:recase/recase.dart';
import 'package:screenshot/screenshot.dart';


import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../data/model/booking_slot/booking_slots_response.dart';
import '../../data/model/checkout/update_payment/payment_update_request.dart';
import '../../data/model/checkout/update_payment/payment_updated_response.dart';
import '../../data/provider/review_provider.dart';
import '../../navigation/route_generator.dart';
import '../../utils/buttons/favourite/favourite_button.dart';
import '../../utils/helper/helper_functions.dart';
import '../../utils/helper/helper_widgets.dart';
import '../../utils/object_factory.dart';
import '../home/widgets/popular_services.dart';
import '../services/widgets/3_build_payment/bloc/checkout_bloc/checkout_bloc.dart';
import 'widgets/bloc/review_bloc.dart';
import 'widgets/rating_star.dart';

class BookingSuccessScreen extends StatefulWidget {
  final PaymentConfirmGqlInput paymentConfirmGqlInput;

  const BookingSuccessScreen({Key? key, required this.paymentConfirmGqlInput}) : super(key: key);

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> {
  ValueNotifier<int> starRating = ValueNotifier(-1);
  ValueNotifier<bool> showReviewBottomView = ValueNotifier(false);
  TextEditingController reviewTextController = TextEditingController();
  final screenshotController = ScreenshotController();


  @override
  void initState() {
    super.initState();
    Logger().i(widget.paymentConfirmGqlInput.toJson());
    BlocProvider.of<CheckoutBloc>(context)
        .add(UpdatePaymentStatus(paymentConfirmGqlInput: widget.paymentConfirmGqlInput));
  }

  List<String> projectStages = [
    'CREATED',
    'ASSIGNED',
    'IN_PROGRESS',
    'COMPLETED',
    // 'CANCELED',
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
        create: (context) => ReviewBloc(reviewProvider: RepositoryProvider.of<ReviewProvider>(context)),
        child: BlocConsumer<ReviewBloc, ReviewState>(
          listener: (context, reviewState) {
            handleReviewBlocState(reviewState);
          },
          builder: (context, reviewState) {
            return BlocConsumer<CheckoutBloc, CheckoutState>(
              listener: (context, checkoutState) {
                handleCheckoutBlocState(checkoutState);
              },
              builder: (context, state) {
                if (state is CheckoutLoadingState) {
                  return buildProgressIndicator();
                } else if (state is CheckoutPaymentUpdatedState) {
                  var checkoutState = state.paymentUpdatedResponse.confirmPayment;
                  var booking = state.paymentUpdatedResponse.confirmPayment.booking;
                  return Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: buildSuccessScreenAppBar(context),
                    body: Stack(
                      children: [
                        Screenshot(
                            controller: screenshotController,
                            child: buildSuccessScreenBody(context, checkoutState, booking, state)),
                        buildBackDropFilter(),
                        buildFirstBookingReview(checkoutState)
                      ],
                    ),
                  );
                }
                // else if (state is CheckoutErrorState) {
                //   return buildErrorView(context, state);
                // }
                else {
                  return const Scaffold();
                }
              },
            );
          },
        ),
      ),
    );
  }

  Scaffold buildProgressIndicator() {
    return Scaffold(
        body: SizedBox(
      child: Center(
        child: HelperWidgets.progressIndicator(),
      ),
    ));
  }

  Scaffold buildErrorView(BuildContext context, CheckoutErrorState state) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HelperWidgets.buildText(text: "signature: ${widget.paymentConfirmGqlInput.signature}", overflow: null),
            HelperWidgets.buildText(text: "paymentID: ${widget.paymentConfirmGqlInput.paymentId}", overflow: null),
            Container(
              child: HelperWidgets.buildText(
                  text: "bookingPaymentId: ${widget.paymentConfirmGqlInput.bookingPaymentId}", overflow: null),
            ),
            InkWell(
              onTap: () => HelperFunctions.navigateToHome(context),
              child: SizedBox(
                height: 40,
                child: HelperWidgets.buildText(
                  text: "Navigate to Home",
                ),
              ),
            ),
            Expanded(
                child: ListView(
              children: [Container(child: HelperWidgets.buildText(text: "${state.error}", overflow: null))],
            ))
          ],
        ),
      ),
    );
  }

  Positioned buildFirstBookingReview(ConfirmPayment checkoutState) {
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
                  borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  const SizedBox(
                    height: 7,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: AppColors.zimkeyWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    padding: const EdgeInsets.only(left: 5, right: 5, bottom: 20, top: 20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 10, right: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Rate your Zimkey booking experience',
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
                              builder: (BuildContext context, int value, Widget? child) {
                                return Row(
                                  children: [
                                    for (int i = 0; i < 5; i++)
                                      RatingStar(
                                        index: i,
                                        rating: value,
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
                                      textCapitalization: TextCapitalization.sentences,
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
                            Center(
                              child: InkWell(
                                onTap: () {
                                  if (starRating.value != -1) {
                                    final request = <String, dynamic>{
                                      "type": "FIRST_BOOKING",
                                      "bookingServiceItemId":
                                          checkoutState.booking.bookingService.bookingServiceItems.first.id,
                                      "rating": starRating.value,
                                      "review": reviewTextController.text,
                                    };
                                    BlocProvider.of<ReviewBloc>(context).add(AddFirstBookingReview(request: request));
                                    showReviewBottomView.value = false;
                                    starRating.value = -1;
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.zimkeyOrange,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  width: MediaQuery.of(context).size.width - 250,
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

  Container buildSuccessScreenBody(
      BuildContext context, ConfirmPayment checkoutState, Booking booking, CheckoutPaymentUpdatedState state) {
    return Container(
      color: AppColors.zimkeyWhite,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                'Your booking is successful!',
                style: TextStyle(color: AppColors.zimkeyOrange, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              color: AppColors.zimkeyLightGrey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          checkoutState.booking.bookingService.service.name,
                          style: const TextStyle(
                            color: AppColors.zimkeyOrange,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          FavoriteButton(serviceId: booking.bookingService.service.id,isFavourite:booking.bookingService.service.isFavorite,),
                          const SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap:()=> HelperFunctions.takeScreenShot(screenshotController,booking.id),
                            child: SvgPicture.asset(
                              'assets/images/icons/newIcons/share.svg',
                              colorFilter: const ColorFilter.mode(AppColors.zimkeyDarkGrey, BlendMode.srcIn),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Booking ID',
                            style: TextStyle(
                              color: AppColors.zimkeyDarkGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            booking.userBookingNumber,
                            style: const TextStyle(
                              color: AppColors.zimkeyDarkGrey,
                              fontSize: 13,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: booking.bookingService.serviceRequirements.isNotEmpty,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Service Details',
                            style: TextStyle(
                              color: AppColors.zimkeyDarkGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Wrap(
                              children: List.generate(
                                  booking.bookingService.serviceRequirements.length,
                                  (index) => Container(
                                        margin: const EdgeInsets.only(right: 5, bottom: 5),
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: AppColors.zimkeyWhite, borderRadius: BorderRadius.circular(5)),
                                        child: Text(
                                          ReCase(booking.bookingService.serviceRequirements[index]).titleCase,
                                          style: const TextStyle(
                                            color: AppColors.zimkeyDarkGrey,
                                            fontSize: 13,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ))),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < projectStages.length; i++)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: i == 0 ? AppColors.zimkeyOrange : AppColors.zimkeyDarkGrey.withOpacity(0.7),
                                size: 18,
                              ),
                              AutoSizeText(
                                ' ${ReCase(projectStages[i]).titleCase} ',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: i == 0 ? AppColors.zimkeyOrange : AppColors.zimkeyDarkGrey.withOpacity(0.7),
                                ),
                                maxFontSize: 12,
                                minFontSize: 9,
                              ),
                              if (i < projectStages.length - 1)
                                Container(
                                  color: i == 0 ? AppColors.zimkeyOrange : AppColors.zimkeyDarkGrey2,
                                  height: 1.5,
                                  width: 18,
                                  constraints: const BoxConstraints(maxWidth: 40, minWidth: 2),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              color: AppColors.zimkeyLightGrey,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //mobile no. and email---------
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Wrap(
                        children: [
                          Text(
                            'Contact Details',
                            style: TextStyle(
                              color: AppColors.zimkeyDarkGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Wrap(
                        children: [
                          Text(
                            booking.bookingAddress.alternatePhoneNumber,
                            style: const TextStyle(
                              color: AppColors.zimkeyDarkGrey,
                              fontSize: 13,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' | ${ObjectFactory().prefs.getUserData().email}',
                            style: const TextStyle(
                              color: AppColors.zimkeyDarkGrey,
                              fontSize: 13,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Address',
                              style: TextStyle(
                                color: AppColors.zimkeyDarkGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              booking.bookingAddress.addressType,
                              style: const TextStyle(
                                color: AppColors.zimkeyDarkGrey,
                                fontSize: 13,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            Wrap(
                              children: [
                                Text(
                                  '${ReCase(booking.bookingAddress.buildingName).originalText}, ',
                                  style: const TextStyle(
                                    color: AppColors.zimkeyDarkGrey,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  ReCase(booking.bookingAddress.landmark).originalText,
                                  style: const TextStyle(
                                    color: AppColors.zimkeyDarkGrey,
                                    fontSize: 13,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              children: [
                                Text(
                                  '${ReCase(booking.bookingAddress.area.name).titleCase}, ',
                                  style: const TextStyle(
                                    color: AppColors.zimkeyDarkGrey,
                                    fontSize: 13,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  booking.bookingAddress.postalCode,
                                  style: const TextStyle(
                                    color: AppColors.zimkeyDarkGrey,
                                    fontSize: 13,
                                  ),
                                ),
                                const Text(
                                  '- Kochi',
                                  style: TextStyle(
                                    color: AppColors.zimkeyDarkGrey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   height: 15,
                            // ),
                          ],
                        ),
                      ),
                      //date time slot
                      buildDateAndTimeSlot(booking.bookingService.bookingServiceItems.first),
                    ],
                  ),
                  //payment details------
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Payment Details',
                        style: TextStyle(
                          color: AppColors.zimkeyDarkGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      // for (BookingPayment paymntItem
                      //     in booking.bookingPayments)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Sub total',
                                    style: TextStyle(
                                      color: AppColors.zimkeyDarkGrey,
                                      fontSize: 13,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '₹${booking.bookingAmount.subTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: AppColors.zimkeyDarkGrey,
                                    fontSize: 13,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Discount',
                                  style: TextStyle(
                                    color: AppColors.zimkeyDarkGrey,
                                    fontSize: 13,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '- ₹${booking.bookingAmount.totalDiscount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.zimkeyDarkGrey,
                                  fontSize: 13,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  Strings.totalTax,
                                  style: TextStyle(
                                    color: AppColors.zimkeyDarkGrey,
                                    fontSize: 13,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '₹${booking.bookingAmount.totalGstAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.zimkeyDarkGrey,
                                  fontSize: 13,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Total',
                                  style: TextStyle(
                                    color: AppColors.zimkeyDarkGrey,
                                    fontSize: 13,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '₹${booking.bookingAmount.grandTotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.zimkeyDarkGrey,
                                  fontSize: 13,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: AppColors.zimkeyBodyOrange, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'This task will fetch you ',
                    style: TextStyle(
                      color: AppColors.zimkeyDarkGrey,
                    ),
                  ),
                  Text(
                    'rewardEarned',
                    style: TextStyle(
                      color: AppColors.zimkeyOrange,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Zimkey points',
                    style: TextStyle(
                      color: AppColors.zimkeyDarkGrey,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '*T&C Applied',
                    style: TextStyle(
                      color: AppColors.zimkeyOrange,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  const Text(
                    'To ',
                    style: TextStyle(
                      color: AppColors.zimkeyDarkGrey,
                      fontSize: 13,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   PageTransition(
                      //     type: PageTransitionType.bottomToTop,
                      //     child: Dashboard(
                      //       currentIndex: 2,
                      //     ),
                      //     duration: const Duration(milliseconds: 300),
                      //   ),
                      // );
                    },
                    child: const Text(
                      'reschedule ',
                      style: TextStyle(
                        color: AppColors.zimkeyOrange,
                        fontSize: 13,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    'or ',
                    style: TextStyle(
                      color: AppColors.zimkeyDarkGrey,
                      fontSize: 13,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   PageTransition(
                      //     type: PageTransitionType.bottomToTop,
                      //     child: Dashboard(
                      //       currentIndex: 2,
                      //     ),
                      //     duration: const Duration(milliseconds: 300),
                      //   ),
                      // );
                    },
                    child: const Text(
                      'cancel ',
                      style: TextStyle(
                        color: AppColors.zimkeyOrange,
                        fontSize: 13,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    'the booking, visit ',
                    style: TextStyle(
                      color: AppColors.zimkeyDarkGrey,
                      fontSize: 13,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () => HelperFunctions.navigateToBookings(context),
                    child: const Text(
                      'Bookings ',
                      style: TextStyle(
                        color: AppColors.zimkeyOrange,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    'page.',
                    style: TextStyle(
                      color: AppColors.zimkeyDarkGrey,
                      fontSize: 13,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            //footer
            const SizedBox(
              height: 15,
            ),

            PopularService(popularService: state.paymentUpdatedResponse.confirmPayment.getPopularServices!),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildSuccessScreenAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.zimkeyOrange,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              HelperFunctions.navigateToHome(context);
            },
            child: const Icon(
              Icons.clear,
              color: AppColors.zimkeyWhite,
              size: 22,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Booking Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.zimkeyWhite,
                  )),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.faqScreen);
            },
            child: SvgPicture.asset(
              'assets/images/icons/question.svg',
              color: AppColors.zimkeyBgWhite,
              height: 20,
            ),
          ),
        ],
      ),
    );
  }

  Column buildDateAndTimeSlot(BookingServiceItem serviceItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date & Time',
          style: TextStyle(
            color: AppColors.zimkeyDarkGrey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          '${serviceItem.startDateTime.day}-${serviceItem.startDateTime.month}-${serviceItem.startDateTime.year} | ${HelperFunctions.filterTimeSlot(GetServiceBookingSlot(start: serviceItem.startDateTime, end: serviceItem.endDateTime, available: false))}',
          style: const TextStyle(
            color: AppColors.zimkeyDarkGrey,
            fontSize: 13,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void handleReviewBlocState(ReviewState reviewState) {
    if (reviewState is ReviewAddedState) {
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

  void handleCheckoutBlocState(CheckoutState checkoutState) {
    if (checkoutState is CheckoutPaymentUpdatedState) {
      showReviewBottomView.value = true;
    }
    // else if (checkoutState is CheckoutErrorState) {
    //   HelperFunctions.navigateToHome(context);
    // }
  }
}
