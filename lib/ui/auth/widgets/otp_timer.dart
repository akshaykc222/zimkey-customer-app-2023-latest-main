import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/colors.dart';
import '../../../utils/helper/helper_widgets.dart';
import '../bloc/auth_bloc.dart';

class OtpTimer extends StatefulWidget {
  final String mobileNum;

  const OtpTimer({Key? key, required this.mobileNum}) : super(key: key);

  @override
  OtpTimerState createState() => OtpTimerState();
}

class OtpTimerState extends State<OtpTimer> {
  ValueNotifier<bool> showResendOTP = ValueNotifier(false);
  late Timer _timer;
  final ValueNotifier<int> _secondsRemaining = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _secondsRemaining.value = 90;
    showResendOTP.value = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_secondsRemaining.value > 0) {
        _secondsRemaining.value--;
      } else {
        timer.cancel();
        showResendOTP.value = true;
        // widget.onTimerComplete();
      }
    });
  }

  String _getFormattedTime() {
    final minutes = (_secondsRemaining.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _secondsRemaining,
          builder: (BuildContext context, int value, Widget? child) {
            return HelperWidgets.buildText(
                text: _getFormattedTime(),
                fontSize: 16,
                color: AppColors.zimkeyDarkGrey,
                fontWeight: FontWeight.w700);
          },
        ),
        const SizedBox(
          height: 5,
        ),
        ValueListenableBuilder(
          valueListenable: showResendOTP,
          builder: (BuildContext context, bool value, Widget? child) {
            return value
                ? GestureDetector(
                    onTap: () async {
                      BlocProvider.of<AuthBloc>(context).add(ReSendOtp(phoneNum: widget.mobileNum));
                      _startTimer();
                      HelperWidgets.showTopSnackBar(
                          context: context,
                          message: "OTP sent",
                          isError: false,
                          icon: Icon(
                            Icons.check_box_outlined,
                            color: Colors.green,
                          ));
                    },
                    child: HelperWidgets.buildText(
                        text: 'Resend Code ',
                        fontSize: 16,
                        color: AppColors.zimkeyOrange,
                        fontWeight: FontWeight.w700))
                : const SizedBox();
          },
        ),
      ],
    );
  }
}
