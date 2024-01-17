import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/strings.dart';
import '../../../../../data/model/services/single_service_response.dart';
import '../../../../../utils/helper/helper_widgets.dart';
import '../../../cubit/calculate_service_cost_cubit.dart';
import '../../../cubit/overview_data_cubit.dart';
import '../../common/build_add_or_subtract_button.dart';
import '../../common/build_title.dart';
import '../../common/range_input_formatter.dart';

class BuildBillingOptions extends StatefulWidget {
  final GetService service;

  const BuildBillingOptions({Key? key, required this.service})
      : super(key: key);

  @override
  State<BuildBillingOptions> createState() => _BuildBillingOptionsState();
}

class _BuildBillingOptionsState extends State<BuildBillingOptions> {
  TextEditingController billingCounterController = TextEditingController();
  FocusNode billingCounterNode = FocusNode();

  @override
  void initState() {
    super.initState();
    calculateInitialTotalForCounterService();
    calculateTotalForServiceWithSingleBillingOption();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OverviewDataCubit, OverviewDataCubitState>(
      listener: (context, cubitState) {
        // TODO: implement listener
      },
      builder: (context, cubitState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: widget.service.billingOptions.length > 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BuildTitle(
                        title: Strings.selectHoursOrFrequencyOrCount),
                    hourOrFrequencySelection(
                        selectedBillingOption:
                            cubitState.selectedBillingOption),
                  ],
                )),
            Visibility(
                visible: widget.service.billingOptions.length == 1,
                child: buildCounter(
                    context: context,
                    selectedBillingOption: widget.service.billingOptions)),
          ],
        );
      },
    );
  }

  Widget hourOrFrequencySelection(
      {required List<BillingOption> selectedBillingOption}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 3),
          child: Wrap(
            spacing: 7,
            runSpacing: 7,
            children: List.generate(
              widget.service.billingOptions.length,
              (index) => frequencySelector(
                  billingOption: widget.service.billingOptions[index],
                  selectedBillingId: selectedBillingOption.isNotEmpty
                      ? selectedBillingOption.first.id
                      : ""),
            ),
          ),
        ),
        buildCounter(
            context: context, selectedBillingOption: selectedBillingOption),
      ],
    );
  }

  Widget buildCounter(
      {required BuildContext context,
      required List<BillingOption> selectedBillingOption}) {
    if (selectedBillingOption.isNotEmpty) {
      final BillingOption firstBillingOption = selectedBillingOption.first;

      if (firstBillingOption.maxUnit != firstBillingOption.minUnit) {
        return buildCountFieldInput(
          context: context,
          billingOption: firstBillingOption,
        );
      } else {
        return Container(); // Empty container when maxUnit equals minUnit
      }
    } else {
      return Container(); // Empty container when selectedBillingOption is empty
    }
  }

  Widget frequencySelector(
      {required BillingOption billingOption,
      required String selectedBillingId}) {
    return InkWell(
      onTap: () async {
        BlocProvider.of<CalculatedServiceCostCubit>(context)
            .setCurrentUnit(unit: billingOption.minUnit);
        BlocProvider.of<CalculatedServiceCostCubit>(context).calculateTotalCost(
          unitPrice: billingOption.unitPrice.unitPrice,
          billingId: billingOption.id,
          minUnit: billingOption.minUnit,
          minPrice: billingOption.unitPrice.partnerPrice,
        );
        BlocProvider.of<OverviewDataCubit>(context)
            .setSelectedBillingOption(billingOption);
      },
      child: Container(
        alignment: Alignment.center,
        width: (MediaQuery.of(context).size.width / 3) - 20,
        height: 45,
        decoration: BoxDecoration(
            color: selectedBillingId == billingOption.id
                ? AppColors.zimkeyBodyOrange
                : AppColors.zimkeyWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selectedBillingId == billingOption.id
                  ? AppColors.zimkeyOrange
                  : AppColors.zimkeyDarkGrey.withOpacity(0.3),
            )),
        padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5),
        child: AutoSizeText(
          billingOption.name.replaceAll("-", " "),
          // ReCase(billingOption.name).headerCase.replaceAll('-', ' '),
          style: const TextStyle(
            color: AppColors.zimkeyDarkGrey,
            fontWeight: FontWeight.bold,
          ),
          minFontSize: 10,
          maxFontSize: 12,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Column buildCountFieldInput(
      {required BuildContext context, required BillingOption billingOption}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        BlocBuilder<CalculatedServiceCostCubit, ServiceCostCalculated>(
          builder: (context, cubitCalcState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: HelperWidgets.buildText(
                        text:
                            'How many ${billingOption.unit.toLowerCase()}(s) do you need?',
                        color: AppColors.zimkeyDarkGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        overflow: null),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BuildAddOrSubtractButton(
                          disabled: cubitCalcState.selectedUnit <=
                              billingOption.minUnit,
                          icon: Icons.remove,
                          onTap: () => BlocProvider.of<
                                  CalculatedServiceCostCubit>(context)
                              .subtractCurrentUnit(
                                  unitPrice: billingOption.unitPrice.unitPrice,
                                  billingId: billingOption.id,
                                  minPrice:
                                      billingOption.unitPrice.partnerPrice,
                                  minUnit: billingOption.minUnit),
                        ),
                        buildCountTextField(
                            context: context,
                            billingOption: billingOption,
                            cubitCalcState: cubitCalcState),
                        BuildAddOrSubtractButton(
                            disabled: cubitCalcState.selectedUnit >=
                                billingOption.maxUnit,
                            icon: Icons.add,
                            onTap: () => BlocProvider.of<
                                    CalculatedServiceCostCubit>(context)
                                .addCurrentUnit(
                                    unitPrice:
                                        billingOption.unitPrice.unitPrice,
                                    billingId: billingOption.id,
                                    minPrice:
                                        billingOption.unitPrice.partnerPrice,
                                    maxUnit: billingOption.maxUnit,
                                    minUnit: billingOption.minUnit))
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Expanded buildCountTextField(
      {required BuildContext context,
      required BillingOption billingOption,
      required ServiceCostCalculated cubitCalcState}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: AppColors.zimkeyDarkGrey.withOpacity(0.3),
          ),
        ),
        child: HelperWidgets.buildTextField(
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 300.0),
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.top,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(4),
              RangeInputFormatter(
                  minValue: billingOption.minUnit,
                  maxValue: billingOption.maxUnit)
            ],
            controller: TextEditingController(
                text: cubitCalcState.selectedUnit.toString()),
            focusNode: billingCounterNode,
            onChanged: (val) {
              if (val.isNotEmpty) {
                BlocProvider.of<CalculatedServiceCostCubit>(context)
                    .calculateTotalCost(
                        unitPrice: billingOption.unitPrice.unitPrice,
                        minPrice: billingOption.unitPrice.partnerPrice,
                        unit: int.tryParse(val)!,
                        billingId: billingOption.id,
                        minUnit: billingOption.minUnit);
              }
            },
            hintText: '',
            textFontSize: 18),
      ),
    );
  }

  void calculateInitialTotalForCounterService() async {
    if (BlocProvider.of<CalculatedServiceCostCubit>(context)
            .cubitState
            .selectedUnit ==
        widget.service.billingOptions.first.minUnit) {
      //checking if the billing option is in the type 1 format
      if (widget.service.billingOptions.length == 1 &&
          (widget.service.billingOptions.first.minUnit !=
              widget.service.billingOptions.first.maxUnit)) {
        BlocProvider.of<CalculatedServiceCostCubit>(context).calculateTotalCost(
            minPrice:
                widget.service.billingOptions.first.unitPrice.partnerPrice,
            unitPrice: widget.service.billingOptions.first.unitPrice.unitPrice,
            unit: widget.service.billingOptions.first.minUnit,
            minUnit: widget.service.billingOptions.first.minUnit,
            billingId: widget.service.billingOptions.first.id);
        BlocProvider.of<OverviewDataCubit>(context)
            .setSelectedBillingOption(widget.service.billingOptions.first);
      }
    }
  }

  void calculateTotalForServiceWithSingleBillingOption() {
    //checking if the billing option is in the type 3 format
    if (widget.service.billingOptions.length == 1 &&
        (widget.service.billingOptions.first.minUnit ==
            widget.service.billingOptions.first.maxUnit)) {
      BlocProvider.of<CalculatedServiceCostCubit>(context).calculateTotalCost(
          minPrice: widget.service.billingOptions.first.unitPrice.partnerPrice,
          unitPrice: widget.service.billingOptions.first.unitPrice.unitPrice,
          unit: widget.service.billingOptions.first.minUnit,
          minUnit: widget.service.billingOptions.first.minUnit,
          billingId: widget.service.billingOptions.first.id);
      BlocProvider.of<OverviewDataCubit>(context)
          .setSelectedBillingOption(widget.service.billingOptions.first);
    }
  }

// Widget billingRecurringCounter() {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//     child: Row(
//       children: [
//         const Expanded(
//           child: Text('How many week(s) do you need ?',
//               style: TextStyle(
//                 color: AppColors.zimkeyDarkGrey,
//                 fontSize: 14,
//                 fontWeight: FontWeight.normal,
//               )),
//         ),
//         const SizedBox(
//           width: 5,
//         ),
//         Row(children: [
//           BuildAddOrSubtractButton(icon: Icons.remove, onTap: () {}),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: const Text(
//               '3 week',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.zimkeyBlack),
//             ),
//           ),
//           BuildAddOrSubtractButton(icon: Icons.add, onTap: () {}),
//         ]),
//       ],
//     ),
//   );
// }
}
