import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:recase/recase.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/strings.dart';
import '../../../../data/model/booking_slot/booking_slots_response.dart';
import '../../../../data/model/bookings/booking_list_response.dart';
import '../../../../navigation/route_generator.dart';
import '../../../../utils/helper/helper_functions.dart';
import '../../../../utils/helper/helper_widgets.dart';
import '../../bloc/bookings_bloc.dart';
import '../booking_list/bookings_list_screen.dart';

class BookingsTab extends StatefulWidget {
  final String status;

  const BookingsTab({Key? key, required this.status}) : super(key: key);

  @override
  State<BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends State<BookingsTab> {
  final List<GlobalKey> _keys = List.empty(growable: true);

  final Color _backgroundOn = AppColors.zimkeyBodyOrange;
  final Color _backgroundOff = AppColors.zimkeyWhite;

  ValueNotifier<List<Datum>> openBookingListNotifier =
      ValueNotifier(List.empty(growable: true));
  ValueNotifier<List<Datum>> bookingListNotifier =
      ValueNotifier(List.empty(growable: true));
  ValueNotifier<List<Datum>> completedBookingListNotifier =
      ValueNotifier(List.empty(growable: true));
  ValueNotifier<List<Datum>> pendingBookingListNotifier =
      ValueNotifier(List.empty(growable: true));
  ValueNotifier<List<Datum>> cancelledBookingListNotifier =
      ValueNotifier(List.empty(growable: true));
  ValueNotifier<int> currentIndexNotifier = ValueNotifier(0);
  ValueNotifier<int> pageNumber = ValueNotifier(1);
  ValueNotifier<bool> fullPageLoaded = ValueNotifier(false);
  ScrollController listViewScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BookingsBloc>(context).add(LoadBookingList(
        bookingListArg: BookingListArg(
            pageNumber: pageNumber.value,
            pageSize: 10,
            status: widget.status)));

    listViewScrollController.addListener(() {
      if (listViewScrollController.position.pixels ==
          listViewScrollController.position.maxScrollExtent) {
        if (!fullPageLoaded.value) {
          BlocProvider.of<BookingsBloc>(context).add(LoadBookingList(
              bookingListArg: BookingListArg(
                  pageNumber: pageNumber.value,
                  pageSize: 10,
                  status: widget.status)));
        }
      }
    });
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
    return BlocConsumer<BookingsBloc, BookingsState>(
      listener: (BuildContext context, BookingsState bookingsState) {
        if (bookingsState is BookingListLoadedState) {
          bookingListNotifier.value = List.empty(growable: true);
          if (bookingsState.bookingListResponse.getUserBookingServiceItems
              .pageInfo.hasNextPage) {
            pageNumber.value = bookingsState.bookingListResponse
                .getUserBookingServiceItems.pageInfo.nextPage;
          } else {
            fullPageLoaded.value = true;
          }

          debugPrint(bookingsState
              .bookingListResponse.getUserBookingServiceItems.data.length
              .toString());
          for (var element in bookingsState
              .bookingListResponse.getUserBookingServiceItems.data) {
            bookingListNotifier.value.add(element);
          }
        }
      },
      builder: (context, bookingsState) {
        if (bookingsState is BookingsLoadingState) {
          return Center(
            child: HelperWidgets.progressIndicator(),
          );
        } else if (bookingsState is BookingListLoadedState) {
          return bookingWidget(status: widget.status);
        } else {
          return Container();
        }
      },
    );
  }

