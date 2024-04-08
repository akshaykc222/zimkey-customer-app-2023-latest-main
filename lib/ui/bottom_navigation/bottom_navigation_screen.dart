import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/colors.dart';
import '../../data/model/auth/verify_otp_response.dart';
import '../../navigation/route_generator.dart';
import '../../utils/helper/helper_widgets.dart';
import '../auth/bloc/auth_bloc.dart';
import '../bookings/presentation/booking_list/bookings_list_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../service_categories/presentation/screens/service_category_screen.dart';

class BottomNavigation extends StatefulWidget {
  final HomeNavigationArg arg;

  const BottomNavigation({Key? key, required this.arg}) : super(key: key);

  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  bool showSearch = false;
  bool isFav = false;
  // team code JVD8BYFAC4 JVD8BYFAC4

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      isFav = false;
    });
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: AppColors.zimkeyOrange,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  );

  List<Widget> _children = List.empty(growable: true);

  Widget disableAccount() {
    return Center(
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height / 1,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.zimkeyBodyOrange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/icons/newIcons/information.svg'),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Account has been temporarily  disabled by the zimkey team!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Your account has been disabled by the zimkey team.if any queries please contact us',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    BlocProvider.of<AuthBloc>(context).add(GetUserDetails());
    _children = [
      const HomeScreen(),
      const ServiceCategoryScreen(),
      BookingsListScreen(
        tabIndex: widget.arg.bookingTabIndex,
      ),
      const ProfileScreen(),
    ];
    _currentIndex = widget.arg.bottomNavIndex;

    super.initState();
  }

  ValueNotifier<User> userInfoNotifier =
      ValueNotifier(User(id: "", name: "", phone: "", email: ""));
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, authState) {
            if (authState is AuthUserDataLoadedState) {
              userInfoNotifier.value = User(
                  id: authState.userDetailsResponse.me.id,
                  name: authState.userDetailsResponse.me.name,
                  phone: authState.userDetailsResponse.me.phone,
                  email: authState.userDetailsResponse.me.email,
                  disableAccount: authState
                      .userDetailsResponse.me.customerDetails.disableAccount);
            }
          },
          builder: (context, state) {
            return ValueListenableBuilder(
                valueListenable: userInfoNotifier,
                builder: (context, data, child) {
                  return AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      // transitionBuilder: (Widget child,Animation<double> animation)=>ScaleTransition(scale: animation,child: child,),
                      child: data.disableAccount == true
                          ? _currentIndex == _children.length - 1
                              ? _children.last
                              : disableAccount()
                          : _children[_currentIndex]);
                });
          },
        ),
        bottomNavigationBar: customBottomNav(),
      ),
    );
  }

  Widget customBottomNav() {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        color: AppColors.zimkeyBottomNavGrey,
        boxShadow: [
          BoxShadow(
            color: AppColors.zimkeyLightGrey,
            offset: Offset(2.0, -3.0),
            blurRadius: 5.0,
          )
        ],
      ),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          bottomNavButton(
            'assets/images/graphics/hometab_icon.svg',
            // 'assets/images/icons/logoNoFill.svg',
            0,
          ),
          bottomNavButton(
            'assets/images/icons/newIcons/grid.svg',
            1,
          ),
          bottomNavButton(
            'assets/images/icons/newIcons/bookingsTab.svg',
            2,
          ),
          bottomNavButton(
            'assets/images/user.svg',
            3,
          ),
        ],
      ),
    );
  }

  Widget bottomNavButton(String icon, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextButton(
        style: flatButtonStyle,
        onPressed: () async {
          onTabTapped(index);
          // await getUserMutation();
        },
        child: SvgPicture.asset(
          icon,
          height: index == 0 ? 29 : 24,
          colorFilter: ColorFilter.mode(
              _currentIndex == index
                  ? AppColors.zimkeyOrange
                  : AppColors.zimkeyDarkGrey,
              BlendMode.srcIn),
        ),
      ),
    );
  }
}

class ComingSoon extends StatelessWidget {
  const ComingSoon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black38),
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SizedBox(
            height: 200, width: 250, child: HelperWidgets.lottieComingSoon()),
      ),
    );
  }
}
