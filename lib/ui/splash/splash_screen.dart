import 'dart:io';

import 'package:customer/ui/splash/data/bloc/app_config_bloc.dart';
import 'package:customer/utils/helper/helper_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:video_player/video_player.dart';

import '../../app_services/push_notification/notification.dart';
import '../../constants/assets.dart';
import '../../utils/helper/helper_functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

// ValueNotifier<double>  currentVersionNotifier = ValueNotifier(0.0);
// final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
// void checkAppConfig(AppConfigDataLoadedState appConfigState, BuildContext context){
//   try {
//
//     double newIosVersion =
//     double.parse(appConfigState.appConfigResponse.getAppConfig.iosVersion.trim().replaceAll(".", ""));
//     double newAndroidVersion =
//     double.parse(appConfigState.appConfigResponse.getAppConfig.androidVersion.trim().replaceAll(".", ""));
//
//     if ((Platform.isIOS && currentVersionNotifier.value < newIosVersion) ||
//         (Platform.isAndroid && currentVersionNotifier.value < newAndroidVersion)) {
//       forceUpdate.value = true;
//     } else if (Platform.isAndroid && appConfigState.appConfigResponse.getAppConfig.androidMMode) {
//       maintenanceMode.value = true;
//     } else if (Platform.isIOS && appConfigState.appConfigResponse.getAppConfig.iosMMode) {
//       maintenanceMode.value = true;
//     } else {
//       maintenanceMode.value = false;
//       HelperFunctions.setupInitialNavigation(context);
//     }
//   } catch (e) {
//     // Handle any exceptions that occur during async operations.
//     print('Error in checkAppConfig: $e');
//     // You might want to show an error message to the user here.
//   }
// }
// void fetchPlatFormInfo() async{
//   PackageInfo  packageInfo = await PackageInfo.fromPlatform();
//   currentVersionNotifier.value = double.parse(packageInfo.version.trim().replaceAll(".", ""));
// }
//
//
// @override
// void initState() {
//   super.initState();
//   fetchPlatFormInfo();

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  ValueNotifier<bool> loadOneTime = ValueNotifier(false);
  ValueNotifier<bool> maintenanceMode = ValueNotifier(false);
  ValueNotifier<bool> forceUpdate = ValueNotifier(false);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  checkFcmMessages() async {
    final RemoteMessage? _message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (_message != null) {
      Future.delayed(Duration.zero, () {
        NotificationService.handleNavigation(_message, context, () {
          HelperFunctions.setupInitialNavigation(_scaffoldKey.currentContext!);
        });
      });
    } else {
      HelperFunctions.setupInitialNavigation(_scaffoldKey.currentContext!);
    }
  }

  void checkAppConfig(
      AppConfigDataLoadedState appConfigState, BuildContext context) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      double currentVersion =
          double.parse(packageInfo.version.trim().replaceAll(".", ""));
      double newIosVersion = double.parse(appConfigState
          .appConfigResponse.getAppConfig.iosVersion
          .trim()
          .replaceAll(".", ""));
      double newAndroidVersion = double.parse(appConfigState
          .appConfigResponse.getAppConfig.androidVersion
          .trim()
          .replaceAll(".", ""));

      if ((Platform.isIOS && currentVersion < newIosVersion) ||
          (Platform.isAndroid && currentVersion < newAndroidVersion)) {
        forceUpdate.value = true;
      } else if (Platform.isAndroid &&
          appConfigState.appConfigResponse.getAppConfig.androidMMode) {
        maintenanceMode.value = true;
      } else if (Platform.isIOS &&
          appConfigState.appConfigResponse.getAppConfig.iosMMode) {
        maintenanceMode.value = true;
      } else {
        maintenanceMode.value = false;
        // Capture the BuildContext within this async function.
        checkFcmMessages();
      }
    } catch (e) {
      // Handle any exceptions that occur during async operations.
      print('Error in checkAppConfig: $e');
      // You might want to show an error message to the user here.
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(Assets.logoAnimation,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    _controller.initialize();
    _controller.play();
    _controller.addListener(() {
      if (!_controller.value.isPlaying) {
        if (!loadOneTime.value) {
          loadOneTime.value = true;
          BlocProvider.of<AppConfigBloc>(context).add(LoadAppConfiguration());
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white, // Set the desired background color
      body: BlocConsumer<AppConfigBloc, AppConfigState>(
        listener: (context, appConfigState) async {
          if (appConfigState is AppConfigDataLoadedState) {
            checkAppConfig(appConfigState, context);
          }
        },
        builder: (context, appConfigState) {
          return ValueListenableBuilder(
            valueListenable: forceUpdate,
            builder: (BuildContext context, forceUpdate, Widget? child) {
              return ValueListenableBuilder(
                valueListenable: maintenanceMode,
                builder:
                    (BuildContext context, maintenanceMode, Widget? child) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Column(
                          children: [
                            Expanded(
                              child: AspectRatio(
                                // aspectRatio: _controller.value.aspectRatio,
                                aspectRatio: 1 / 1,
                                child: VideoPlayer(_controller),
                              ),
                            ),
                          ],
                        ),
                      ),
                      appConfigState is AppConfigLoadingState
                          ? Positioned(
                              right: 20,
                              bottom: 20,
                              child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: Center(
                                    child: HelperWidgets.progressIndicator(),
                                  )))
                          : Container(
                              color: Colors.transparent,
                            ),
                      maintenanceMode
                          ? Positioned.fill(
                              child: Container(
                                  color: Colors.white,
                                  child: const Center(
                                    child: Text("Maintenance Mode"),
                                  )))
                          : Container(
                              color: Colors.transparent,
                            ),
                      forceUpdate
                          ? Positioned.fill(
                              child: Container(
                                  color: Colors.white,
                                  child: const Center(
                                    child: Text("force update"),
                                  )))
                          : Container(
                              color: Colors.transparent,
                            ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
