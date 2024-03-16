import 'package:customer/ui/services/widgets/1_build_option/build_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../constants/assets.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/strings.dart';
import '../../../../data/model/checkout/booking_gql_input.dart';
import '../../../../data/model/checkout/update_payment/payment_update_request.dart';
import '../../../../navigation/route_generator.dart';
import '../../../../utils/buttons/animated_button.dart';
import '../../../../utils/helper/helper_dialog.dart';
import '../../../../utils/helper/helper_functions.dart';
import '../../../../utils/helper/helper_widgets.dart';
import '../../../../utils/object_factory.dart';
import '../../cubit/calculate_service_cost_cubit.dart';
import '../../cubit/overview_data_cubit.dart';
import '../3_build_payment/bloc/checkout_bloc/checkout_bloc.dart';
import '../3_build_payment/bloc/summary_bloc/summary_bloc.dart';
import '../3_build_payment/widgets/listing_coupon_codes.dart';

class TotalAndButtonView extends StatefulWidget {
  final Function({required int pageNo}) goToPage;

  const TotalAndButtonView({Key? key, required this.goToPage})
      : super(key: key);

  @override
  State<TotalAndButtonView> createState() => _TotalAndButtonViewState();
}

class _TotalAndButtonViewState extends State<TotalAndButtonView> {
  final _razorpay = Razorpay();
  ValueNotifier<String> orderIdNotifier = ValueNotifier("");
  ValueNotifier<String> bookingIdNotifier = ValueNotifier("");
  ValueNotifier<String> mobNumNotifier = ValueNotifier("");

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // await confirmPaymentMutation(response);
    debugPrint('response success ....... $response');

