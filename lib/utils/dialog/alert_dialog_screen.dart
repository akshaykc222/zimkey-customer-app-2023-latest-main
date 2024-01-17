import 'dart:ui';

import 'package:flutter/material.dart';

class DialogScreen extends StatelessWidget {
  final String iconAssetName;
  final String bodyText;
  final VoidCallback cancelFunc;
  final VoidCallback continueFunc;

  const DialogScreen(
      {Key? key,
      required this.iconAssetName,
      required this.bodyText,
      required this.cancelFunc,
      required this.continueFunc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: InkWell(
                    // onTap: () =>
                    // setState(() {
                    //   showSelectionView = false;
                    // }),
                    child: Container()))),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F).withOpacity(.8),
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    iconAssetName,
                    scale: 3,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    bodyText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: cancelFunc,
                          child: Container(
                              height: 50,
                              decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                              child: const Center(
                                  child: Text("Cancel",
                                      style: TextStyle(fontSize: 14)))),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: continueFunc,
                          child: Container(
                              height: 50,
                              decoration: const BoxDecoration(
                                  color: Color(0xFFA31467),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                              child: const Center(
                                  child: Text("Continue",
                                      style: TextStyle(fontSize: 14)))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
