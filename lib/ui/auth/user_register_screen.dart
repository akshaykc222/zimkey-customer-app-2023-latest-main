import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../utils/buttons/animated_button.dart';
import '../../utils/helper/helper_functions.dart';
import '../../utils/helper/helper_widgets.dart';
import '../../utils/object_factory.dart';
import 'bloc/auth_bloc.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({Key? key}) : super(key: key);

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  TextEditingController nameTextController = TextEditingController();
  TextEditingController mailTextController = TextEditingController();
  // TextEditingController referralTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode mailFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode referralFocusNode = FocusNode();
  List<FocusNode> focusNodeList = List.empty(growable: true);

  ValueNotifier<bool> showClearName = ValueNotifier(false);
  ValueNotifier<bool> showClearMail = ValueNotifier(false);
  ValueNotifier<bool> showClearReferral = ValueNotifier(false);
  List<ValueNotifier> clearButtonList = List.empty(growable: true);

  ValueNotifier<bool> validEmail = ValueNotifier(true);
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    focusNodeList.addAll([nameFocusNode, mailFocusNode, referralFocusNode]);
    clearButtonList.addAll([showClearName, showClearMail, showClearReferral]);
  }

  @override
  void dispose() {
    nameTextController.dispose();
    mailTextController.dispose();
    // referralTextController.dispose();
    super.dispose();
  }

  //--------------------
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      // defaultDoneWidget: Container(height: 0),
      actions: List.generate(
        3,
        (index) => KeyboardActionsItem(
          focusNode: focusNodeList[index],
          onTapAction: () {
            if (mailTextController.text.isNotEmpty) {
              HelperFunctions.isValidEmail(mailTextController.text)
                  ? validEmail.value = true
                  : validEmail.value = false;
            }
            checkButtonEnabled();
          },
        ),
      ),
    );
  }

  void checkButtonEnabled() {
    if (nameTextController.text.isNotEmpty && mailTextController.text.isEmpty) {
      isButtonEnabled.value = true;
    } else if (nameTextController.text.isNotEmpty &&
        mailTextController.text.isNotEmpty &&
        validEmail.value) {
      isButtonEnabled.value = true;
    } else {
      isButtonEnabled.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SafeArea(
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is UserRegistrationSuccessState) {
                  ObjectFactory().prefs.setIsLoggedIn(true);
                  HelperFunctions.setupInitialNavigation(context,isFromReg: true);
                }
              },
              builder: (context, state) {
                return Stack(
                  children: [buildRegBody(context), buildStaticScreen()],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Container buildRegBody(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: AppColors.zimkeyBgWhite,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: KeyboardActions(
        config: _buildConfig(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildRegTitle(),
            buildAllTextFields(context),
            buildButton(),
          ],
        ),
      ),
    );
  }

  ValueListenableBuilder<bool> buildStaticScreen() {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (BuildContext context, value, Widget? child) {
        return value
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.height,
                color: Colors.transparent,
              )
            : const SizedBox();
      },
    );
  }

  Column buildRegTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        HelperWidgets.buildText(
            text: Strings.registrationTitle,
            fontSize: 24,
            fontWeight: FontWeight.w700),
        const SizedBox(height: 5),
        HelperWidgets.buildText(
            text: Strings.registrationSubTitle,
            color: AppColors.zimkeyDarkGrey.withOpacity(0.6)),
        const SizedBox(height: 10),
        Container(
          color: AppColors.zimkeyDarkGrey.withOpacity(0.3),
          height: .5,
        ),
      ],
    );
  }

  bool isEmail(String email) {
    // Regular expression for email validation
    // This regex pattern covers most of the valid email formats
    final RegExp regex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return regex.hasMatch(email);
  }

  ValueListenableBuilder<bool> buildButton() {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (BuildContext context, loadingValue, Widget? child) {
        return ValueListenableBuilder(
          valueListenable: isButtonEnabled,
          builder: (BuildContext context, buttonValue, Widget? child) {
            return AnimatedButton(
              onTap: () {
                if (_formKey.currentState?.validate() == true) {
                  isLoading.value = true;
                  BlocProvider.of<AuthBloc>(context).add(RegisterUser(
                      name: nameTextController.text,
                      mail: mailTextController.text,
                      referral: ""
                      // referral: referralTextController.text
                      ));
                }
              },
              btnName: Strings.next,
              isEnabled: buttonValue,
              isLoading: loadingValue,
            );
          },
        );
      },
    );
  }

  ValueListenableBuilder<bool> buildEmailValidator() {
    return ValueListenableBuilder(
      valueListenable: validEmail,
      builder: (BuildContext context, value, Widget? child) {
        return !value
            ? const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Incorrect email ID. Check again.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.zimkeyRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Container buildAllTextFields(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height / 1.6,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //name------
              buildTextField(
                  context: context,
                  controller: nameTextController,
                  icon: Assets.iconUser,
                  hintText: Strings.nameHintText,
                  focusNodePosition: 0,
                  onValidate: (val) {
                    if (val.isEmpty || val.length < 2) {
                      return "Enter valid name!";
                    }
                  }),
              const SizedBox(height: 10),
              //email----
              buildTextField(
                  context: context,
                  controller: mailTextController,
                  icon: Assets.iconRegMail,
                  hintText: Strings.mailHintText,
                  focusNodePosition: 1,
                  onValidate: (val) {
                    if (!HelperFunctions.isValidEmail(val)) {
                      return "Enter valid email!";
                    }
                  }),
              buildEmailValidator(),
              const SizedBox(height: 2),
              //referral code------
              // buildTextField(
              //     context: context,
              //     controller: referralTextController,
              //     icon: Assets.iconReferralCode,
              //     hintText: Strings.referralHintText,
              //     focusNodePosition: 2),
              // const SizedBox(height: 5),
              HelperWidgets.buildText(
                  text: Strings.cautionMsg,
                  fontWeight: FontWeight.w500,
                  color: AppColors.zimkeyDarkGrey.withOpacity(0.5),
                  fontSize: 11),
            ],
          ),
        ),
      ),
    );
  }

  Container buildTextField({
    required BuildContext context,
    required String icon,
    required String hintText,
    required TextEditingController controller,
    required int focusNodePosition,
    Function(String)? onValidate,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.zimkeyDarkGrey2.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SvgPicture.asset(
              icon,
              colorFilter:
                  const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              validator: (val) =>
                  onValidate == null ? null : onValidate(val ?? ""),
              focusNode: focusNodeList[focusNodePosition],
              textCapitalization: focusNodePosition != 2
                  ? TextCapitalization.words
                  : TextCapitalization.characters,
              maxLength: focusNodePosition == 2 ? 6 : 45,
              textInputAction: focusNodePosition == 2
                  ? TextInputAction.done
                  : TextInputAction.next,
              keyboardType: focusNodePosition == 1
                  ? TextInputType.emailAddress
                  : TextInputType.text,
              onEditingComplete: () {
                if (focusNodePosition == 2) {
                  focusNodeList[focusNodePosition].unfocus();
                } else {
                  FocusScope.of(context)
                      .requestFocus(focusNodeList[focusNodePosition++]);
                }
                checkButtonEnabled();
              },
              onChanged: (value) {
                if (value.isNotEmpty) {
                  clearButtonList[focusNodePosition].value = true;
                } else {
                  clearButtonList[focusNodePosition].value = false;
                }
                checkButtonEnabled();
              },
              style: const TextStyle(
                fontSize: 16,
              ),
              decoration: InputDecoration(
                counterText: "",
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: AppColors.zimkeyDarkGrey.withOpacity(0.3),
                ),
                fillColor: AppColors.zimkeyOrange,
                focusColor: AppColors.zimkeyOrange,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: clearButtonList[focusNodePosition],
            builder: (BuildContext context, value, Widget? child) {
              return value
                  ? IconButton(
                      onPressed: () {
                        controller.clear();
                        clearButtonList[focusNodePosition].value = false;
                        validEmail.value = true;
                        checkButtonEnabled();
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: const Icon(
                        Icons.clear,
                        color: AppColors.zimkeyBlack,
                        size: 16,
                      ),
                    )
                  : const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
