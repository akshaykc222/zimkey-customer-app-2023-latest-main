import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/colors.dart';
import '../../../utils/helper/helper_functions.dart';
import '../../../utils/object_factory.dart';



class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController _controller = PageController(
    initialPage: 0,
  );
  int currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            PageView(
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                  print('Onbaording page $currentPage');
                });
              },
              scrollDirection: Axis.horizontal,
              controller: _controller,
              children: [
                onboardingPages('assets/images/graphics/onbaord1.svg',
                    'Trained and verified professionals\nfor jobs done well.'),
                onboardingPages('assets/images/graphics/onbaord2.svg',
                    'The highest standards of safety,\nso you can breathe easy.'),
                onboardingPages('assets/images/graphics/onbaord3.svg',
                    'Get 20% off on your first task with Zimkey.\nUse code \'Newbie\' at checkout.'),
                onboardingPages('assets/images/graphics/onbaord4.svg',
                    'Quality home services, just a few taps away.'),
                onboardingPages('assets/images/graphics/onbaord5.svg',
                    'Clear and transparent pricing.\nNo haggling, no hassles.'),
              ],
            ),
            //Bottom fixed section
            Positioned(
              bottom: 40.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                child: Column(
                  children: [
                    HelperFunctions.customPageViewIndicators(_controller, 5, false, 8),
                    const SizedBox(
                      height: 100,
                    ),
                    GestureDetector(
                      onTap: () async {
                        ObjectFactory().prefs.setIsOnboardViewed(true);
                        HelperFunctions.checkNavigation(context);
                        // Get.toNamed('/login');
                        // Navigator.push(
                        //   context,
                        //   PageTransition(
                        //     type: PageTransitionType.rightToLeftWithFade,
                        //     child: Login(),
                        //     duration: const Duration(milliseconds: 200),
                        //   ),
                        // );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 120,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            decoration: BoxDecoration(
                              color: AppColors.zimkeyWhite,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.zimkeyLightGrey.withOpacity(0.1),
                                  blurRadius: 7.0, // soften the shadow
                                  spreadRadius: 2.0, //extend the shadow
                                  offset: const Offset(
                                    1.0, // Move to right 10  horizontally
                                    4.0, // Move to bottom 10 Vertically
                                  ),
                                )
                              ],
                            ),
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                // fontSize: 16,
                                color: AppColors.zimkeyBlack,
                                fontFamily: 'Inter',
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget onboardingPages(String img, String descText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          img,
          height: MediaQuery.of(context).size.height / 3.5,
        ),
        // SizedBox(
        //   height: 50,
        // ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Text(
        //       'Heading title',
        //       style: TextStyle(
        //         color: zimkeyBlack,
        //         fontSize: 28,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            descText,
            style: TextStyle(
              color: AppColors.zimkeyDarkGrey,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        //     SizedBox(
        //       height: 50,
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