  Widget bookingWidget({required String status}) {
    return LiquidPullToRefresh(
      // key: refreshIndicatorKey,
      color: AppColors.zimkeyOrange,
      showChildOpacityTransition: false,
      onRefresh: () async {
        BlocProvider.of<BookingsBloc>(context).add(LoadBookingList(
            bookingListArg:
                BookingListArg(pageNumber: 1, pageSize: 50, status: status)));
        final Completer<void> completer = Completer<void>();
        Timer(const Duration(seconds: 2), () {
          completer.complete();
        });
        return completer.future.then<void>((_) {});
        // return BlocProvider.of<HomeBloc>(context).add(LoadHome());
      },
      springAnimationDurationInMilliseconds: 600,
      child: ValueListenableBuilder(
        valueListenable: bookingListNotifier,
        builder: (BuildContext context, value, Widget? child) {
          return value.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: [
                      for (Datum item in value) bookingItemWidget(status, item),
                    ],
                  ),
                )
              : ListView(
                  children: [
                    emptyBookingWidget(status),
                  ],
                );
        },
      ),
    );
  }

  Widget bookingItemWidget(String status, Datum item) {
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, RouteGenerator.singleBookingDetailScreen,
                  arguments: BookingDetailScreenArg(
                    id: item.id,
                    fromPaymentPending: false,
                  ))
              .then((value) => BlocProvider.of<BookingsBloc>(context).add(
                  LoadBookingList(
                      bookingListArg: BookingListArg(
                          pageNumber: 1, pageSize: 50, status: status)))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.zimkeyLightGrey,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 6),
              child: item.bookingService.service.icon.url.isEmpty
                  ? SvgPicture.asset(
                      'assets/images/icons/img_icon.svg',
                      height: 35,
                      width: 35,
                    )
                  : Image.network(
                      Strings.mediaUrl + item.bookingService.service.icon.url,
                      height: 35,
                      width: 35,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ReCase(item.bookingService.service.name).originalText,
                    style: TextStyle(
                      color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Wrap(
                      children: [
                        Text(
                          '${item.startDateTime.day}-${item.startDateTime.month}-${item.startDateTime.year}',
                          style: const TextStyle(
                            color: AppColors.zimkeyDarkGrey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          ' | ${HelperFunctions.filterTimeSlot(GetServiceBookingSlot(start: item.startDateTime, end: item.endDateTime, available: false))}',
                          style: const TextStyle(
                            color: AppColors.zimkeyDarkGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //
            //   Container(
            //     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            //     decoration: BoxDecoration(
            //       color: AppColors.zimkeyGreen.withOpacity(0.4),
            //     ),
            //     child: Text(
            //       'Cancelled',
            //       style: TextStyle(
            //         fontSize: 11,
            //         color: AppColors.zimkeyDarkGrey,
            //         // fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            //   InkWell(
            //     onTap: () async {
            //       //More than a days difference, no need to reschedule
            //       // if (item.bookingDate
            //       //     .isAfter(DateTime.now())) {
            //       //   // setState(() {
            //       //   //   thisBookingItem = item;
            //       //   // });
            //       //   // await generatePendingPayment(item, orderId);
            //       // } else {
            //       //   //same day ------
            //       //   if (item.bookingService.bookingServiceItems.first
            //       //       .startDateTime
            //       //       .difference(DateTime.now())
            //       //       .inHours >=
            //       //       3) {
            //       //     // if more than 3 hrs time difference there, no need to reschedule--
            //       //     setState(() {
            //       //       thisBookingItem = item;
            //       //     });
            //       //     await generatePendingPayment(item, orderId);
            //       //   } else {
            //       //     showCustomDialog(
            //       //         'Oops!',
            //       //         "Looks like your booking for ${item.bookingService.service.name} is in the past.",
            //       //         context,
            //       //         false,
            //       //         null);
            //       //   }
            //       // }
            //     },
            //     child: Container(
            //       padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
            //       child: Text(
            //         'Payment Pending',
            //         style: TextStyle(
            //           fontSize: 11,
            //           color: AppColors.zimkeyOrange,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),

            if (item.bookingServiceItemStatus == "CUSTOMER_APPROVAL_PENDING")
              const Text("Reschedule",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.zimkeyOrange,
                    fontWeight: FontWeight.bold,
                  ))
            else
              SizedBox(),
            item.bookingServiceItemType == "REWORK"
                ? Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.zimkeyOrange),
                    child: HelperWidgets.buildText(
                        text: item.bookingServiceItemType, fontSize: 13),
                  )
                : SizedBox(),

            if (item.bookingServiceItemStatus == "CLOSED")
              GestureDetector(
                onTap: () async {
                  // Navigator.push(
                  //   context,
                  //   PageTransition(
                  //     type: PageTransitionType.rightToLeft,
                  //     child: BookService(
                  //       service: item.bookingService.service,
                  //       bookingItem: item,
                  //       serviceThumb: thisServiceThumb,
                  //     ),
                  //     duration: Duration(milliseconds: 400),
                  //   ),
                  // );
                  Navigator.pushNamed(
                      context, RouteGenerator.serviceDetailsScreen,
                      arguments: item.bookingService.service.id);
                },
                child: const Text(
                  'Book Again',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.zimkeyOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Column(
  //   crossAxisAlignment: CrossAxisAlignment.center,
  //   mainAxisAlignment: MainAxisAlignment.center,
  //   children: [
  //     const Text(
  //       'Not Logged In Yet',
  //       style: TextStyle(
  //         fontWeight: FontWeight.bold,
  //         fontSize: 15,
  //         color: AppColors.zimkeyOrange,
  //       ),
  //     ),
  //     const SizedBox(
  //       height: 15,
  //     ),
  //     const Padding(
  //       padding:
  //       EdgeInsets.symmetric(horizontal: 20),
  //       child: Text(
  //         'Kindly login in or register to book your services.\nAll your bookings will be available here.',
  //         style: TextStyle(
  //           // fontWeight: FontWeight.bold,
  //           fontSize: 13,
  //           color: AppColors.zimkeyDarkGrey,
  //         ),
  //         textAlign: TextAlign.center,
  //       ),
  //     ),
  //     const SizedBox(
  //       height: 30,
  //     ),
  //     Center(
  //       child: InkWell(
  //         onTap: () {
  //           Get.toNamed('/login');
  //         },
  //         child: Container(
  //           margin: const EdgeInsets.only(top: 15),
  //           padding: const EdgeInsets.symmetric(
  //               horizontal: 20, vertical: 15),
  //           decoration: BoxDecoration(
  //             color: AppColors.zimkeyOrange,
  //             borderRadius:
  //             BorderRadius.circular(25),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: AppColors.zimkeyLightGrey
  //                     .withOpacity(0.1),
  //                 blurRadius:
  //                 5.0, // soften the shadow
  //                 spreadRadius:
  //                 1.0, //extend the shadow
  //                 offset: const Offset(
  //                   2.0, // Move to right 10  horizontally
  //                   2.0, // Move to bottom 10 Vertically
  //                 ),
  //               )
  //             ],
  //           ),
  //           child: const Text(
  //             'Login to Proceed',
  //             style: TextStyle(
  //               color: AppColors.zimkeyWhite,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 13,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   ],
  // ),
  // Column(
  //   crossAxisAlignment: CrossAxisAlignment.center,
  //   mainAxisAlignment: MainAxisAlignment.center,
  //   children: <Widget>[
  //     Text(
  //       'Oops!',
  //       style: TextStyle(
  //         color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
  //         fontWeight: FontWeight.bold,
  //         fontSize: 18,
  //       ),
  //       textAlign: TextAlign.center,
  //     ),
  //     const SizedBox(
  //       height: 20,
  //     ),
  //     const Text(
  //       'Kindly register to make a booking.',
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //         fontSize: 14,
  //       ),
  //     ),
  //     const SizedBox(
  //       height: 20,
  //     ),
  //     InkWell(
  //       onTap: () {
  //         setState(() {
  //           Get.offAllNamed('/login');
  //         });
  //       },
  //       child: Container(
  //         alignment: Alignment.center,
  //         width: MediaQuery.of(context).size.width - 200,
  //         padding: const EdgeInsets.symmetric(
  //             vertical: 15, horizontal: 10),
  //         decoration: BoxDecoration(
  //           color: AppColors.zimkeyOrange,
  //           borderRadius: BorderRadius.circular(30),
  //           boxShadow: [
  //             BoxShadow(
  //               color: AppColors.zimkeyLightGrey.withOpacity(0.1),
  //               blurRadius: 5.0, // soften the shadow
  //               spreadRadius: 2.0, //extend the shadow
  //               offset: const Offset(
  //                 1.0, // Move to right 10  horizontally
  //                 1.0, // Move to bottom 10 Vertically
  //               ),
  //             )
  //           ],
  //         ),
  //         child: const Text(
  //           'Register',
  //           style: TextStyle(
  //             color: AppColors.zimkeyWhite,
  //             fontSize: 16,
  //           ),
  //         ),
  //       ),
  //     ),
  //   ],
  // )

  Widget emptyBookingWidget(String status) {
    return Container(
      height: MediaQuery.of(context).size.height / 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // color: zimkeyLightGrey,
            height: MediaQuery.of(context).size.height / 2.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No $status services.',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Book a service from our ',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.zimkeyBlack,
                          ),
                        ),
                        TextSpan(
                          text: '\'Services\' ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.zimkeyOrange,
                          ),
                          // recognizer: TapGestureRecognizer()
                          //   ..onTap = () {
                          //     widget.updateTab(1);
                          //   },
                        ),
                        TextSpan(
                          text: 'page.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.zimkeyBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SvgPicture.asset(
                  'assets/images/icons/newIcons/information.svg',
                  // height: 100,
                  // width: 100,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
