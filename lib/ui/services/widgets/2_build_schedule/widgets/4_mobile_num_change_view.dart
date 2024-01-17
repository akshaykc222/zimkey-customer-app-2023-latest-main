import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/strings.dart';
import '../../../../../utils/helper/helper_widgets.dart';
import '../../../cubit/overview_data_cubit.dart';

class MobileNumUpdateView extends StatefulWidget {
  const MobileNumUpdateView({Key? key}) : super(key: key);

  @override
  State<MobileNumUpdateView> createState() => _MobileNumUpdateViewState();
}

class _MobileNumUpdateViewState extends State<MobileNumUpdateView> {
  ValueNotifier<bool> showMobileTextField = ValueNotifier(false);
  ValueNotifier<bool> enableMobileUpdateButton = ValueNotifier(false);
  FocusNode mobileNode = FocusNode();
  TextEditingController mobileTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewDataCubit, OverviewDataCubitState>(
      builder: (context, cubitState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HelperWidgets.buildText(
                        text: Strings.wishToAddAnotherNum,
                        color: AppColors.zimkeyDarkGrey,
                        fontSize: 13,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        child: HelperWidgets.buildText(
                          text: cubitState.mobileNum,
                          fontWeight: FontWeight.bold,
                          color: AppColors.zimkeyOrange,
                        ),
                      ),
                    ],
                  ),
                  ValueListenableBuilder(
                      valueListenable: showMobileTextField,
                      builder: (BuildContext context, value, Widget? child) {
                        return CupertinoSwitch(
                          activeColor: AppColors.zimkeyOrange,
                          value: value,
                          onChanged: (bool val) async {
                            showMobileTextField.value = val;
                            if (!val) {
                              mobileNode.unfocus();
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
                valueListenable: showMobileTextField,
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
                                HelperWidgets.buildText(
                                    text: '+91 ',
                                    color: AppColors.zimkeyDarkGrey,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                                Expanded(
                                    child: HelperWidgets.buildTextField(
                                      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 100.0),
                                      controller: mobileTextEditingController,
                                      hintText: Strings.changeNumber,
                                      focusNode: mobileNode,
                                      autoFocus: true,
                                      onChanged: (val) =>
                                      val.length == 10
                                          ? enableMobileUpdateButton.value = true
                                          : enableMobileUpdateButton.value = false,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          ValueListenableBuilder(
                            valueListenable: enableMobileUpdateButton,
                            builder: (BuildContext context, value, Widget? child) {
                              return InkWell(
                                onTap: () {
                                  if (mobileTextEditingController.text.length == 10 && value) {
                                    BlocProvider.of<OverviewDataCubit>(context).addMobileNum("+91${mobileTextEditingController.text}");
                                    showMobileTextField.value = false;
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: HelperWidgets.buildText(
                                      text: Strings.updateMobNo,
                                      color: value ? AppColors.zimkeyOrange : AppColors.zimkeyGrey1,
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
          ),
        );
      },
    );
  }
}
