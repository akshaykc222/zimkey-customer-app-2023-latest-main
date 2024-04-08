import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/dom.dart' as dom;
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../data/model/home/home_response.dart';
import '../../ui/home/widgets/search_location.dart';
import '../object_factory.dart';

class HelperWidgets {
  static Widget buildText(
      {required String text,
      double fontSize = 12,
      FontWeight fontWeight = FontWeight.w400,
      Color color = AppColors.zimkeyBlack,
      TextAlign? textAlign,
      TextOverflow? overflow = TextOverflow.ellipsis,
      int? maxLines}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  static dataEmptyWidget({required String msg}) {
    return SizedBox(
      height: 50,
      child: Center(
        child: buildText(text: msg),
      ),
    );
  }

  static Padding buildTitle(String title) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: HelperWidgets.buildText(
          text: title,
          color: AppColors.zimkeyDarkGrey,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ));
  }

  static ValueListenableBuilder<bool> searchLocationScreen({
    required List<GetArea> areaList,
    required Function showLocationSelection,
    required Function({required GetArea selectedArea}) selectUserLoc,
    required ValueNotifier<bool> valueNotifier,
  }) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (BuildContext context, bool value, Widget? child) => value
          ? SearchLocation(
              isFromHome: true,
              contentText: 'Search to select serviceable areas near you.',
              areaList: areaList,
              showLocationSelection: showLocationSelection,
              selectedUserLoc: selectUserLoc,
            )
          : const SizedBox(),
    );
  }

  static Widget buildTextField(
      {required TextEditingController controller,
      required String hintText,
      required FocusNode focusNode,
      int? maxLength,
      int? maxLines,
      TextAlign textAlign = TextAlign.start,
      TextAlignVertical? textAlignVertical,
      double textFontSize = 14,
      double hintTextFontSize = 14,
      VoidCallback? onTap,
      VoidCallback? onEditingComplete,
      bool autoFocus = false,
      bool readOnly = false,
      EdgeInsetsGeometry? contentPadding,
      ValueChanged<String>? onChanged,
      TextInputType keyboardType = TextInputType.text,
      TextCapitalization textCapitalization = TextCapitalization.none,
      List<TextInputFormatter> inputFormatters = const [],
      EdgeInsets scrollPadding = const EdgeInsets.only(bottom: 20.0)}) {
    return TextFormField(
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      scrollPadding: scrollPadding,
      onEditingComplete: onEditingComplete,
      textCapitalization: textCapitalization,
      onTap: onTap,
      onChanged: onChanged,
      focusNode: focusNode,
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.done,
      autofocus: autoFocus,
      inputFormatters: inputFormatters,
      style: TextStyle(
        fontSize: textFontSize,
      ),
      decoration: InputDecoration(
        contentPadding: contentPadding,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: hintTextFontSize,
          color: AppColors.zimkeyBlack.withOpacity(0.3),
        ),
        fillColor: AppColors.zimkeyOrange,
        focusColor: AppColors.zimkeyOrange,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }

  static void logoutAction(context, token) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: Text(
              Strings.loginOutConfirmationText,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 18.0, color: Theme.of(context).primaryColor),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    Strings.cancel,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).primaryColor, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: Text(
                    Strings.logoutText,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppColors.buttonColor, fontSize: 16),
                  ),
                  onPressed: () async {
                    /// clearing prefs  and   navigate to login page

// othersBloc.deleteFcmToken(fcmToken: token);

                    ObjectFactory().prefs.setIsLoggedIn(false);

// if(ObjectFactory().prefs.getStateList()!=null) {
//   stateResponse = ObjectFactory().prefs
//       .getStateList();
// }
// ObjectFactory().prefs.clearPrefs();
//  if(stateResponse!=null){
//  ObjectFactory().prefs.saveStateList(stateResponse);}
//                    ObjectFactory().prefs.saveMasterData(masterDataResponse);
//                     w

//                    Navigator.pushAndRemoveUntil(
//                        context,
//                        MaterialPageRoute(builder: (context) => Login()),
//                            (Route<dynamic> route) => false);
                  }),
            ],
          );
        });
  }

  static Widget lottieComingSoon() {
    return Lottie.asset(Assets.comingSoonGif);
  }

  static Widget errorWidget() {
    return buildText(
        text: Strings.somethingWentWrong, color: Colors.red, fontSize: 16);
  }

  static void alertDialog(context,
      {required String text,
      required VoidCallback func,
      required String buttonText}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: Text(
              text,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 16.0, color: Theme.of(context).primaryColor),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    Strings.cancel,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).primaryColor, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  onPressed: func,
                  child: Text(
                    buttonText,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppColors.buttonColor, fontSize: 16),
                  )),
            ],
          );
        });
  }

  static Widget progressIndicator() {
    return const CircularProgressIndicator(
      backgroundColor: AppColors.zimkeyOrange,
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.zimkeyBodyOrange),
    );
  }

  static Widget buildHorizontalListView(
      {required int length,
      required Widget Function({required int index}) itemBuilder,
      required double height,
      int modValue = 1,
      bool showAlternate = false}) {
    return SizedBox(
      height: length > 0 ? height : 0,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: length,
        itemBuilder: (context, index) {
          return index % modValue == 0
              ? !showAlternate
                  ? Padding(
                      padding: EdgeInsets.only(left: index == 0 ? 20.0 : 0),
                      child: itemBuilder(index: index),
                    )
                  : Container()
              : showAlternate
                  ? Padding(
                      padding: EdgeInsets.only(left: index == 1 ? 20.0 : 0),
                      child: itemBuilder(index: index),
                    )
                  : Container();
        },
      ),
    );
  }

  static Widget customPageViewIndicators(
      PageController controller, int count, bool isDots, double size,
      {Color dotColor = AppColors.zimkeyOrange}) {
    return SmoothPageIndicator(
      controller: controller, // PageController
      count: count,
      effect: isDots
          ? WormEffect(
              spacing: 3,
              dotHeight: size,
              dotWidth: size,
              dotColor: dotColor.withOpacity(0.5),
              activeDotColor: dotColor,
            )
          : ExpandingDotsEffect(
              dotHeight: size,
              dotWidth: size,
              dotColor: dotColor.withOpacity(0.5),
              activeDotColor: dotColor,
            ), // your preferred effect
    );
  }

  static void showCustomSnackBar(
    BuildContext context,
    String message, {
    bool loading = false,
    int duration = 2,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Container(
              padding: const EdgeInsetsDirectional.only(start: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  12,
                ),
                color: AppColors.buttonColor,
              ),
              height: 60,
              child: Row(
                children: [
                  if (loading)
                    const Padding(
                      padding: EdgeInsetsDirectional.only(end: 10.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        duration: Duration(seconds: duration),
        backgroundColor: Colors.black26,
      ),
    );
  }

  static void showSnackBar(
    BuildContext context,
    String message, {
    bool loading = false,
    int duration = 2,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              if (loading)
                const Padding(
                  padding: EdgeInsetsDirectional.only(end: 10.0),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              Text(
                message,
                style: const TextStyle(color: AppColors.buttonColor),
              ),
            ],
          ),
        ),
        duration: Duration(seconds: duration),
        backgroundColor: Colors.black,
      ),
    );
  }

  static void showTopSnackBar(
          {required BuildContext context,
          required String message,
          required bool isError,
          String? title,
          Widget? icon,
          double backgroundBlur = 0.0}) =>
      Flushbar(
        title: title,
        message: message,
        messageSize: 16,
        messageColor: AppColors.zimkeyDarkGrey2,
        titleColor: isError ? Colors.red.shade400 : AppColors.zimkeyDarkGrey2,
        barBlur: 1,
        duration: const Duration(seconds: 3),
        icon: icon,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        borderRadius: BorderRadius.circular(15),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: AppColors.zimkeyWhite2,
      )..show(context);

  static void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void showToastLong(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static Widget htmlCustomRenderer(dom.Node node) {
    if (node is dom.Element) {
      switch (node.localName) {
        case "li":
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 4,
                backgroundColor: AppColors.zimkeyDarkGrey,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(child: Text(node.text)),
            ],
          );
        case "p":
          {
            if (node.text[0] == "*") {
              String thisText = node.text.replaceFirst("*", "");
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: const CircleAvatar(
                        radius: 3,
                        backgroundColor: AppColors.zimkeyDarkGrey,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(thisText),
                    ),
                  ],
                ),
              );
            } else {
              return Text(node.text);
            }
          }
      }
    }
    return Container();
  }
// static List<HtmlExtension> htmlCustomRendererr(dom.Node node) {
//
//   return [
//     TagExtension(
//       tagsToExtend: {"flutter"},
//       child: const FlutterLogo(),
//     ),
//   ];
// }
}
