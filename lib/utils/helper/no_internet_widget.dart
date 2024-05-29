import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../constants/colors.dart';

// import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionStatusManager extends StatefulWidget {
  final Widget child;

  const ConnectionStatusManager({required this.child, Key? key})
      : super(key: key);

  @override
  State<ConnectionStatusManager> createState() =>
      _ConnectionStatusManagerState();
}

class _ConnectionStatusManagerState extends State<ConnectionStatusManager> {
  late Stream<InternetConnectionStatus> connectionStatusStream;

  @override
  void initState() {
    connectionStatusStream = InternetConnectionChecker().onStatusChange;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InternetConnectionStatus>(
      stream: connectionStatusStream,
      builder: (context, snapshot) {
        // bool isConnected = snapshot.data == InternetConnectionStatus.connected;
        return Stack(
          textDirection: TextDirection.ltr,
          children: [
            widget.child,
            const Positioned(
                bottom: 0, left: 0, right: 0, child: NoInternetWidget())
          ],
        );
      },
    );
  }
}

class NoInternetWidget extends StatefulWidget {
  const NoInternetWidget({Key? key}) : super(key: key);

  @override
  State<NoInternetWidget> createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternetWidget>
    with SingleTickerProviderStateMixin {
  final InternetConnectionChecker connectionChecker =
      InternetConnectionChecker();

  late AnimationController animationController;
  late Animation fadeAnimation;
  String showString = "No Internet Connection Found.";

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    fadeAnimation = Tween<double>(begin: 0, end: 70).animate(CurvedAnimation(
        parent: animationController, curve: Curves.bounceInOut));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? const SizedBox()
        : StreamBuilder<InternetConnectionStatus>(
            stream: connectionChecker.onStatusChange,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == InternetConnectionStatus.connected) {
                  animationController.reverse();
                } else {
                  animationController.forward();
                }
                return AnimatedBuilder(
                  animation: fadeAnimation,
                  builder: (BuildContext context, Widget? child) {
                    return fadeAnimation.value == 0
                        ? const SizedBox()
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                                color: animationController.status ==
                                        AnimationStatus.reverse
                                    ? Colors.green
                                    : Colors.red),
                            child: Center(
                              child: Text(
                                animationController.status ==
                                        AnimationStatus.reverse
                                    ? "Back Online."
                                    : "No internet connection found !",
                                textDirection: TextDirection.ltr,
                                style: const TextStyle(
                                    color: AppColors.zimkeyBgWhite,
                                    fontSize: 14),
                              ),
                            ),
                          );
                  },
                );
              } else {
                return const SizedBox();
              }
            });
  }
}
