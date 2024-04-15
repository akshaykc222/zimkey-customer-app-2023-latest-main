import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/strings.dart';
import '../../../../data/model/address/address_list_response.dart';
import '../../../../data/model/services/single_service_response.dart';
import '../../../../navigation/route_generator.dart';
import '../../../../utils/helper/helper_functions.dart';
import '../../../../utils/helper/helper_widgets.dart';
import '../../../profile/widgets/html_view/html_view_screen.dart';
import '../../cubit/calculate_service_cost_cubit.dart';
import '../../cubit/overview_data_cubit.dart';
import 'bloc/checkout_bloc/checkout_bloc.dart';
import 'bloc/summary_bloc/summary_bloc.dart';
import 'widgets/redeem_point_view.dart';

class BuildPayment extends StatefulWidget {
  final GetService service;
  final void Function({required int pageNo}) goToPage;

  const BuildPayment({Key? key, required this.service, required this.goToPage})
      : super(key: key);

  @override
  State<BuildPayment> createState() => _BuildPaymentState();
}

class _BuildPaymentState extends State<BuildPayment> {
  FocusNode customerNoteNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  TextEditingController customerNoteController = TextEditingController();
  ValueNotifier<String> cancellationPolicyNotifier = ValueNotifier("");

  @override
  void initState() {
    super.initState();
    // customerNoteNode.addListener(_scrollToTextField);

    BlocProvider.of<OverviewDataCubit>(context).fetchAllSelectedValues();
  }

