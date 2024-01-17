import 'package:customer/ui/bookings/presentation/widgets/bookings_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/colors.dart';
import '../../../../data/model/bookings/booking_list_response.dart';
import '../../bloc/bookings_bloc.dart';

class BookingsListScreen extends StatefulWidget {
  final int tabIndex;
  const BookingsListScreen({Key? key,required this.tabIndex}) : super(key: key);

  @override
  State<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends State<BookingsListScreen> with TickerProviderStateMixin {
  late Animation _colorTweenBackgroundOn;

  // late Animation _colorTweenForegroundOn;
  late TabController _controller;

  // // this will control the animation when a button changes from an off state to an on state
  late AnimationController _animationControllerOn;

  // // this will control the animation when a button changes from an on state to an off state
  // late AnimationController _animationControllerOff;
  // // this will give the background color values of a button when it changes to an on state
  // // Animation _colorTweenBackgroundOff;
  // // this will give the foreground color values of a button when it changes to an on state
  // late Animation _colorTweenForegroundOff;

  final List _tabs = [
    'Open',
    'Completed',
    'Pending',
    'Cancelled',
  ];
  final List statusList = [
    "OPEN",
    "COMPLETED",
    "PENDING",
    "CANCELED",
  ];
  final List<GlobalKey> _keys = List.empty(growable: true);

  final Color _backgroundOn = AppColors.zimkeyBodyOrange;
  final Color _backgroundOff = AppColors.zimkeyWhite;


  ValueNotifier<int> currentIndexNotifier = ValueNotifier(0);


  @override
  void initState() {
    super.initState();
    currentIndexNotifier.value = widget.tabIndex;
    // this creates the controller with 6 tabs (in our case)
    _controller = TabController(vsync: this, length: _tabs.length);
    for (int index = 0; index < _tabs.length; index++) {
      // create a GlobalKey for each Tab
      _keys.add(GlobalKey());
    }

    // // this will execute the function every time there's a swipe animation
    // _controller.animation.addListener(_handleTabAnimation);
    // // this will execute the function every time the _controller.index value changes
    // _controller.addListener(_handleTabChange);
    //
    // _animationControllerOff =
    //     AnimationController(vsync: this, duration: Duration(milliseconds: 75));
    // // so the inactive buttons start in their "final" state (color)
    // _animationControllerOff.value = 1.0;
    // // _colorTweenBackgroundOff =
    // //     ColorTween(begin: _backgroundOn, end: _backgroundOff)
    // //         .animate(_animationControllerOff);
    // _colorTweenForegroundOff =
    //     ColorTween(begin: _foregroundOn, end: _foregroundOff)
    //         .animate(_animationControllerOff);
    //
    _animationControllerOn = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    // // so the inactive buttons start in their "final" state (color)
    // _animationControllerOn.value = 1.0;
    _colorTweenBackgroundOn = ColorTween(begin: _backgroundOff, end: _backgroundOn).animate(_animationControllerOn);
    // _colorTweenForegroundOn =
    //     ColorTween(begin: _foregroundOff, end: _foregroundOn)
    //         .animate(_animationControllerOn);
  }

  // _getForegroundColor(int index) {
  //   // // the same as the above
  //   // if (index == _currentIndex) {
  //   //   return _colorTweenForegroundOn.value;
  //   // } else if (index == _prevControllerIndex) {
  //   //   return _colorTweenForegroundOff.value;
  //   // } else {
  //   //   return _foregroundOff;
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.zimkeyOrange,
          elevation: 5,
          // centerTitle: false,
          title: const Text(
            'Bookings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.zimkeyWhite,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
          // bottom: PreferredSize(
          //   preferredSize: Size.fromHeight(30.0),
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //     width: double.infinity,
          //   ),
          // ),
          // centerTitle: false,
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            // this is the TabBar
            Container(
              decoration: const BoxDecoration(),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int index = 0; index < 4; index++)
                    InkWell(
                      onTap: () {
                        _controller.animateTo(index);
                        currentIndexNotifier.value = index;
                        BlocProvider.of<BookingsBloc>(context).add(LoadBookingList(
                            bookingListArg: BookingListArg(pageNumber: 1, pageSize: 50, status: statusList[index])));
                      },
                      child: ValueListenableBuilder(
                        valueListenable: currentIndexNotifier,
                        builder: (BuildContext context, value, Widget? child) {
                          return AnimatedBuilder(
                            animation: _colorTweenBackgroundOn,
                            builder: (context, child) => Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 4.3,
                              key: _keys[index],
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            _tabs[index],
                                            style: TextStyle(
                                              // get the color of the icon (dependent of its state)
                                              color: value == index ? AppColors.zimkeyOrange : Colors.black,
                                              // color: _getForegroundColor(index),
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  CircleAvatar(
                                      radius: 3,
                                      backgroundColor: value == index ? AppColors.zimkeyOrange : Colors.white),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
                // },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //Tabbarview
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                children: <Widget>[
                  // our Tab Views
                  BookingsTab(status: statusList.first),
                  BookingsTab(status: statusList[1]),
                  BookingsTab(status: statusList[2]),
                  BookingsTab(status: statusList[3]),
                ],
              ),
            ),
            //   },
            // ),
          ],
        ));
  }
}

enum UserBookingsStatusTypeEnum { OPEN, COMPLETED, PENDING, CANCELLED }

class BookingListArg {
  final int pageNumber;
  final int pageSize;
  final String status;

  BookingListArg({required this.pageNumber, required this.pageSize, required this.status});
}
