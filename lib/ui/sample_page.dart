// import 'dart:async';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:page_transition/page_transition.dart';
// import '../locationSetup/searchLocation.dart';
// import '../models/appModel.dart';
// import '../models/bookingModel.dart';
// import '../models/servicesModel.dart';
// import '../models/userModel.dart';
// import '../services/bookService.dart';
// import '../services/services.dart';
// import '../shared/globalMutations.dart';
// import '../shared/globals.dart';
// import '../shared/gqlQueries.dart';
// import '../shared/loadingIndicator.dart';
// import '../theme.dart';
// import 'popuplarServices.dart';
// import 'searchServicePage.dart';
//
// class HomePage extends StatefulWidget {
//   final Function updateTab;
//
//   const HomePage({
//     Key? key,
//     required this.updateTab,
//   }) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _bannerIndex = 0;
//   bool isloading = false;
//   // Outside build method
//   PageController controller = PageController();
//   GlobalKey<ScaffoldState> _key = GlobalKey();
//
//
//   bool showpincodeError = false;
//
//   PageController _bannerController = PageController();
//   bool showSearch = false;
//   Area selectedArea = Area();
//   List<Area> areaList = [];
//
//   List<BookingTax> bookingTaxes = [];
//   List<AllServices> homeServices = [];
//   List<AllServices> popularServices = [];
//   List<ServiceCategory> allServiceCategories = [];
//   List<Banners> homeBanners = [];
//   Timer _timer;
//
//   @override
//   void initState() {
//     //Home Banner Automate----
//     Timer _timer = Timer.periodic(
//       Duration(seconds: 5),
//           (Timer timer) {
//         if (_bannerIndex < (homeBanners.length - 1)) {
//           _bannerIndex++;
//         } else {
//           _bannerIndex = 0;
//         }
//         if (_bannerController != null)
//           if(_bannerController.hasClients) {
//             _bannerController.animateToPage(
//               _bannerIndex,
//               duration: Duration(milliseconds: 450),
//               curve: Curves.easeIn,
//             );
//           }
//       },
//     );
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _bannerController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       // top: true,
//       child: Query(
//           options: QueryOptions(
//             document: gql(getAreas),
//           ),
//           builder: (
//               QueryResult result, {
//                 VoidCallback refetch,
//                 FetchMore fetchMore,
//               }) {
//             if (result.isLoading)
//               return Center(child: sharedLoadingIndicator());
//             else if (result.isNotLoading &&
//                 result.data != null &&
//                 result.data['getAreas'] != null) {
//               areaList.clear();
//               for (Map item in result.data['getAreas']) {
//                 Area temp;
//
//                 temp = Area.fromJson(item);
//                 areaList.add(temp);
//               }
//               fbState.setAreaList(areaList);
//               //set default area selection
//               // if (fbState.user != null &&
//               //     fbState.user.value != null &&
//               //     fbState.user.value.customerDetails != null &&
//               //     fbState.user.value.customerDetails.defaultAddress != null &&
//               //     fbState.user.value.customerDetails.defaultAddress.areaId !=
//               //         null)
//               //   for (Area areas in areaList) {
//               //     if (areas.id ==
//               //         fbState.user.value.customerDetails.defaultAddress.areaId)
//               //       fbState.setUserLoc(areas.name);
//               //   }
//               getCMSContentMutation();
//             }
//             return Query(
//                 options: QueryOptions(
//                   document: gql(getServiceCategories),
//                   fetchPolicy: FetchPolicy.noCache,
//                 ),
//                 builder: (
//                     QueryResult resultServices, {
//                       VoidCallback refetch,
//                       FetchMore fetchMore,
//                     }) {
//                   if (resultServices.isLoading)
//                     return Center(child: sharedLoadingIndicator());
//                   else if (resultServices.isNotLoading &&
//                       resultServices.data != null &&
//                       resultServices.data['getServiceCategories'] != null) {
//                     allServiceCategories.clear();
//                     for (Map item
//                     in resultServices.data['getServiceCategories']) {
//                       ServiceCategory temp;
//                       temp = ServiceCategory.fromJson(item);
//                       allServiceCategories.add(temp);
//                     }
//                   } else if (resultServices.hasException) {
//                     print('Get serv -- ${resultServices.exception}');
//                   }
//                   return Query(
//                       options: QueryOptions(
//                         document: gql(getPopularServices),
//                         fetchPolicy: FetchPolicy.noCache,
//                       ),
//                       builder: (
//                           QueryResult result2, {
//                             VoidCallback refetch,
//                             FetchMore fetchMore,
//                           }) {
//                         if (result2.isLoading)
//                           return Center(child: sharedLoadingIndicator());
//                         else if (result2.isNotLoading &&
//                             result2.data != null &&
//                             result2.data['getServices'] != null) {
//                           popularServices.clear();
//                           for (Map item in result2.data['getServices']) {
//                             AllServices temp;
//                             temp = AllServices.fromJson(item);
//                             popularServices.add(temp);
//                           }
//                           fbState.setPopularServices(popularServices);
//                         } else if (result2.hasException) {
//                           print(
//                               'Get pop serv exception .. ${result2.exception}');
//                         }
//                         return Query(
//                             options: QueryOptions(
//                               document: gql(getBookingTaxes),
//                             ),
//                             builder: (
//                                 QueryResult result3, {
//                                   VoidCallback refetch,
//                                   FetchMore fetchMore,
//                                 }) {
//                               if (result3.isLoading)
//                                 return Center(child: sharedLoadingIndicator());
//                               else if (result3.isNotLoading &&
//                                   result3.data != null &&
//                                   result3.data['getBookingTaxes'] != null) {
//                                 // print('get taxes success....');
//                                 bookingTaxes.clear();
//                                 for (Map item
//                                 in result3.data['getBookingTaxes']) {
//                                   BookingTax temp;
//                                   temp = BookingTax.fromJson(item);
//                                   bookingTaxes.add(temp);
//                                 }
//                                 fbState.setBookingTaxes(bookingTaxes);
//                               }
//                               return Query(
//                                   options: QueryOptions(
//                                     document: gql(getLoyaltyPointRates),
//                                   ),
//                                   builder: (
//                                       QueryResult resultPoints, {
//                                         VoidCallback refetch,
//                                         FetchMore fetchMore,
//                                       }) {
//                                     if (resultPoints.isLoading)
//                                       return Center(
//                                           child: sharedLoadingIndicator());
//                                     else if (resultPoints.isNotLoading &&
//                                         resultPoints.data != null &&
//                                         resultPoints
//                                             .data['getLoyaltyPointRates'] !=
//                                             null) {
//                                       // print('get points success....');
//                                       CustomerPointStructure pointStructure =
//                                       CustomerPointStructure.fromJson(
//                                           resultPoints.data[
//                                           'getLoyaltyPointRates']);
//                                       fbState
//                                           .setPointsStructure(pointStructure);
//                                     } else if (resultPoints.hasException) {
//                                       print(
//                                           'get points exception ${resultPoints.exception}');
//                                     }
//                                     return Stack(
//                                       children: [
//                                         Scaffold(
//                                           resizeToAvoidBottomInset: false,
//                                           key: _key,
//                                           backgroundColor: zimkeyWhite,
//                                           body: Container(
//                                             child: Stack(
//                                               children: [
//                                                 Container(
//                                                   child: Column(
//                                                     children: [
//                                                       // appbar
//                                                       Column(
//                                                         children: [
//                                                           InkWell(
//                                                             customBorder:
//                                                             RoundedRectangleBorder(
//                                                               borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                   30.0),
//                                                             ),
//                                                             onTap: () {
//                                                               Navigator.push(
//                                                                 context,
//                                                                 PageTransition(
//                                                                   type: PageTransitionType
//                                                                       .bottomToTop,
//                                                                   child:
//                                                                   SearchLocation(
//                                                                     isFromHome:
//                                                                     true,
//                                                                     updateSearchArea:
//                                                                         (Area
//                                                                     area) {
//                                                                       setState(
//                                                                               () {
//                                                                             selectedArea =
//                                                                                 area;
//                                                                             fbState.setUserLoc(
//                                                                                 area.name);
//                                                                           });
//                                                                       // Get.back();
//                                                                       print(
//                                                                           'updated loc - ${fbState.areaLoc.value}');
//                                                                     },
//                                                                   ),
//                                                                   duration: Duration(
//                                                                       milliseconds:
//                                                                       300),
//                                                                 ),
//                                                                 // MaterialPageRoute(
//                                                                 //   builder:
//                                                                 //       (context) =>
//                                                                 //           SearchLocation(
//                                                                 //     contentText:
//                                                                 //         "Search to select serviceable areas near you.",
//                                                                 //     updateSearchArea:
//                                                                 //         (Area
//                                                                 //             area) {
//                                                                 //       setState(
//                                                                 //           () {
//                                                                 //         selectedArea =
//                                                                 //             area;
//                                                                 //         fbState.setUserLoc(
//                                                                 //             area.name);
//                                                                 //       });
//                                                                 //       print(
//                                                                 //           'updated loc - ${fbState.areaLoc.value}');
//                                                                 //     },
//                                                                 //   ),
//                                                                 // ),
//                                                               );
//                                                             },
//                                                             child: Container(
//                                                               // color: Colors.pink,
//                                                               padding:
//                                                               const EdgeInsets
//                                                                   .symmetric(
//                                                                   vertical:
//                                                                   10.0),
//                                                               child: Row(
//                                                                 crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .center,
//                                                                 mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .center,
//                                                                 children: [
//                                                                   Padding(
//                                                                     padding: const EdgeInsets
//                                                                         .only(
//                                                                         top:
//                                                                         0.0),
//                                                                     child: SvgPicture
//                                                                         .asset(
//                                                                       'assets/images/icons/newIcons/location.svg',
//                                                                       color:
//                                                                       zimkeyOrange,
//                                                                       height:
//                                                                       16,
//                                                                     ),
//                                                                   ),
//                                                                   SizedBox(
//                                                                     width: 2,
//                                                                   ),
//                                                                   Text(
//                                                                     fbState.areaLoc.value ==
//                                                                         null ||
//                                                                         fbState
//                                                                             .areaLoc.value.isEmpty
//                                                                         ? 'Select an area for service'
//                                                                         : fbState
//                                                                         .areaLoc
//                                                                         .value,
//                                                                     style:
//                                                                     TextStyle(
//                                                                       color: zimkeyDarkGrey
//                                                                           .withOpacity(
//                                                                           0.7),
//                                                                       fontSize:
//                                                                       16,
//                                                                       fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           //Search Items
//                                                           Container(
//                                                             margin:
//                                                             EdgeInsets.only(
//                                                                 left: 20,
//                                                                 right: 20,
//                                                                 bottom: 5),
//                                                             padding: EdgeInsets
//                                                                 .symmetric(
//                                                                 horizontal:
//                                                                 20,
//                                                                 vertical:
//                                                                 10),
//                                                             decoration:
//                                                             BoxDecoration(
//                                                               color:
//                                                               zimkeyLightGrey,
//                                                               borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                   30),
//                                                             ),
//                                                             child: InkWell(
//                                                               onTap: () {
//                                                                 setState(() {
//                                                                   showSearch =
//                                                                   true;
//                                                                 });
//                                                               },
//                                                               child: Row(
//                                                                 mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .spaceBetween,
//                                                                 children: [
//                                                                   SvgPicture
//                                                                       .asset(
//                                                                     'assets/images/icons/newIcons/search.svg',
//                                                                     color:
//                                                                     zimkeyDarkGrey,
//                                                                     width: 18,
//                                                                   ),
//                                                                   SizedBox(
//                                                                     width: 10,
//                                                                   ),
//                                                                   Expanded(
//                                                                     child: Text(
//                                                                       'What service are you looking for?',
//                                                                       style:
//                                                                       TextStyle(
//                                                                         color:
//                                                                         zimkeyDarkGrey,
//                                                                         fontSize:
//                                                                         14,
//                                                                         // fontWeight: FontWeight.bold,
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       //body
//                                                       Container(
//                                                         constraints:
//                                                         BoxConstraints(
//                                                           maxHeight:
//                                                           MediaQuery.of(
//                                                               context)
//                                                               .size
//                                                               .height *
//                                                               1.5,
//                                                           minHeight:
//                                                           MediaQuery.of(
//                                                               context)
//                                                               .size
//                                                               .height -
//                                                               300,
//                                                         ),
//                                                         height: MediaQuery.of(
//                                                             context)
//                                                             .size
//                                                             .height -
//                                                             210,
//                                                         child: ListView(
//                                                           shrinkWrap: true,
//                                                           children: [
//                                                             SizedBox(
//                                                               height: 5,
//                                                             ),
//                                                             Query(
//                                                                 options: QueryOptions(
//                                                                     document: gql(
//                                                                         getBanners),
//                                                                     variables: {
//                                                                       "getAll":
//                                                                       true
//                                                                     }),
//                                                                 builder: (QueryResult
//                                                                 resultBanner,
//                                                                     {VoidCallback
//                                                                     refetch,
//                                                                       FetchMore
//                                                                       fetchMore}) {
//                                                                   if (resultBanner
//                                                                       .isLoading)
//                                                                     return Center(
//                                                                         child:
//                                                                         sharedLoadingIndicator());
//                                                                   else if (resultBanner
//                                                                       .isNotLoading &&
//                                                                       resultBanner
//                                                                           .data !=
//                                                                           null &&
//                                                                       resultBanner
//                                                                           .data['getBanners'] !=
//                                                                           null) {
//                                                                     // print(
//                                                                     //     'getBanners success....');
//                                                                     homeBanners
//                                                                         .clear();
//                                                                     for (Map item
//                                                                     in resultBanner
//                                                                         .data['getBanners']) {
//                                                                       Banners
//                                                                       temp =
//                                                                       Banners.fromJson(
//                                                                           item);
//                                                                       homeBanners
//                                                                           .add(
//                                                                           temp);
//                                                                     }
//                                                                     fbState.setHomeBanners(
//                                                                         homeBanners);
//                                                                   }
//                                                                   return bannerWidget();
//                                                                 }),
//                                                             SizedBox(
//                                                               height: 10,
//                                                             ),
//                                                             if (homeBanners !=
//                                                                 null &&
//                                                                 homeBanners
//                                                                     .isNotEmpty)
//                                                               Container(
//                                                                 width: MediaQuery.of(
//                                                                     context)
//                                                                     .size
//                                                                     .width,
//                                                                 child: Column(
//                                                                   children: [
//                                                                     customPageViewIndicators(
//                                                                       _bannerController,
//                                                                       homeBanners
//                                                                           .length,
//                                                                       true,
//                                                                       8,
//                                                                       dotColor:
//                                                                       zimkeyOrange,
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             SizedBox(
//                                                               height: 10,
//                                                             ),
//                                                             Container(
//                                                               margin: EdgeInsets
//                                                                   .symmetric(
//                                                                   horizontal:
//                                                                   20),
//                                                               padding: EdgeInsets
//                                                                   .symmetric(
//                                                                   horizontal:
//                                                                   20,
//                                                                   vertical:
//                                                                   10),
//                                                               height: 130,
//                                                               width: double
//                                                                   .infinity,
//                                                               decoration:
//                                                               BoxDecoration(
//                                                                 // color: zimkeyBodyOrange,
//                                                                 color:
//                                                                 zimkeyLightGrey,
//                                                                 borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                     10),
//                                                               ),
//                                                               child: Row(
//                                                                 children: [
//                                                                   Expanded(
//                                                                     child:
//                                                                     Container(
//                                                                       child:
//                                                                       Column(
//                                                                         crossAxisAlignment:
//                                                                         CrossAxisAlignment.start,
//                                                                         mainAxisAlignment:
//                                                                         MainAxisAlignment.center,
//                                                                         children: [
//                                                                           Container(
//                                                                             margin:
//                                                                             EdgeInsets.only(bottom: 3),
//                                                                             child:
//                                                                             Text(
//                                                                               '-  Lorem ipsum dolor sit amet, ',
//                                                                               style: TextStyle(
//                                                                                 fontSize: 12,
//                                                                                 color: zimkeyDarkGrey,
//                                                                               ),
//                                                                               // textAlign: TextAlign.center,
//                                                                             ),
//                                                                           ),
//                                                                           Container(
//                                                                             margin:
//                                                                             EdgeInsets.only(bottom: 3),
//                                                                             child:
//                                                                             Text(
//                                                                               '-  Sed do eiusmod tempor  ',
//                                                                               style: TextStyle(
//                                                                                 fontSize: 12,
//                                                                                 color: zimkeyDarkGrey,
//                                                                               ),
//                                                                               // textAlign: TextAlign.center,
//                                                                             ),
//                                                                           ),
//                                                                           Container(
//                                                                             margin:
//                                                                             EdgeInsets.only(bottom: 3),
//                                                                             child:
//                                                                             Text(
//                                                                               '-  Quis nostrud exercitation ',
//                                                                               style: TextStyle(
//                                                                                 fontSize: 12,
//                                                                                 fontWeight: FontWeight.normal,
//                                                                                 color: zimkeyDarkGrey,
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                           Container(
//                                                                             margin:
//                                                                             EdgeInsets.only(bottom: 3),
//                                                                             child:
//                                                                             Text(
//                                                                               '-  Sed do eiusmod tempor  ',
//                                                                               style: TextStyle(
//                                                                                 fontSize: 12,
//                                                                                 color: zimkeyDarkGrey,
//                                                                               ),
//                                                                               // textAlign: TextAlign.center,
//                                                                             ),
//                                                                           )
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                   SizedBox(
//                                                                     width: 10,
//                                                                   ),
//                                                                   Container(
//                                                                     padding:
//                                                                     EdgeInsets.all(
//                                                                         10),
//                                                                     decoration: BoxDecoration(
//                                                                         color: zimkeyOrange.withOpacity(
//                                                                             0.2),
//                                                                         borderRadius:
//                                                                         BorderRadius.circular(20)),
//                                                                     child: SvgPicture
//                                                                         .asset(
//                                                                       'assets/images/icons/newIcons/vaccine.svg',
//                                                                       color:
//                                                                       zimkeyOrange,
//                                                                       height:
//                                                                       70,
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                             SizedBox(
//                                                               height: 15,
//                                                             ),
//                                                             //Home Services----------
//                                                             Query(
//                                                                 options:
//                                                                 QueryOptions(
//                                                                   document: gql(
//                                                                       getHomeServices),
//                                                                   fetchPolicy:
//                                                                   FetchPolicy
//                                                                       .noCache,
//                                                                 ),
//                                                                 builder: (
//                                                                     QueryResult
//                                                                     resultHomeServ, {
//                                                                       VoidCallback
//                                                                       refetch,
//                                                                       FetchMore
//                                                                       fetchMore,
//                                                                     }) {
//                                                                   if (resultHomeServ
//                                                                       .isLoading)
//                                                                     return Center(
//                                                                         child:
//                                                                         sharedLoadingIndicator());
//                                                                   else if (resultHomeServ.isNotLoading && resultHomeServ.data != null && resultHomeServ.data['getServices'] != null) {
//                                                                     // print(
//                                                                     //     'home services success....');
//                                                                     homeServices.clear();
//                                                                     for (Map item in resultHomeServ.data['getServices']) {
//                                                                       AllServices temp;
//                                                                       temp = AllServices.fromJson(item);
//                                                                       homeServices.add(temp);
//                                                                     }
//                                                                     fbState.setHomeServices(
//                                                                         homeServices);
//                                                                   }
//                                                                   return Container(
//                                                                     padding: EdgeInsets.only(
//                                                                         left:
//                                                                         13,
//                                                                         right:
//                                                                         10),
//                                                                     child: Wrap(
//                                                                       alignment:
//                                                                       WrapAlignment
//                                                                           .spaceBetween,
//                                                                       children: [
//                                                                         for (AllServices homeSer
//                                                                         in homeServices)
//                                                                           gridServiceItem(
//                                                                               homeSer),
//                                                                       ],
//                                                                     ),
//                                                                   );
//                                                                 }),
//                                                             SizedBox(
//                                                               height: 15,
//                                                             ),
//                                                             if (homeServices !=
//                                                                 null &&
//                                                                 homeServices
//                                                                     .isNotEmpty)
//                                                               Center(
//                                                                 child:
//                                                                 GestureDetector(
//                                                                   onTap: () {
//                                                                     setState(
//                                                                             () {
//                                                                           widget
//                                                                               .updateTab(
//                                                                               1);
//                                                                         });
//                                                                   },
//                                                                   child: Text(
//                                                                     'View All',
//                                                                     style:
//                                                                     TextStyle(
//                                                                       color:
//                                                                       zimkeyOrange,
//                                                                       // fontSize: 18,
//                                                                       fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             SizedBox(
//                                                               height: 15,
//                                                             ),
//                                                             //Popular Services--------
//                                                             if (popularServices !=
//                                                                 null &&
//                                                                 popularServices
//                                                                     .isNotEmpty)
//                                                               PopularServices(
//                                                                 headingText:
//                                                                 'Popular Services',
//                                                               ),
//                                                             SizedBox(
//                                                               height: 30,
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         if (showSearch)
//                                           SearchServicePage(
//                                             allServiceCategories:
//                                             allServiceCategories,
//                                             goback: () {
//                                               setState(
//                                                     () {
//                                                   showSearch = false;
//                                                 },
//                                               );
//                                             },
//                                             updateTab: (int index) {
//                                               setState(() {
//                                                 showSearch = false;
//                                                 widget.updateTab(index);
//                                               });
//                                             },
//                                           ),
//                                         if (isloading)
//                                           Center(
//                                               child: sharedLoadingIndicator()),
//                                       ],
//                                     );
//                                   });
//                             });
//                       });
//                 });
//           }),
//     );
//   }
//
//   Widget locationDialog() {
//     return StatefulBuilder(
//         builder: (BuildContext context, StateSetter mystate) {
//           return Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 10.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             showpincodeError = false;
//                           });
//                           Get.back();
//                         },
//                         child: Icon(
//                           Icons.clear,
//                           color: zimkeyWhite,
//                           size: 20,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: zimkeyWhite,
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(15),
//                     ),
//                   ),
//                   padding: EdgeInsets.only(left: 20, right: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         'Find the highest rated professionals nearest to you.',
//                         style: TextStyle(
//                           fontSize: 13,
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: zimkeyOrange,
//                           ),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () {
//                                   // _controller.close();
//                                   Navigator.push(
//                                     context,
//                                     PageTransition(
//                                       type: PageTransitionType.bottomToTop,
//                                       child: SearchLocation(
//                                         contentText:
//                                         "Find the highest rated professionals nearest to you.",
//                                         updateSearchArea: (Area area) {
//                                           mystate(() {
//                                             selectedArea = area;
//                                             fbState.setUserLoc(area.name);
//                                           });
//                                           Get.back();
//                                           print(
//                                               'updated loc - ${fbState.areaLoc.value}');
//                                         },
//                                       ),
//                                       duration: Duration(milliseconds: 300),
//                                     ),
//                                   );
//                                 },
//                                 child: Row(
//                                   children: [
//                                     SvgPicture.asset(
//                                       'assets/images/icons/newIcons/location.svg',
//                                       height: 20,
//                                       color: zimkeyOrange,
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Expanded(
//                                       child: Text(
//                                         fbState.areaLoc.value == null ||
//                                             fbState.areaLoc.value.isEmpty
//                                             ? 'Select Your Area'
//                                             : fbState.areaLoc.value,
//                                         style: TextStyle(
//                                           color: zimkeyDarkGrey,
//                                           fontSize: 15,
//                                           // fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             if ((selectedArea != null &&
//                                 selectedArea.name != null) ||
//                                 (fbState.areaLoc.value != null &&
//                                     fbState.areaLoc.value.isNotEmpty))
//                               InkWell(
//                                 onTap: (() {
//                                   mystate(() {
//                                     selectedArea = null;
//                                     fbState.setUserLoc(null);
//                                   });
//                                 }),
//                                 child: Icon(
//                                   Icons.clear,
//                                   color: zimkeyOrange,
//                                   size: 20,
//                                 ),
//                               )
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }
//
//   Widget gridServiceItem(AllServices service) {
//     String servName = service.name.replaceAll('\n', ' ');
//     String serviceImg = mediaUrl;
//     serviceImg = service.icon != null && service.icon.url != null
//         ? serviceImg + service.icon.url
//         : "";
//     bool isPng = false;
//     if (serviceImg.contains('png')) isPng = true;
//     Widget thisServiceThumb = serviceThumbImg(service);
//     bool isFav = false;
//     if (fbState.user != null &&
//         fbState.user.value != null &&
//         fbState.user.value.customerDetails != null &&
//         fbState.user.value.customerDetails.favoriteServices != null &&
//         fbState.user.value.customerDetails.favoriteServices.isNotEmpty) {
//       for (AllServices favItem
//       in fbState.user.value.customerDetails.favoriteServices) {
//         if (favItem.id == service.id) isFav = true;
//       }
//     }
//     return GestureDetector(
//       onTap: () {
//         // go to service detail page
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BookService(
//               service: service,
//               isFav: isFav,
//               serviceThumb: thisServiceThumb,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: zimkeyGrey,
//           ),
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 2),
//         margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
//         constraints: BoxConstraints(
//           minWidth: MediaQuery.of(context).size.width / 4.8,
//           maxWidth: 95,
//         ),
//         width: MediaQuery.of(context).size.width / 4.8,
//         height: 80,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             serviceImg == null || serviceImg.isEmpty
//                 ? SvgPicture.asset(
//               'assets/images/icons/img_icon.svg',
//               height: 30,
//               width: 30,
//             )
//                 : (isPng)
//                 ? Image.network(
//               serviceImg,
//               height: 40,
//               width: 40,
//             )
//                 : SvgPicture.network(
//               serviceImg,
//               height: 30,
//               width: 30,
//             ),
//             SizedBox(
//               height: 3,
//             ),
//             Center(
//               child: Text(
//                 servName,
//                 style: TextStyle(
//                   fontSize: 11,
//                   // fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//                 // maxLines: 2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget bannerWidget() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 10),
//       height: 130,
//       child: Stack(
//         children: [
//           PageView(
//             controller: _bannerController,
//             physics: BouncingScrollPhysics(),
//             children: [
//               for (Banners bannerItem in homeBanners)
//                 homeBanneritem(bannerItem),
//             ],
//             onPageChanged: (val) {
//               setState(() {
//                 _bannerIndex = val;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget homeBanneritem(Banners bannerItem) {
//     String bannerImg = bannerItem.media.url;
//     String urlImg = mediaUrl;
//     bannerImg = bannerImg != null ? urlImg + bannerImg : "";
//     if (bannerImg != null && bannerImg.isNotEmpty)
//       return CachedNetworkImage(
//         placeholder: (context, url) => Center(
//           child: Container(
//             height: double.infinity,
//             margin: EdgeInsets.only(right: 10, left: 10),
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: zimkeyLightGrey,
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//         imageBuilder: (context, imageProvider) => Container(
//           height: 40,
//           width: 40,
//           margin: EdgeInsets.only(right: 10, left: 10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             image: DecorationImage(
//               image: imageProvider,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         imageUrl: bannerImg,
//         fadeInCurve: Curves.easeIn,
//         fadeOutCurve: Curves.easeInOutBack,
//       );
//     else
//       return Container(
//         height: 40,
//         width: 40,
//         margin: EdgeInsets.only(right: 10, left: 10),
//         decoration: BoxDecoration(
//           color: zimkeyLightGrey,
//           borderRadius: BorderRadius.circular(10),
//         ),
//       );
//   }
// }
