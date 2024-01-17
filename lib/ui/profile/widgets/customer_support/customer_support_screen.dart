import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../constants/colors.dart';
import '../../../../data/provider/profile_provider.dart';
import '../../../../utils/helper/helper_functions.dart';
import '../../../../utils/helper/helper_widgets.dart';
import '../../bloc/profile_bloc.dart';

class CustomerSupport extends StatefulWidget {
  const CustomerSupport({Key? key}) : super(key: key);

  @override
  CustomerSupportState createState() => CustomerSupportState();
}

class CustomerSupportState extends State<CustomerSupport> {
  TextEditingController subjectController = TextEditingController();
  final FocusNode _subjectNode = FocusNode();
  TextEditingController messageController = TextEditingController();
  final FocusNode _msgNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isFilled = false;
  bool isFilledMsg = false;

  //open whatsapp
  openwhatsapp(BuildContext context) async {
    var whatsapp = "+9112345678";
    var whatsappURLAndroid = "whatsapp://send?phone=" + whatsapp + "&text=hello";
    var whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";

    bool canLaunchWhatsApp = false;
    if (Platform.isIOS) {
      canLaunchWhatsApp = await canLaunchUrlString(whatsappURLIos);
    } else {
      canLaunchWhatsApp = await canLaunchUrlString(whatsappURLAndroid);
    }

    if (canLaunchWhatsApp) {
      launchWhatsApp(whatsappURLAndroid, whatsappURLIos);
    } else {
      showWhatsAppNotInstalledSnackBar(context);
    }
  }

  void launchWhatsApp(String androidUrl, String iosUrl) async {
    String urlToLaunch = Platform.isIOS ? iosUrl : androidUrl;
    await HelperFunctions.launchURL(urlToLaunch);
  }

