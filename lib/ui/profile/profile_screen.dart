import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:recase/recase.dart';

import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../data/model/auth/user_detail_response.dart';
import '../../data/model/auth/verify_otp_response.dart';
import '../../data/provider/profile_provider.dart';
import '../../navigation/route_generator.dart';
import '../../utils/helper/helper_dialog.dart';
import '../../utils/helper/helper_functions.dart';
import '../../utils/helper/helper_widgets.dart';
import '../../utils/object_factory.dart';
import '../auth/bloc/auth_bloc.dart';
import 'bloc/profile_bloc.dart';
import 'widgets/html_view/html_view_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ValueNotifier<PackageInfo?> packageInfo = ValueNotifier(null);
  ValueNotifier<User> userInfoNotifier =
      ValueNotifier(User(id: "", name: "", phone: "", email: ""));
  ValueNotifier<Analytics> analyticsInfoNotifier = ValueNotifier(Analytics(
      openBookings: "",
      rewardPointBalance: "",
      totalBookings: "",
      pendingPaymentsCounts: ""));
  ValueNotifier<bool> hasLoginned = ValueNotifier(true);
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    var user = HelperFunctions.user();
    if (user == null) {
      hasLoginned.value = false;
    } else {
      hasLoginned.value = true;
      userInfoNotifier.value = user;
    }
    BlocProvider.of<AuthBloc>(context).add(GetUserDetails());
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    packageInfo.value = info;
  }

  String getAvatarInitials(String name) {
    List<String> words = name.split(' ');

    if (words.length > 1) {
      // If there are multiple words, take the first letter from each word
      String firstInitial = words[0][0];
      // String secondInitial = words[0][0];
      return '$firstInitial';
    } else {
      // If there is only one word, take the first two characters
      if (name.length >= 2) {
        return name.substring(0, 2);
      } else {
        return "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
          profileProvider: RepositoryProvider.of<ProfileProvider>(context))
        ..add(LoadCmsContent()),
      child: Scaffold(
          appBar: buildAppBar(),
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (BuildContext context, AuthState authState) {
              if (authState is UserUpdateSuccessState) {
                ObjectFactory().prefs.saveUserData(User(
                    id: authState.updateUserResponse.updateUser.id,
                    name: authState.updateUserResponse.updateUser.name,
                    phone: authState.updateUserResponse.updateUser.phone,
                    email: authState.updateUserResponse.updateUser.email));
                userInfoNotifier.value = User(
                    id: authState.updateUserResponse.updateUser.id,
                    name: authState.updateUserResponse.updateUser.name,
                    phone: authState.updateUserResponse.updateUser.phone,
                    email: authState.updateUserResponse.updateUser.email);
              } else if (authState is AuthUserDataLoadedState) {
                userInfoNotifier.value = User(
                    id: authState.userDetailsResponse.me.id,
                    name: authState.userDetailsResponse.me.name,
                    phone: authState.userDetailsResponse.me.phone,
                    email: authState.userDetailsResponse.me.email,
                    disableAccount: authState
                        .userDetailsResponse.me.customerDetails.disableAccount);
                analyticsInfoNotifier.value =
                    authState.userDetailsResponse.me.analytics;
              }
            },
            builder: (context, authState) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: AppColors.zimkeyWhite,
                child: LiquidPullToRefresh(
                  color: AppColors.zimkeyOrange,
                  showChildOpacityTransition: false,
                  onRefresh: () async {
                    BlocProvider.of<AuthBloc>(context).add(GetUserDetails());
                    final Completer<void> completer = Completer<void>();
                    Timer(const Duration(seconds: 2), () {
                      completer.complete();
                    });
                    return completer.future.then<void>((_) {});
                  },
                  springAnimationDurationInMilliseconds: 600,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              authState is AuthLoadingState
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: HelperFunctions.checkLoggedIn()
                                          ? Center(
                                              child: HelperWidgets
                                                  .progressIndicator(),
                                            )
                                          : SizedBox(
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors
                                                                  .zimkeyOrange),
                                                  onPressed: () {
                                                    HelperFunctions
                                                        .navigateToLogin(
                                                            context);
                                                  },
                                                  child: const Text("Login")),
                                            ),
                                    )
                                  : ValueListenableBuilder(
                                      valueListenable: userInfoNotifier,
                                      builder: (BuildContext context, User user,
                                          Widget? child) {
                                        return Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 80,
                                              width: 80,
                                              decoration: const BoxDecoration(
                                                color:
                                                    AppColors.zimkeyLightGrey,
                                                shape: BoxShape.circle,
                                              ),
                                              child: HelperFunctions
                                                      .checkLoggedIn()
                                                  ? Text(
                                                      getAvatarInitials(
                                                              user.name)
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                          fontSize: 40,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : SvgPicture.asset(
                                                      'assets/images/icons/newIcons/profile-circle.svg',
                                                      height: 80,
                                                    ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ReCase(user.name).titleCase,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  '+91 ${(user.phone).substring(3)}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  user.email,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                              const SizedBox(
                                height: 10,
                              ),

                              authState is AuthUserDataLoadedState
                                  ? ValueListenableBuilder(
                                      valueListenable: analyticsInfoNotifier,
                                      builder: (BuildContext context, analytics,
                                          Widget? child) {
                                        return authState
                                                    .userDetailsResponse
                                                    .me
                                                    .customerDetails
                                                    .disableAccount ==
                                                true
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'General',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .zimkeyDarkGrey,
                                                    ),
                                                  ),
                                                  profileMenuItem(
                                                    menuTitle:
                                                        'Customer Support',
                                                    icon:
                                                        'assets/images/icons/newIcons/support.svg',
                                                    context: context,
                                                    screenName: RouteGenerator
                                                        .customerSupportScreen,
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 20),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 20),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .zimkeyGreen
                                                          .withOpacity(0.05),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        overviewTiles(
                                                            title:
                                                                'Zimkey \nPoints',
                                                            value: analytics
                                                                .rewardPointBalance
                                                                .toString(),
                                                            isinfo: true,
                                                            description: authState
                                                                .userDetailsResponse
                                                                .me
                                                                .zpointsDescription),
                                                        overviewTiles(
                                                          title:
                                                              'Open \nOrders',
                                                          value: analytics
                                                              .openBookings,
                                                          isinfo: false,
                                                        ),
                                                        overviewTiles(
                                                          title:
                                                              'Total \nOrders',
                                                          value: analytics
                                                              .totalBookings,
                                                          isinfo: false,
                                                        ),
                                                        overviewTiles(
                                                          title:
                                                              'Pending \nPayments',
                                                          value: analytics
                                                              .pendingPaymentsCounts,
                                                          isinfo: false,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'General',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .zimkeyDarkGrey,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 7,
                                                      ),
                                                      profileMenuItem(
                                                        menuTitle:
                                                            'Edit Profile',
                                                        icon:
                                                            'assets/images/user.svg',
                                                        context: context,
                                                        screenName: RouteGenerator
                                                            .editProfileScreen,
                                                      ),
                                                      profileMenuItem(
                                                        menuTitle:
                                                            'Address Book',
                                                        icon:
                                                            'assets/images/icons/newIcons/book.svg',
                                                        context: context,
                                                        screenName: RouteGenerator
                                                            .addressListScreen,
                                                      ),
                                                      // profileMenuItem(
                                                      //     'Refer & Earn', 'assets/images/icons/newIcons/money-recive.svg', context, Container()),
                                                      profileMenuItem(
                                                        menuTitle:
                                                            'Customer Support',
                                                        icon:
                                                            'assets/images/icons/newIcons/support.svg',
                                                        context: context,
                                                        screenName: RouteGenerator
                                                            .customerSupportScreen,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                      },
                                    )
                                  : const SizedBox(),

                              // buildRegister(),
                              const SizedBox(
                                height: 20,
                              ),
                              BlocBuilder<ProfileBloc, ProfileState>(
                                builder: (context, cmsContentState) {
                                  if (cmsContentState is ProfileLoadingState) {
                                    return Center(
                                      child: HelperWidgets.progressIndicator(),
                                    );
                                  } else if (cmsContentState
                                      is ProfileCmsContentLoadedState) {
                                    return Column(
                                      children: [
                                        const Text(
                                          'Information',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.zimkeyDarkGrey,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        profileMenuItem(
                                          menuTitle: 'FAQs',
                                          icon:
                                              'assets/images/icons/newIcons/faqSearch.svg',
                                          context: context,
                                          screenName: RouteGenerator.faqScreen,
                                        ),
                                        profileMenuItem(
                                            menuTitle: 'Terms of Service',
                                            icon:
                                                'assets/images/icons/newIcons/terms.svg',
                                            context: context,
                                            screenName:
                                                RouteGenerator.htmlViewerScreen,
                                            htmlData: cmsContentState
                                                .getCmsContentsResponse
                                                .getCmsContent
                                                .termsConditionsCustomer),
                                        profileMenuItem(
                                            menuTitle: 'Cancellation Policy',
                                            icon:
                                                'assets/images/icons/newIcons/cancellationPolicy.svg',
                                            context: context,
                                            screenName:
                                                RouteGenerator.htmlViewerScreen,
                                            htmlData: cmsContentState
                                                .getCmsContentsResponse
                                                .getCmsContent
                                                .cancellationPolicyCustomer),
                                        profileMenuItem(
                                            menuTitle: 'Privacy Policy',
                                            icon: 'assets/images/privacy.svg',
                                            context: context,
                                            screenName:
                                                RouteGenerator.htmlViewerScreen,
                                            htmlData: cmsContentState
                                                .getCmsContentsResponse
                                                .getCmsContent
                                                .privacyPolicy),
                                        profileMenuItem(
                                            menuTitle: 'Safety Policy',
                                            icon:
                                                'assets/images/icons/newIcons/safety.svg',
                                            context: context,
                                            screenName:
                                                RouteGenerator.htmlViewerScreen,
                                            htmlData: cmsContentState
                                                .getCmsContentsResponse
                                                .getCmsContent
                                                .safetyPolicy),
                                        profileMenuItem(
                                            menuTitle: 'About Us',
                                            icon:
                                                'assets/images/icons/newIcons/informationProfile.svg',
                                            context: context,
                                            screenName:
                                                RouteGenerator.htmlViewerScreen,
                                            htmlData: cmsContentState
                                                .getCmsContentsResponse
                                                .getCmsContent
                                                .aboutUs),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              InkWell(
                                  onTap: () => HelperDialog.confirmActionDialog(
                                      title: Strings.logoutText,
                                      context: context,
                                      msg: Strings.loginOutConfirmationText,
                                      btn2Text: Strings.logoutText,
                                      btn1Text: Strings.cancel,
                                      btn2Pressed: () => logoutAction(),
                                      btn1Pressed: () =>
                                          Navigator.pop(context)),
                                  child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: HelperWidgets.buildText(
                                              text: "Sign Out",
                                              color: AppColors.zimkeyOrange,
                                              fontSize: 16)))),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          color: AppColors.zimkeyLightGrey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: packageInfo,
                                builder: (BuildContext context, value,
                                    Widget? child) {
                                  return Text(
                                    'App Version ${value?.version}.${value?.buildNumber}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.zimkeyDarkGrey,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Update available',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.zimkeyOrange,
                                ),
                              ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  Column buildRegister() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Login or Register ',
              style: TextStyle(
                color: AppColors.zimkeyBlack,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Kindly register to access all the profile benefits',
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            // setState(() {
            //   Get.offAllNamed('/login');
            // });
          },
          child: Container(
            alignment: Alignment.center,
            width: 100,
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
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
              'Register',
              style: TextStyle(
                color: AppColors.zimkeyWhite,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget profileMenuItem(
      {required String menuTitle,
      required String icon,
      required BuildContext context,
      required String screenName,
      String htmlData = ""}) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, screenName,
            arguments:
                HtmlViewerScreenArg(htmlData: htmlData, title: menuTitle));
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(vertical: 10),
        // color: zimkeyGreen,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              menuTitle,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.zimkeyBlack,
              ),
            ),
            SvgPicture.asset(
              icon,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget overviewTiles(
      {required String title,
      required String value,
      required bool isinfo,
      String description = ""}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              width: 5,
            ),
            if (isinfo)
              GestureDetector(
                onTap: () => HelperDialog.confirmActionDialog(
                  title: "Zimkey Points",
                  context: context,
                  msg: description,
                ),
                child: SvgPicture.asset( 
                  'assets/images/icons/question.svg',
                  colorFilter: const ColorFilter.mode(
                      AppColors.zimkeyOrange, BlendMode.srcIn),
                  width: 15,
                  height: 15,
                ),
              ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.zimkeyGreen,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.zimkeyWhite,
      elevation: 0,
      centerTitle: false,
      title: const Text(
        'Profile',
        style: TextStyle(
          // fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.zimkeyDarkGrey,
        ),
      ),
    );
  }

  logoutAction() {
    ObjectFactory().prefs.clearPrefs();
    HelperFunctions.navigateToLogin(context);
  }
}
