import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../navigation/route_generator.dart';
import '../../utils/helper/helper_functions.dart';
import '../../utils/helper/helper_widgets.dart';
import '../../utils/object_factory.dart';
import 'bloc/auth_bloc.dart';
import 'widgets/login_section_view.dart';
import 'widgets/otp_section_view.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final FocusNode _mobileNode = FocusNode();

  final TextEditingController _mobileTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(LoadAuthInitialState());
    ObjectFactory().prefs.clearPrefs();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 10.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ScaffoldMessenger(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.zimkeyWhite,
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is OtpVerifySuccessState) {
                if (state.verifyOtpResponse.verifyOtp.data.isCustomerRegistered) {
                  HelperFunctions.navigateToLocationSelection(context);
                } else {
                  Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.userRegisterScreen, (route) => false);
                }
              } else if (state is OtpVerifyErrorState) {
                _animationController.reset();
                _animationController.forward();
                HelperWidgets.showTopSnackBar(
                    context: context, message: state.errorMsg, title: Strings.oops, isError: false);
              }
            },
            builder: (context, state) {
              if (state is OtpSendSuccessState) {
                return OtpSection(
                  mobileNum: _mobileTextController.text,
                  animationController: _animationController,
                  animation: _animation,
                );
              } else if (state is OtpVerifyErrorState) {
                return OtpSection(
                  mobileNum: _mobileTextController.text,
                  errorMsg: state.errorMsg,
                  animationController: _animationController,
                  animation: _animation,
                );
              } else if (state is AuthInitialState) {
                return LoginSection(focusNode: _mobileNode, textEditingController: _mobileTextController);
              } else if (state is AuthLoadingState) {
                return Center(child: HelperWidgets.progressIndicator());
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }


}