  void _scrollToBottom() {
    if (customerNoteNode.hasFocus) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    customerNoteNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OverviewDataCubit, OverviewDataCubitState>(
      listener: (BuildContext context, OverviewDataCubitState state) {
        if (customerNoteController.text.isEmpty) {
          customerNoteController.text = state.customerNote;
        }
      },
      builder: (context, cubitState) {
        return SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                buildBookingOverViewText(),
                buildCancellationPolicy(cancellationPolicyNotifier),
                const SizedBox(height: 5),
                buildServiceDetails(cubitState),
                buildPaymentDetailsView(),
                const SizedBox(height: 10),
                buildCustomerNote(
                  cubitState,
                  context,
                ),
                const SizedBox(height: 10),
                const RedeemPointView(),
                SizedBox(height: MediaQuery.sizeOf(context).height * .25)
              ],
            ),
          ),
        );
      },
    );
  }

  SizedBox buildBookingOverViewText() {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: HelperWidgets.buildText(
          text: Strings.bookingOverView,
          color: AppColors.zimkeyDarkGrey,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildCancellationPolicy(ValueNotifier<String> notifier) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (BuildContext context, value, Widget? child) {
        return Visibility(
          visible: notifier.value.isNotEmpty,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.htmlViewerScreen,
                  arguments: HtmlViewerScreenArg(
                      htmlData: notifier.value, title: "Cancellation Policy"));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 7, top: 3),
              child: HelperWidgets.buildText(
                text: Strings.cancellationPolicy,
                color: AppColors.zimkeyOrange,
                fontSize: 12,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildServiceDetails(OverviewDataCubitState cubitState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.zimkeyLightGrey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HelperWidgets.buildText(
                  text: widget.service.name,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.zimkeyOrange),
              InkWell(
                onTap: () {
                  widget.goToPage(pageNo: 0);
                  BlocProvider.of<CalculatedServiceCostCubit>(context)
                      .calculateTotalCost(
                          unitPrice: cubitState
                              .selectedBillingOption.first.unitPrice.unitPrice,
                          billingId: cubitState.selectedBillingOption.first.id,
                          minPrice: cubitState.selectedBillingOption.first
                              .unitPrice.partnerPrice,
                          minUnit:
                              cubitState.selectedBillingOption.first.minUnit);

                  BlocProvider.of<CalculatedServiceCostCubit>(context)
                      .changeButtonName(btnName: Strings.book);
                },
                child: HelperWidgets.buildText(
                  text: Strings.edit,
                  color: AppColors.zimkeyOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          //TODO:add selected requirement value notifier
          Container(
            margin: const EdgeInsets.only(
              top: 15,
            ),
            child: Wrap(
              spacing: 3,
              runSpacing: 5,
              children: List.generate(
                cubitState.selectedRequirementList.length,
                (index) => cubitState.selectedRequirementList[index].title !=
                        Strings.other
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 0),
                        decoration: BoxDecoration(
                            color: AppColors.zimkeyWhite,
                            borderRadius: BorderRadius.circular(3)),
                        child: HelperWidgets.buildText(
                          text: cubitState.selectedRequirementList[index].title,
                          color: AppColors.zimkeyDarkGrey,
                          fontSize: 12,
                        ),
                      )
                    : Container(),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    buildSummaryText(
                        text: Strings.dateAndTime, fontSize: 13, bold: true),
                    buildSummaryText(
                        text: buildSelectedTime(cubitState), fontSize: 12),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 15),
                      buildSummaryText(
                          text: Strings.billingOption,
                          fontSize: 13,
                          bold: true),
                      Wrap(
                        children: [
                          buildSummaryText(
                              text: cubitState.selectedBillingOption.first.name,
                              fontSize: 13),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        buildSummaryText(
                            text: Strings.address, fontSize: 13, bold: true),
                        buildSummaryText(
                            text:
                                addressTypeSelected(cubitState.customerAddress),
                            fontSize: 13,
                            bold: true),
                      ],
                    ),
                    Wrap(
                      children: [
                        buildSummaryText(
                            text: cubitState.customerAddress.buildingName,
                            fontSize: 12,
                            comma: true),
                        buildSummaryText(
                            text: cubitState.customerAddress.locality,
                            fontSize: 12,
                            comma: true),
                        buildSummaryText(
                            text: cubitState.customerAddress.landmark,
                            fontSize: 12,
                            comma: true),
                        buildSummaryText(
                            text: cubitState.customerAddress.area.name,
                            fontSize: 12,
                            comma: true),
                        buildSummaryText(
                            text:
                                "${cubitState.customerAddress.postalCode} - ${Strings.kochi}",
                            fontSize: 12),
                      ],
                    ),
                  ],
                ),
              ),
              //phone no.
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildSummaryText(
                      text: Strings.bookingPhoneNum, fontSize: 13, bold: true),
                  buildSummaryText(text: cubitState.mobileNum, fontSize: 13),
                ],
              ),
            ],
          ),
          cubitState.otherRequirementText.isNotEmpty
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.zimkeyWhite,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSummaryText(
                            text: Strings.otherRequirement,
                            fontSize: 13,
                            bold: true),
                        buildSummaryText(
                            text: ReCase(cubitState.otherRequirementText)
                                .sentenceCase,
                            fontSize: 12),
                      ]),
                )
              : Container(),
        ],
      ),
    );
  }

  BlocConsumer<SummaryBloc, SummaryState> buildPaymentDetailsView() {
    return BlocConsumer<SummaryBloc, SummaryState>(
      listener: (context, state) {
        if (state is SummaryLoadedState) {
          BlocProvider.of<CalculatedServiceCostCubit>(context).setTotalCost(
              totalCost: state.bookingSummary.grandTotal.round().toString());
          BlocProvider.of<CalculatedServiceCostCubit>(context)
              .setCouponList(couponList: state.bookingSummary.coupons);

          cancellationPolicyNotifier.value =
              state.bookingSummary.cancellationPolicyCustomer;
        }
      },
      builder: (context, state) {
        if (state is SummaryLoadedState) {
          return Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.zimkeyLightGrey,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSummaryText(
                    text: Strings.paymentDetails, fontSize: 13, bold: true),
                const SizedBox(height: 3),
                buildPaymentRow(
                    title: Strings.subTotal,
                    subText: "\u20B9 ${state.bookingSummary.subTotal.round()}"),
                const SizedBox(height: 3),
                buildPaymentRow(
                    title: Strings.discount,
                    subText:
                        "- \u20B9 ${state.bookingSummary.totalDiscount.round()}"),
                const SizedBox(height: 3),
                buildPaymentRow(
                    title: Strings.totalTax,
                    subText:
                        "\u20B9 ${state.bookingSummary.totalGstAmount.round()}"),
                const SizedBox(height: 3),
                buildPaymentRow(
                    title: Strings.total,
                    subText:
                        "\u20B9 ${state.bookingSummary.grandTotal.round()}"),
                const SizedBox(height: 3),
              ],
            ),
          );
        } else if (state is CheckoutLoadingState) {
          return Center(child: HelperWidgets.progressIndicator());
        }
        return Container();
      },
    );
  }

  Row buildPaymentRow({required String title, required String subText}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: buildSummaryText(text: title, fontSize: 13, bold: true),
        ),
        buildSummaryText(text: subText, fontSize: 13)
      ],
    );
  }

  Widget buildSummaryText(
      {required String text,
      required double fontSize,
      bool comma = false,
      bool bold = false}) {
    return HelperWidgets.buildText(
        text: '${ReCase(text).originalText}${comma ? ", " : ""}',
        fontSize: fontSize,
        color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
        fontWeight: bold ? FontWeight.bold : FontWeight.normal);
  }

  String addressTypeSelected(CustomerAddress value) {
    // return ' - ${value.addressType != "OTHER" ? value.addressType : value.otherText}';
    return ' - ${value.addressType}';
  }

  String buildSelectedTime(OverviewDataCubitState cubitState) {
    return '${cubitState.selectedDay.day.toString().padLeft(2, '0')}-${cubitState.selectedMonth.substring(0, 3)}-${cubitState.selectedDay.year} | ${HelperFunctions.filterTimeSlot(cubitState.selectedSlotTiming)}';
  }

  Widget buildCustomerNote(
      OverviewDataCubitState cubitState, BuildContext context,
      {Function? onTap}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.zimkeyLightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: HelperWidgets.buildTextField(
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 100.0),
                  maxLines: 4,
                  inputFormatters: [LengthLimitingTextInputFormatter(200)],
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  onTap: onTap == null ? null : onTap(),
                  onChanged: (val) {
                    BlocProvider.of<OverviewDataCubit>(context)
                        .addCustomerNote(val);
                    _scrollToBottom();
                  },
                  controller: customerNoteController,
                  hintText: Strings.customerNote,
                  focusNode: customerNoteNode)),
          const SizedBox(
            width: 10,
          ),
          // if (filledOther)
          InkWell(
            onTap: () {
              BlocProvider.of<OverviewDataCubit>(context).addCustomerNote("");
              customerNoteController.clear();
            },
            child: const Icon(
              Icons.clear,
              color: AppColors.zimkeyDarkGrey,
              size: 16,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