    Navigator.pushNamedAndRemoveUntil(
        context, RouteGenerator.bookingSuccessScreen, (route) => false,
        arguments: PaymentConfirmGqlInput(
            bookingPaymentId: orderIdNotifier.value,
            paymentId: response.paymentId ?? "",
            signature: response.signature ?? ""));
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    // Logger().e(response);
    // // await confirmPaymentMutation(response);
    Navigator.pushReplacementNamed(
        context, RouteGenerator.singleBookingDetailScreen,
        arguments: BookingDetailScreenArg(
          id: bookingIdNotifier.value,
          fromPaymentPending: true,
        ));
  }

  Future<void> _handleExternalWallet(ExternalWalletResponse response) async {
    // await confirmPaymentMutation(response);
    debugPrint('response ext wallet ....... $response');
  }

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummaryBloc, SummaryState>(
      builder: (context, summaryState) {
        return BlocConsumer<CheckoutBloc, CheckoutState>(
          listener: (context, checkoutState) {
            if (checkoutState is CheckoutBookingCreatedState) {
              var mobNum = mobNumNotifier.value.isNotEmpty
                  ? mobNumNotifier.value
                  : ObjectFactory().prefs.getUserData().phone;
              orderIdNotifier.value =
                  checkoutState.createBooking.bookingPayments.first.id;
              bookingIdNotifier.value = checkoutState
                  .createBooking.bookingService.bookingServiceItems.first.id;
              // orderIdNotifier.value = checkoutState.createBooking.bookingService;
              Logger().i(
                  "payment id:${checkoutState.createBooking.bookingPayments.first.id}");
              Logger().i("booking id:${checkoutState.createBooking.id}");
              var razorPayOptions = {
                'key': 'rzp_test_Nrqr7uX5TQY7rL',
                "order_id":
                    checkoutState.createBooking.bookingPayments.first.orderId,
                "currency": "INR",
                'amount': (checkoutState.createBooking.bookingAmount.grandTotal
                        .round()) *
                    100,
                'name':
                    'Zimkey - ${checkoutState.createBooking.bookingService.service.name}',
                'retry': {'enabled': true, 'max_count': 1},
                'send_sms_hash': true,
                'prefill': {
                  'contact': mobNum,
                  'email': ObjectFactory().prefs.getUserData().email
                },
                'external': {
                  'wallets': ['paytm']
                }
              };
              _razorpay.open(razorPayOptions);
            } else if (checkoutState is CheckoutPaymentUpdatedState) {
              HelperFunctions.navigateToHome(context);
            }
          },
          builder: (context, checkoutState) {
            return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BlocBuilder<CalculatedServiceCostCubit,
                    ServiceCostCalculated>(
                  builder: (context, cubitCalcState) {
                    if (cubitCalcState.showCouponListingScreen) {
                      return SizedBox(
                        height: MediaQuery.sizeOf(context).height,
                        width: MediaQuery.sizeOf(context).width,
                        child: CouponListingScreen(
                          couponList: cubitCalcState.couponList,
                          selectedUnit: cubitCalcState.selectedUnit,
                          selectedBillingId: cubitCalcState.selectedBillingId,
                        ),
                      );
                    } else {
                      return Container(
                        color: AppColors.zimkeyGrey,
                        child: BlocBuilder<OverviewDataCubit,
                            OverviewDataCubitState>(
                          builder: (context, overViewCubitState) {
                            mobNumNotifier.value = overViewCubitState.mobileNum;
                            return Visibility(
                              visible: summaryState is! SummaryLoadingState,
                              replacement: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Center(
                                            child: HelperWidgets
                                                .progressIndicator())),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    HelperWidgets.buildText(
                                        text: Strings.pleaseWait)
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (summaryState is SummaryLoadedState)
                                    Visibility(
                                      visible: cubitCalcState.btnName ==
                                          Strings.makePayment,
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.white,
                                        ),
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        margin: const EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: SvgPicture.asset(
                                                Assets.iconCoupon,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                        AppColors.zimkeyOrange,
                                                        BlendMode.srcIn),
                                                width: 20,
                                              ),
                                            ),
                                            Expanded(
                                                flex: 3,
                                                child: InkWell(
                                                  onTap: () {
                                                    if (summaryState
                                                        .bookingSummary
                                                        .isZpointsApplied) {
                                                      HelperWidgets.showTopSnackBar(
                                                          context: context,
                                                          message:
                                                              "Please remove Redeemed points to use this feature !!",
                                                          isError: true,
                                                          title: "Oops..");
                                                    } else {
                                                      BlocProvider.of<
                                                                  CalculatedServiceCostCubit>(
                                                              context)
                                                          .showCouponListingScreen(
                                                              show: true);
                                                    }
                                                  },
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 20),
                                                      // color: Colors.red,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: HelperWidgets.buildText(
                                                              text: summaryState
                                                                      .bookingSummary
                                                                      .isCouponApplied
                                                                  ? "${summaryState.bookingSummary.appliedCoupon} ${Strings.couponApplied}"
                                                                  : Strings
                                                                      .chooseCoupon))),
                                                )),
                                            summaryState.bookingSummary
                                                    .isCouponApplied
                                                ? Expanded(
                                                    flex: 1,
                                                    child: InkWell(
                                                        onTap: () => HelperDialog
                                                            .confirmActionDialog(
                                                                title:
                                                                    "Remove Coupon",
                                                                msg:
                                                                    "Do you really want to remove coupon",
                                                                context:
                                                                    context,
                                                                btn1Text:
                                                                    "Cancel",
                                                                btn2Text:
                                                                    "Remove",
                                                                btn1Pressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                btn2Pressed:
                                                                    () {
                                                                  BlocProvider.of<SummaryBloc>(context).add(LoadCheckoutSummary(
                                                                      serviceBillingOptionId:
                                                                          cubitCalcState
                                                                              .selectedBillingId,
                                                                      units: cubitCalcState
                                                                          .selectedUnit));
                                                                  Navigator.pop(
                                                                      context);
                                                                }),
                                                        child: SizedBox(
                                                            child: Center(
                                                                child: HelperWidgets.buildText(
                                                                    text:
                                                                        "Remove",
                                                                    color: AppColors
                                                                        .zimkeyOrange)))))
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 20,
                                        left: 20,
                                        right: 20,
                                        top: 15),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Wrap(
                                            children: [
                                              HelperWidgets.buildText(
                                                text:
                                                    "₹${cubitCalcState.totalCost}",
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              HelperWidgets.buildText(
                                                text: cubitCalcState
                                                        .rewardPoint.isNotEmpty
                                                    ? ' (${cubitCalcState.rewardPoint} Points)'
                                                    : "",
                                                fontSize: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                        AnimatedButton(
                                          onTap: () {
                                            print("this is working");
                                            if (checkoutState
                                                    is! CheckoutLoadingState &&
                                                acceptTerms.value) {
                                              buttonHandler(
                                                  cubicCalcState:
                                                      cubitCalcState,
                                                  context: context,
                                                  overviewDataCubitState:
                                                      overViewCubitState,
                                                  summaryState: summaryState);
                                            } else if (acceptTerms.value ==
                                                false) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: const Text(
                                                    "Please accept the terms and condition to proceed"),
                                                action: SnackBarAction(
                                                    label: "Accept",
                                                    textColor:
                                                        AppColors.zimkeyOrange,
                                                    onPressed: () {
                                                      acceptTerms.value = true;
                                                      acceptTerms
                                                          .notifyListeners();
                                                    }),
                                              ));
                                            }
                                          },
                                          btnName: cubitCalcState.btnName,
                                          isEnabled: true,
                                          isLoading: checkoutState
                                              is CheckoutLoadingState,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ));
          },
        );
      },
    );
  }

  buttonHandler(
      {required ServiceCostCalculated cubicCalcState,
      required BuildContext context,
      required OverviewDataCubitState overviewDataCubitState,
      required SummaryState summaryState}) {
    HelperFunctions.hideKeyboard();
    switch (cubicCalcState.btnName) {
      case Strings.book:
        checkForBillingOptionPage(cubicCalcState, context);
        break;
      case Strings.next:
        checkForSchedulePage(
            cubitCalcState: cubicCalcState,
            context: context,
            overviewDataCubitState: overviewDataCubitState);
        break;
      case Strings.makePayment:
        checkForPaymentPage(
            overviewDataCubitState: overviewDataCubitState,
            cubitCalcState: cubicCalcState,
            context: context,
            summaryState: summaryState);
        break;
      // Add more cases as needed
      default:
        // Handle default case if needed
        break;
    }
  }

  void checkForBillingOptionPage(
      ServiceCostCalculated state, BuildContext context) {
    if (state.selectedBillingId.isNotEmpty) {
      widget.goToPage(pageNo: 1);
      BlocProvider.of<CalculatedServiceCostCubit>(context)
          .changeButtonName(btnName: Strings.next);
    } else {
      HelperWidgets.showTopSnackBar(
          context: context,
          title: "Oops",
          message: "Billing option not selected",
          isError: true);
    }
  }

  void checkForSchedulePage(
      {required ServiceCostCalculated cubitCalcState,
      required BuildContext context,
      required OverviewDataCubitState overviewDataCubitState}) {
    if (overviewDataCubitState.selectedSlotTiming.available &&
        overviewDataCubitState.customerAddress.id.isNotEmpty) {
      widget.goToPage(pageNo: 2);
      BlocProvider.of<CalculatedServiceCostCubit>(context)
          .changeButtonName(btnName: Strings.makePayment);
      BlocProvider.of<SummaryBloc>(context).add(LoadCheckoutSummary(
          serviceBillingOptionId: cubitCalcState.selectedBillingId,
          units: cubitCalcState.selectedUnit));
    } else if (!overviewDataCubitState.selectedSlotTiming.available) {
      HelperWidgets.showTopSnackBar(
          context: context,
          title: "Oops",
          message: "Please select Time slot to continue",
          icon: const Icon(
            Icons.error,
            color: Colors.red,
            size: 28,
          ),
          isError: false);
    } else if (overviewDataCubitState.customerAddress.id.isEmpty) {
      try {
        var user = HelperFunctions.user();
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Please login to continue"),
            action: SnackBarAction(
                label: "Login",
                onPressed: () {
                  HelperFunctions.navigateToLogin(context);
                }),
          ));
        } else {
          HelperWidgets.showTopSnackBar(
              context: context,
              title: "Oops",
              message: "Please select Address to continue",
              icon: const Icon(
                Icons.error,
                color: Colors.red,
                size: 28,
              ),
              isError: false);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Please login to continue"),
          action: SnackBarAction(
              label: "Login",
              onPressed: () {
                HelperFunctions.setupInitialNavigation(context);
              }),
        ));
      }
    }
  }

  //Todo: need to implement message in booking page
  void checkForPaymentPage(
      {required ServiceCostCalculated cubitCalcState,
      required BuildContext context,
      required OverviewDataCubitState overviewDataCubitState,
      required SummaryState summaryState}) {
    BlocProvider.of<CheckoutBloc>(context).add(CreateBookingEvent(
        bookingGqlInput: BookingGqlInput(
            addressId: overviewDataCubitState.customerAddress.id,
            message: overviewDataCubitState.customerNote,
            service: Service(
                servicePropertyAreaId: overviewDataCubitState.propertyArea?.id,
                servicePropertyTypeId: overviewDataCubitState.propertyType?.id,
                serviceRoomId: overviewDataCubitState.room?.id,
                isFurnished: overviewDataCubitState.furnished,
                serviceBillingOptionId: cubitCalcState.selectedBillingId,
                units: cubitCalcState.selectedUnit,
                serviceRequirementIds: HelperFunctions.fetchReqIdList(
                    overviewDataCubitState.selectedRequirementList),
                otherRequirements: overviewDataCubitState.otherRequirementText,
                startDateTime: overviewDataCubitState.selectedSlotTiming.start,
                endDateTime: overviewDataCubitState.selectedSlotTiming.end),
            alternatePhoneNumber: overviewDataCubitState.mobileNum,
            redeemPoints: summaryState is SummaryLoadedState
                ? summaryState.bookingSummary.isZpointsApplied
                    ? summaryState.bookingSummary.appliedZpoints
                    : 0
                : 0,
            couponCode: summaryState is SummaryLoadedState
                ? summaryState.bookingSummary.isCouponApplied
                    ? summaryState.bookingSummary.appliedCoupon
                    : ""
                : "")));
  }
}
