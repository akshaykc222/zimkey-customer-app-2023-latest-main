import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/colors.dart';
import '../../../utils/helper/helper_functions.dart';
import '../../../utils/helper/helper_widgets.dart';
import '../bloc/auth_bloc.dart';

ValueNotifier<bool> skipped = ValueNotifier(false);

class LoginSection extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController textEditingController;

  const LoginSection(
      {Key? key, required this.focusNode, required this.textEditingController})
      : super(key: key);

  @override
  State<LoginSection> createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  final ValueNotifier<bool> showClearIcon = ValueNotifier(false);
  final ValueNotifier<bool> selectRegisterButton = ValueNotifier(false);
  final ValueNotifier<bool> policySelected = ValueNotifier(false);
  final String _countryCode = "+91";

  @override
  void initState() {
    skipped.value = false;
    if (widget.textEditingController.text.isNotEmpty) {
      showClearIcon.value = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HelperFunctions.hideKeyboard(),
      child: SafeArea(
        top: true,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          color: AppColors.zimkeyWhite,
          height: MediaQuery.of(context).size.height / 1.06,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset(
                      'assets/images/graphics/logo_without.svg',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.zimkeyDarkGrey.withOpacity(0.3),
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SvgPicture.asset(
                        //   'assets/images/icons/indiaFlag.svg',
                        //   width: 20,
                        //   height: 20,
                        // ),
                        // const SizedBox(
                        //   width: 5,
                        // ),
                        Text(
                          _countryCode,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Expanded(
                          child: TextFormField(
                            focusNode: widget.focusNode,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            controller: widget.textEditingController,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                showClearIcon.value = true;
                              } else if (value.isEmpty) {
                                showClearIcon.value = false;
                              }
                              if (value.length == 10) {
                                selectRegisterButton.value = true;
                                HelperFunctions.hideKeyboard();
                              } else {
                                selectRegisterButton.value = false;
                              }
                            },
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              errorMaxLines: 2,
                              counterText: '',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                // color: Colors.red,
                                color:
                                    AppColors.zimkeyDarkGrey.withOpacity(0.3),
                                fontWeight: FontWeight.normal,
                              ),
                              hintText: 'Enter your mobile number',
                              hintMaxLines: 2,
                              fillColor: AppColors.zimkeyOrange,
                              focusColor: AppColors.zimkeyOrange,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        ValueListenableBuilder(
                          valueListenable: showClearIcon,
                          builder: (BuildContext context, bool value,
                              Widget? child) {
                            return value
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: AppColors.zimkeyBlack,
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      widget.textEditingController.clear();
                                      showClearIcon.value = false;
                                      selectRegisterButton.value = false;
                                    })
                                : Container();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: policySelected,
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return InkWell(
                            onTap: () => policySelected.value = !value,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: value
                                    ? AppColors.zimkeyOrange
                                    : AppColors.zimkeyWhite,
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: AppColors.zimkeyOrange,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 17,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                  text: 'By registering, you agree to the',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.zimkeyBlack,
                                  )),
                              TextSpan(
                                text: ' Terms of Service ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppColors.zimkeyBlack,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    HelperFunctions.launchURL(
                                        'https://zimkey.in/page-terms');
                                    print('Terms tapped!!');
                                  },
                              ),
                              const TextSpan(
                                  text: 'and ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.zimkeyBlack,
                                  )),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.zimkeyBlack,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    HelperFunctions.launchURL(
                                        'https://zimkey.in/privacy-policy');
                                    print('Terms tapped!!');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: selectRegisterButton,
                          builder: (BuildContext context, bool registerSelected,
                              Widget? child) {
                            return ValueListenableBuilder(
                              valueListenable: policySelected,
                              builder: (BuildContext context,
                                  bool privacySelected, Widget? child) {
                                return GestureDetector(
                                  onTap: () async {
                                    if (registerSelected && privacySelected) {
                                      BlocProvider.of<AuthBloc>(context).add(
                                          SendOtp(
                                              phoneNum:
                                                  "+91${widget.textEditingController.text}"));
                                      HelperWidgets.showTopSnackBar(
                                          context: context,
                                          title: "Alert",
                                          message: "OTP sent",
                                          isError: false);
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    // width: MediaQuery.of(context).size.width - 190,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color:
                                          // isFilled &&
                                          registerSelected && privacySelected
                                              // && checked
                                              ? AppColors.zimkeyOrange
                                              : AppColors.zimkeyWhite,
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
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            // isFilled &&
                                            registerSelected && privacySelected
                                                // && checked
                                                ? Colors.white
                                                : AppColors.zimkeyBlack,
                                        fontFamily: 'Inter',
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          skipped.value = true;
                          // fbState.setUserLoggedIn('false');
                          // // -------------!!! Go to Dashboard-----------
                          // // Get.offAllNamed('/dashboard');
                          // Navigator.push(
                          //   context,
                          //   PageTransition(
                          //     type: PageTransitionType.rightToLeftWithFade,
                          //     child: Dashboard(),
                          //     duration: Duration(milliseconds: 500),
                          //   ),
                          // );
                          // HelperWidgets.showTopSnackBar(
                          //     context: context,
                          //     title: "Alert",
                          //     message: "OTP sent",
                          //     isError: false);
                          HelperFunctions.navigateToLocationSelection(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.zimkeyBgWhite,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.zimkeyLightGrey.withOpacity(0.1),
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
                            'Skip',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.zimkeyBlack,
                              fontFamily: 'Inter',
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
