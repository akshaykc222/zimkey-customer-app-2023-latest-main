import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../constants/colors.dart';
import '../bloc/auth_bloc.dart';
import 'otp_timer.dart';

class OtpSection extends StatefulWidget {
  final String mobileNum;
  final AnimationController animationController;
  final Animation<double> animation;
  final String errorMsg;

  const OtpSection(
      {Key? key,
      required this.mobileNum,
      required this.animationController,
      required this.animation,
      this.errorMsg = ""})
      : super(key: key);

  @override
  State<OtpSection> createState() => _OtpSectionState();
}

class _OtpSectionState extends State<OtpSection>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final FocusNode otpNode = FocusNode();
  late TextEditingController otpTextController = TextEditingController();
  final ValueNotifier<String> androidInfoNotifier = ValueNotifier("");
  final ValueNotifier<String> iosInfoNotifier = ValueNotifier("");
  final ValueNotifier<String?> fcmTokenNotifier = ValueNotifier("");

  void checkAppConfig() async {
    try {
      final firebaseMessaging = FirebaseMessaging.instance;
      fcmTokenNotifier.value = await firebaseMessaging.getToken();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      androidInfoNotifier.value = androidInfo.model;
      print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"

      final iosInfo = await deviceInfo.iosInfo;
      iosInfoNotifier.value = iosInfo.utsname.machine;
      // print('Running on ${iosInfo.utsname.machine}');
    } catch (e) {
      // Handle any exceptions that occur during async operations.
      print('Error in checkAppConfig: $e');
      // You might want to show an error message to the user here.
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkAppConfig();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    otpTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        // color: AppColors.zimkeyGreen,
        height: MediaQuery.of(context).size.height / 1.06,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    'Verify your number',
                    style: TextStyle(
                      fontSize: 23,
                      color: AppColors.zimkeyBlack,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Enter the 6 digit code sent to',
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      AppColors.zimkeyDarkGrey.withOpacity(0.6),
                                ),
                              ),
                              TextSpan(
                                text: ' ${widget.mobileNum}.',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.zimkeyDarkGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<AuthBloc>(context)
                          .add(LoadInitialState());
                      otpTextController.clear();
                    },
                    child: const Text(
                      'Change number',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.zimkeyOrange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height / 2,
                // color: Colors.grey,
                child: ValueListenableBuilder(
                  valueListenable: androidInfoNotifier,
                  builder: (BuildContext context, androidInfo, Widget? child) {
                    return ValueListenableBuilder(
                      valueListenable: iosInfoNotifier,
                      builder: (BuildContext context, iosInfo, Widget? child) {
                        return ValueListenableBuilder(
                          valueListenable: fcmTokenNotifier,
                          builder:
                              (BuildContext context, fcmToken, Widget? child) {
                            return Column(
                              children: [
                                AnimatedBuilder(
                                  animation: widget.animationController,
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Transform.translate(
                                      offset:
                                          Offset(widget.animation.value, 0.0),
                                      child: Form(
                                        key: formKey,
                                        child: PinCodeTextField(
                                          autoDisposeControllers: false,
                                          autoFocus: true,
                                          enabled: true,
                                          focusNode: otpNode,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          appContext: context,
                                          pastedTextStyle: const TextStyle(
                                            color: AppColors.zimkeyDarkGrey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                          length: 6,
                                          obscureText: false,
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                            color: AppColors.zimkeyDarkGrey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          pinTheme: PinTheme(
                                            shape: PinCodeFieldShape.circle,
                                            fieldHeight: 50,
                                            fieldWidth: 50,
                                            activeFillColor:
                                                AppColors.zimkeyWhite,
                                            activeColor:
                                                AppColors.zimkeyDarkGrey,
                                            inactiveFillColor:
                                                AppColors.zimkeyLightGrey,
                                            selectedFillColor:
                                                AppColors.zimkeyWhite,
                                            selectedColor:
                                                AppColors.zimkeyOrange,
                                            borderWidth: 1,
                                            inactiveColor:
                                                AppColors.zimkeyLightGrey,
                                            disabledColor:
                                                AppColors.zimkeyLightGrey,
                                          ),
                                          cursorColor: AppColors.zimkeyDarkGrey,
                                          animationDuration:
                                              const Duration(milliseconds: 300),
                                          backgroundColor:
                                              AppColors.zimkeyWhite,
                                          enableActiveFill: true,
                                          animationType: AnimationType.scale,
                                          // errorAnimationController: errorController,
                                          controller: otpTextController,
                                          keyboardType: TextInputType.number,
                                          onCompleted: (v) {
                                            // print("Completed");
                                          },
                                          onChanged: (value) async {
                                            if (value.length == 6) {
                                              FirebaseMessaging.instance
                                                  .getToken()
                                                  .then((token) {
                                                BlocProvider.of<AuthBloc>(
                                                        context)
                                                    .add(VerifyOtp(
                                                        otp: value,
                                                        phoneNum:
                                                            "+91${widget.mobileNum}",
                                                        fcmToken: token ?? "",
                                                        deviceId:
                                                            Platform.isAndroid
                                                                ? androidInfo
                                                                : iosInfo,
                                                        device:
                                                            Platform.isAndroid
                                                                ? "ANDROID"
                                                                : "IOS"));
                                              });
                                            }
                                          },
                                          beforeTextPaste: (text) {
                                            // print("Paste code $text ?");
                                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                            return true;
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                OtpTimer(
                                  mobileNum: widget.mobileNum,
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Countdown Timer
