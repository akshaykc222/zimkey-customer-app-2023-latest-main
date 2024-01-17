import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/strings.dart';
import '../../../../../data/model/services/single_service_response.dart';
import '../../../../../utils/helper/helper_functions.dart';
import '../../../../../utils/helper/helper_widgets.dart';
import '../../../cubit/overview_data_cubit.dart';
import '../../common/build_title.dart';

class BuildSubServiceSelection extends StatefulWidget {
  final GetService service;

  const BuildSubServiceSelection({Key? key, required this.service}) : super(key: key);

  @override
  State<BuildSubServiceSelection> createState() => _BuildSubServiceSelectionState();
}

class _BuildSubServiceSelectionState extends State<BuildSubServiceSelection> {
  ValueNotifier<bool> isOthersFieldSelected = ValueNotifier(false);
  TextEditingController otherTextController = TextEditingController();
  FocusNode otherFocusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(HelperFunctions.screenWidth(context: context, dividedBy: 8.5).toString());

    return Visibility(
      visible: widget.service.requirements.isNotEmpty,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [const BuildTitle(title: Strings.selectService), requirementSelection(), buildOtherFieldInput()],
      ),
    );
  }

  BlocConsumer<OverviewDataCubit, OverviewDataCubitState> requirementSelection() {
    return BlocConsumer<OverviewDataCubit, OverviewDataCubitState>(
      listener: ((context, cubitState) {
        Logger().i(cubitState.selectedRequirementList.length);
        isOthersFieldSelected.value = HelperFunctions.isOthersSelected(cubitState.selectedRequirementList);
      }),
      builder: (context, cubitState) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: KeyedSubtree(
            key: UniqueKey(),
            child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.start,
                children: List.generate(
                  widget.service.requirements.length,
                  (index) => InkWell(
                    onTap: () => BlocProvider.of<OverviewDataCubit>(context)
                        .addOrRemoveRequirement(widget.service.requirements[index]),
                    child: serviceRequirementTile(
                        context: context,
                        requirements: widget.service.requirements[index],
                        selectedRequirements: cubitState.selectedRequirementList),
                  ),
                )),
          ),
        );
      },
    );
  }

  Widget serviceRequirementTile(
      {required BuildContext context,
      required Requirement requirements,
      required List<Requirement> selectedRequirements}) {
    return Container(
      alignment: Alignment.center,
      width: (MediaQuery.of(context).size.width / 3) - 20,
      height: (MediaQuery.of(context).size.width / 5.5) - 20,
      decoration: BoxDecoration(
        color: selectedRequirements.contains(requirements) ? AppColors.zimkeyBodyOrange : AppColors.zimkeyWhite,
        border: Border.all(
          color: selectedRequirements.contains(requirements)
              ? AppColors.zimkeyOrange
              : AppColors.zimkeyDarkGrey.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Text(
        requirements.title,
        style: const TextStyle(
          color: AppColors.zimkeyDarkGrey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildOtherFieldInput() {
    return BlocConsumer<OverviewDataCubit, OverviewDataCubitState>(
        listener: (BuildContext context, OverviewDataCubitState cubitState) {
          if(otherTextController.text.isEmpty){
            otherTextController.text = cubitState.otherRequirementText;
          }
        },
  builder: (context, cubitState) {
    return ValueListenableBuilder(
      valueListenable: isOthersFieldSelected,
      builder: (BuildContext context, value, Widget? child) {
        if (value) {
          return Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.zimkeyLightGrey,
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(
                  //   color: AppColors.zimkeyDarkGrey
                  //       .withOpacity(0.3),
                  // ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: HelperWidgets.buildTextField(
                            scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 100.0),
                            maxLines: 4,
                            inputFormatters: [LengthLimitingTextInputFormatter(200)],
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                            onChanged: (val) {
                              BlocProvider.of<OverviewDataCubit>(context).addOtherRequirementText(val);
                            },
                            controller: otherTextController,
                            hintText: Strings.otherFieldHintText,
                            focusNode: otherFocusNode)),
                    const SizedBox(
                      width: 10,
                    ),
                    // if (filledOther)
                    cubitState.otherRequirementText.isNotEmpty?InkWell(
                      onTap: () {
                        BlocProvider.of<OverviewDataCubit>(context).addOtherRequirementText("");
                        otherTextController.clear();
                      },
                      child: const Icon(
                        Icons.clear,
                        color: AppColors.zimkeyDarkGrey,
                        size: 16,
                      ),
                    ):Container(),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  },
);
  }
}