  void showWhatsAppNotInstalledSnackBar(BuildContext context) {
    if (Platform.isIOS) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("WhatsApp not installed")),
      );
    } else {
      HelperWidgets.showTopSnackBar(
        context: context,
        message: "WhatsApp not installed",
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(profileProvider: RepositoryProvider.of<ProfileProvider>(context)),
      child: Scaffold(
        key: _scaffoldKey,

        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.zimkeyWhite,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.chevron_left,
              color: AppColors.zimkeyDarkGrey,
              size: 30,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30.0),
            child: Container(
              color: AppColors.zimkeyWhite,
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer Support',
                    style: TextStyle(
                      color: AppColors.zimkeyBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Divider(
                    color: AppColors.zimkeyDarkGrey2.withOpacity(0.5),
                    height: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, profileState) {
            if (profileState is CustomerSupportAddedState) {
              HelperWidgets.showTopSnackBar(
                  context: context,
                  message: "Customer support request added",
                  isError: false,
                  icon: const Icon(
                    Icons.check_box_outlined,
                    color: AppColors.zimkeyGreen,
                  ),
                  title: "Success");

              // Future.delayed(const Duration(milliseconds: 500),(){Navigator.pop(context);});

              subjectController.clear();
              messageController.clear();

            }
          },
          builder: (context, profileState) {
            if (profileState is ProfileLoadingState) {
              return SizedBox(
                height: 300,
                width: double.infinity,
                child: Center(
                  child: HelperWidgets.progressIndicator(),
                ),
              );
            } else {
              return Container(
                color: AppColors.zimkeyWhite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          //search field
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            decoration: BoxDecoration(
                              color: AppColors.zimkeyLightGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/icons/question.svg',
                                  colorFilter: const ColorFilter.mode(AppColors.zimkeyDarkGrey, BlendMode.srcIn),
                                  height: 20,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    autofocus: true,
                                    focusNode: _subjectNode,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    textCapitalization: TextCapitalization.sentences,
                                    maxLength: 200,
                                    controller: subjectController,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    decoration: InputDecoration(
                                      errorMaxLines: 2,
                                      counterText: '',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.zimkeyDarkGrey.withOpacity(0.4),
                                        fontWeight: FontWeight.normal,
                                      ),
                                      hintText: 'Enter your message subject',
                                      hintMaxLines: 2,
                                      fillColor: AppColors.zimkeyOrange,
                                      focusColor: AppColors.zimkeyOrange,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    onChanged: (val) {
                                      if (subjectController.text.isNotEmpty) {
                                        setState(() {
                                          isFilled = true;
                                        });
                                      } else {
                                        setState(() {
                                          isFilled = false;
                                        });
                                      }
                                    },
                                    onEditingComplete: () {
                                      FocusScope.of(context).requestFocus(_msgNode);
                                    },
                                  ),
                                ),
                                if (isFilled)
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        subjectController.clear();
                                        isFilled = false;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.clear,
                                      size: 18,
                                    ),
                                  )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //msg field
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                color: AppColors.zimkeyLightGrey, borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/icons/newIcons/email.svg',
                                  colorFilter: const ColorFilter.mode(AppColors.zimkeyDarkGrey, BlendMode.srcIn),
                                  height: 20,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    maxLength: 300,
                                    maxLines: 5,
                                    controller: messageController,
                                    focusNode: _msgNode,
                                    textInputAction: TextInputAction.done,
                                    textCapitalization: TextCapitalization.sentences,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: AppColors.zimkeyDarkGrey,
                                    ),
                                    onChanged: (val) {
                                      if (messageController.text.isNotEmpty) {
                                        setState(() {
                                          isFilledMsg = true;
                                        });
                                      } else {
                                        setState(() {
                                          isFilledMsg = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      prefixIconConstraints: const BoxConstraints(
                                        maxHeight: 25,
                                        maxWidth: 25,
                                      ),
                                      counterText: "",
                                      hintText: 'Enter your feedback/ query here',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.zimkeyDarkGrey.withOpacity(0.3),
                                      ),
                                      fillColor: AppColors.zimkeyOrange,
                                      focusColor: AppColors.zimkeyOrange,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                                if (isFilledMsg)
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        messageController.clear();
                                        isFilledMsg = false;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.clear,
                                      size: 18,
                                    ),
                                  )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          // send
                          Center(
                            child: InkWell(
                              onTap: () {

                                if (subjectController.text.isEmpty && messageController.text.isEmpty) {
                                  HelperWidgets.showTopSnackBar(
                                      context: context, message: "Fields are empty !!", title: "Oops", isError: true);
                                } else {
                                  HelperFunctions.hideKeyboard();
                                  BlocProvider.of<ProfileBloc>(context).add(AddCustomerSupport(
                                      subject: subjectController.text, message: messageController.text));
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 2.5,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.zimkeyOrange,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.zimkeyLightGrey.withOpacity(0.1),
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
                                  'Submit',
                                  style: TextStyle(
                                    color: AppColors.zimkeyWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //bottombar
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      width: double.infinity,
                      color: AppColors.zimkeyGrey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                // color: AppColors.zimkeyGreen,
                                child: InkWell(
                                  onTap: () async => await HelperFunctions.launchURL('tel:+9112345678'),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/icons/newIcons/call.svg',
                                        colorFilter: const ColorFilter.mode(AppColors.zimkeyOrange, BlendMode.srcIn),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Phone',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.zimkeyDarkGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                // color: AppColors.zimkeyGreen,
                                child: InkWell(
                                  onTap: () async => await openwhatsapp(context),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/icons/newIcons/whatsap.svg',
                                        colorFilter: const ColorFilter.mode(AppColors.zimkeyOrange, BlendMode.srcIn),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'WhatsApp',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.zimkeyDarkGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                // color: AppColors.zimkeyGreen,
                                child: InkWell(
                                  onTap: () async => await HelperFunctions.launchURL(
                                      'mailto:support@AppColors.zimkey.in?subject=Hey, need your help.&body=<body>'),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/icons/newIcons/email.svg',
                                        colorFilter: const ColorFilter.mode(AppColors.zimkeyOrange, BlendMode.srcIn),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Email',
                                        style: TextStyle(fontSize: 14, color: AppColors.zimkeyDarkGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Center(
                            child: Text(
                              'Customer Service available all days from: ',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.zimkeyDarkGrey,
                              ),
                            ),
                          ),
                          const Center(
                            child: Text(
                              '9am - 9pm',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.zimkeyDarkGrey,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
