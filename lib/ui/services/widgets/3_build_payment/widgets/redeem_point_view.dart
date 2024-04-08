import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/strings.dart';
import '../../../../../utils/helper/helper_dialog.dart';
import '../../../../../utils/helper/helper_widgets.dart';
import '../../../cubit/calculate_service_cost_cubit.dart';
import '../../../cubit/overview_data_cubit.dart';
import '../bloc/summary_bloc/summary_bloc.dart';

class RedeemPointView extends StatefulWidget {
  const RedeemPointView({
    Key? key,
  }) : super(key: key);

  @override
  State<RedeemPointView> createState() => _RedeemPointViewState();
}

class _RedeemPointViewState extends State<RedeemPointView> {
  ValueNotifier<bool> showRedeemTextField = ValueNotifier(false);
  ValueNotifier<bool> enableRedeemPointSubmitButton = ValueNotifier(false);
  FocusNode redeemPointNode = FocusNode();
  TextEditingController redeemPointTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SummaryBloc, SummaryState>(
      listener: (context, summaryState) {
        if (summaryState is SummaryLoadedState) {
          if (summaryState.bookingSummary.redeemError) {
            HelperWidgets.showTopSnackBar(
                context: context,
                message: summaryState.bookingSummary.message,
                isError: true,
                title: "Oops..");
            redeemPointTextEditingController.clear();
          }
        }
      },
      builder: (context, summaryState) {
        return BlocBuilder<CalculatedServiceCostCubit, ServiceCostCalculated>(
          builder: (context, cubitState) {
            if (summaryState is SummaryLoadedState) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HelperWidgets.buildText(
                              text: Strings.redeemPoint,
                              color: AppColors.zimkeyDarkGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                            summaryState.bookingSummary.isZpointsApplied
                                ? Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    child: HelperWidgets.buildText(
                                      text:
                                          "Points applied - ${summaryState.bookingSummary.appliedZpoints} ",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppColors.zimkeyOrange,
                                    ),
                                  )
                                : const SizedBox(),
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              child: HelperWidgets.buildText(
                                text:
                                    "Zimkey wallet - ${summaryState.bookingSummary.zpointsBalance} points",
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: AppColors.zimkeyDarkGrey.withOpacity(.5),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              child: HelperWidgets.buildText(
                                text:
                                    "(Max Redeemable - ${summaryState.bookingSummary.maxReedeemablePoints} points)",
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: AppColors.zimkeyDarkGrey.withOpacity(.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      summaryState.bookingSummary.isZpointsApplied
                          ? Expanded(
                              flex: 1,
                              child: InkWell(
                                  onTap: () => HelperDialog.confirmActionDialog(
                                      title: "Remove Points",
                                      msg:
                                          "Do you really want to remove points",
                                      context: context,
                                      btn1Text: "Cancel",
                                      btn2Text: "Remove",
                                      btn1Pressed: () => Navigator.pop(context),
                                      btn2Pressed: () {
                                        BlocProvider.of<SummaryBloc>(context)
                                            .add(LoadCheckoutSummary(
                                                serviceBillingOptionId:
                                                    cubitState
                                                        .selectedBillingId,
                                                units: cubitState.selectedUnit,
                                                addressId: BlocProvider.of<
                                                            OverviewDataCubit>(
                                                        context)
                                                    .cubitState
                                                    .customerAddress
                                                    .id));
                                        Navigator.pop(context);
                                      }),
                                  child: SizedBox(
                                      child: Center(
                                          child: HelperWidgets.buildText(
                                              text: "Remove",
                                              color: AppColors.zimkeyOrange,
                                              fontSize: 14)))))
                          : const SizedBox(),
                      ValueListenableBuilder(
                          valueListenable: showRedeemTextField,
                          builder:
                              (BuildContext context, value, Widget? child) {
                            return CupertinoSwitch(
                              activeColor: AppColors.zimkeyOrange,
                              value: value,
                              onChanged: (bool val) async {
                                if (summaryState
                                    .bookingSummary.isCouponApplied) {
                                  HelperWidgets.showTopSnackBar(
                                      context: context,
                                      message:
                                          "Please remove coupon applied to use this feature !!",
                                      isError: true,
                                      title: "Oops..");
                                } else {
                                  if (summaryState.bookingSummary.zpointsBalance
                                          .round() >
                                      0) {
                                    showRedeemTextField.value = val;
                                    if (!val) {
                                      redeemPointNode.unfocus();
                                    }
                                  } else {
                                    HelperWidgets.showTopSnackBar(
                                        context: context,
                                        message:
                                            "You don't have point to redeem !!",
                                        isError: true,
                                        title: "Oops..");
                                  }
                                }
                              },
                            );
                          }),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ValueListenableBuilder(
                    valueListenable: showRedeemTextField,
                    builder: (BuildContext context, value, Widget? child) {
                      return Visibility(
                        visible: value,
                        child: Container(
                          margin: const EdgeInsets.only(top: 3),
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: const BoxDecoration(
                            color: AppColors.zimkeyLightGrey,
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.zimkeyLightGrey,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: HelperWidgets.buildTextField(
                                      scrollPadding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom +
                                              180.0),
                                      controller:
                                          redeemPointTextEditingController,
                                      hintText: Strings.redeemPointHintText,
                                      focusNode: redeemPointNode,
                                      autoFocus: true,
                                      onChanged: (val) {
                                        val.isNotEmpty
                                            ? enableRedeemPointSubmitButton
                                                .value = true
                                            : enableRedeemPointSubmitButton
                                                .value = false;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(6),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              ValueListenableBuilder(
                                valueListenable: enableRedeemPointSubmitButton,
                                builder: (BuildContext context, value,
                                    Widget? child) {
                                  return InkWell(
                                    onTap: () {
                                      if (redeemPointTextEditingController
                                          .text.isNotEmpty) {
                                        BlocProvider.of<SummaryBloc>(context)
                                            .add(LoadCheckoutSummary(
                                                serviceBillingOptionId:
                                                    cubitState
                                                        .selectedBillingId,
                                                units: cubitState.selectedUnit,
                                                addressId: BlocProvider.of<
                                                            OverviewDataCubit>(
                                                        context)
                                                    .cubitState
                                                    .customerAddress
                                                    .id,
                                                redeemPoints: double.tryParse(
                                                    redeemPointTextEditingController
                                                        .text)!));
                                        showRedeemTextField.value = false;
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: HelperWidgets.buildText(
                                          text: Strings.redeemButton,
                                          color: value
                                              ? AppColors.zimkeyOrange
                                              : AppColors.zimkeyGrey1,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }
}
