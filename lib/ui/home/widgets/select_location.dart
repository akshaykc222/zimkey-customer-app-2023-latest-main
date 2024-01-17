import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';

class SetupLocation extends StatefulWidget {
  const SetupLocation({super.key});

  @override
  SetupLocationState createState() => SetupLocationState();
}

class SetupLocationState extends State<SetupLocation> {
  var selectedArea;

  List<int> selectedItems = [];
  String preselectedValue = 'Select Your Area';
  bool isSelectedArea = false;

  bool checked = false;

  // Location location = new Location();
  // bool _serviceEnabled;
  // PermissionStatus _permissionGranted;
  // Position position;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _currentAddress = "";

  bool isLoading = false;
  bool showErrorAlert = false;
  List<DropdownMenuItem> dropdownItems = [];
  bool showSearchList = false;
  List<String> dummy = [];
  bool showEmptyError = false;
  bool showDropdown = false;

  bool filledAddCity = false;

  @override
  void initState() {
    super.initState();
    selectedArea.name = '';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.zimkeyWhite,
            elevation: 0,
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            color: AppColors.zimkeyWhite,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Where are you located?',
                          style: TextStyle(
                            fontSize: 24,
                            color: AppColors.zimkeyBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Find the highest rated professionals nearest to you.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.zimkeyDarkGrey,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'City',
                            style: TextStyle(
                              color: AppColors.zimkeyDarkGrey.withOpacity(0.3),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            // showGeneralDialog(
                            //     barrierColor: Colors.black.withOpacity(0.5),
                            //     transitionBuilder: (context, a1, a2, widget) {
                            //       return Transform.scale(
                            //         scale: a1.value,
                            //         child: Opacity(
                            //           opacity: a1.value,
                            //           child: AlertDialog(
                            //             contentTextStyle: TextStyle(
                            //               color: AppColors.zimkeyBlack,
                            //               fontWeight: FontWeight.normal,
                            //               fontSize: 15,
                            //             ),
                            //             titlePadding: EdgeInsets.symmetric(
                            //               vertical: 0,
                            //               horizontal: 0,
                            //             ),
                            //             contentPadding: EdgeInsets.symmetric(
                            //               vertical: 15,
                            //               horizontal: 0,
                            //             ),
                            //             shape: RoundedRectangleBorder(
                            //               borderRadius: BorderRadius.all(
                            //                 Radius.circular(20.0),
                            //               ),
                            //             ),
                            //             title: Container(
                            //               padding: EdgeInsets.only(
                            //                   left: 20, right: 15, top: 15),
                            //               child: Row(
                            //                 mainAxisAlignment:
                            //                 MainAxisAlignment
                            //                     .spaceBetween,
                            //                 children: [
                            //                   Expanded(
                            //                     child: Text(
                            //                       'Oops!',
                            //                       style: TextStyle(
                            //                         color: AppColors.zimkeyDarkGrey,
                            //                         fontWeight:
                            //                         FontWeight.bold,
                            //                         fontSize: 16,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   InkWell(
                            //                     onTap: () {
                            //                       Get.back();
                            //                       setState(() {
                            //                         _addCity.clear();
                            //                         filledAddCity = false;
                            //                       });
                            //                     },
                            //                     child: Container(
                            //                       width: 30,
                            //                       height: 30,
                            //                       decoration: BoxDecoration(
                            //                         color: AppColors.zimkeyDarkGrey
                            //                             .withOpacity(0.1),
                            //                         shape: BoxShape.circle,
                            //                       ),
                            //                       child: Icon(
                            //                         Icons.clear,
                            //                         color: AppColors.zimkeyDarkGrey,
                            //                         size: 16,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             content: Container(
                            //               padding: EdgeInsets.only(
                            //                   left: 20,
                            //                   right: 20,
                            //                   bottom: 10),
                            //               child: new Column(
                            //                 mainAxisSize: MainAxisSize.min,
                            //                 crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //                 children: <Widget>[
                            //                   Text(
                            //                     'Let us know if your city is not here yet and help us grow. Add your city here.',
                            //                   ),
                            //                   SizedBox(
                            //                     height: 10,
                            //                   ),
                            //                   Container(
                            //                     // margin: EdgeInsets.symmetric(
                            //                     //     horizontal: 20),
                            //                     decoration: BoxDecoration(
                            //                       border: Border(
                            //                         bottom: BorderSide(
                            //                           color: AppColors.zimkeyDarkGrey2
                            //                               .withOpacity(0.1),
                            //                         ),
                            //                       ),
                            //                     ),
                            //                     child: Row(
                            //                       mainAxisAlignment:
                            //                       MainAxisAlignment
                            //                           .spaceBetween,
                            //                       children: [
                            //                         Icon(
                            //                           Icons.location_city,
                            //                           color: AppColors.zimkeyDarkGrey
                            //                               .withOpacity(0.5),
                            //                         ),
                            //                         SizedBox(
                            //                           width: 5,
                            //                         ),
                            //                         Expanded(
                            //                           child: TextFormField(
                            //                             controller: _addCity,
                            //                             textCapitalization:
                            //                             TextCapitalization
                            //                                 .sentences,
                            //                             maxLength: 45,
                            //                             textInputAction:
                            //                             TextInputAction
                            //                                 .done,
                            //                             keyboardType:
                            //                             TextInputType
                            //                                 .text,
                            //                             style: TextStyle(
                            //                               fontSize: 14,
                            //                             ),
                            //                             onChanged: (val) {
                            //                               if (val.isEmpty)
                            //                                 setState(() {
                            //                                   filledAddCity =
                            //                                   false;
                            //                                 });
                            //                               else
                            //                                 setState(() {
                            //                                   filledAddCity =
                            //                                   true;
                            //                                 });
                            //                             },
                            //                             decoration:
                            //                             InputDecoration(
                            //                               contentPadding:
                            //                               EdgeInsets
                            //                                   .symmetric(
                            //                                 vertical: 10,
                            //                               ),
                            //                               counterText: "",
                            //                               hintText:
                            //                               'Add city',
                            //                               hintStyle:
                            //                               TextStyle(
                            //                                 fontSize: 14,
                            //                                 color: AppColors.zimkeyDarkGrey
                            //                                     .withOpacity(
                            //                                     0.3),
                            //                               ),
                            //                               fillColor:
                            //                               AppColors.zimkeyOrange,
                            //                               focusColor:
                            //                               AppColors.zimkeyOrange,
                            //                               enabledBorder:
                            //                               InputBorder
                            //                                   .none,
                            //                               focusedBorder:
                            //                               InputBorder
                            //                                   .none,
                            //                             ),
                            //                           ),
                            //                         ),
                            //                         InkWell(
                            //                           onTap: () {
                            //                             setState(() {
                            //                               _addCity.clear();
                            //                               filledAddCity =
                            //                               false;
                            //                             });
                            //                           },
                            //                           child: Icon(
                            //                             Icons.clear,
                            //                             color: filledAddCity
                            //                                 ? AppColors.zimkeyDarkGrey
                            //                                 : AppColors.zimkeyWhite,
                            //                             size: 16,
                            //                           ),
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             actions: <Widget>[
                            //               new InkWell(
                            //                 onTap: () {
                            //                   Get.back();
                            //                   setState(() {
                            //                     _addCity.clear();
                            //                     filledAddCity = false;
                            //                   });
                            //                 },
                            //                 child: Container(
                            //                   decoration: BoxDecoration(
                            //                     borderRadius:
                            //                     BorderRadius.circular(20),
                            //                   ),
                            //                   padding: EdgeInsets.symmetric(
                            //                       horizontal: 10,
                            //                       vertical: 10),
                            //                   child: Text(
                            //                     'Submit',
                            //                     style: TextStyle(
                            //                       color: AppColors.zimkeyOrange,
                            //                       fontWeight: FontWeight.bold,
                            //                       fontSize: 15,
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //     transitionDuration: const Duration(milliseconds: 250),
                            //     barrierDismissible: true,
                            //     barrierLabel: '',
                            //     context: context,
                            //     );
                          },
                          child: Container(
                            // height: 55,
                            decoration: BoxDecoration(
                              color: AppColors.zimkeyLightGrey,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            alignment: Alignment.center,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Cochin',
                                    style: TextStyle(
                                      color: AppColors.zimkeyDarkGrey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 22,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Area',
                                style: TextStyle(
                                  color: AppColors.zimkeyDarkGrey.withOpacity(0.3),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            // if (fbState.areaList == null ||
                            //     fbState.areaList.isEmpty ||
                            //     fbState.areaList.value != null &&
                            //         fbState.areaList.value.isEmpty) {
                            //   setState(() {
                            //     isLoading = true;
                            //   });
                            //   await getAreasMutation();
                            //   setState(() {
                            //     isLoading = false;
                            //   });
                            // } else
                            // Navigator.push(
                            //   context,
                            //   PageTransition(
                            //     type: PageTransitionType.bottomToTop,
                            //     child: SearchLocation(
                            //         updateSearchArea: (Area area) {
                            //           setState(() {
                            //             selectedArea = area;
                            //             // fbState.setUserLoc(area.name);
                            //             // fbState.setUserLoc(selectedArea.name);
                            //           });
                            //         }),
                            //     duration: Duration(milliseconds: 300),
                            //   ),
                            // );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.zimkeyLightGrey,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 13, bottom: 13),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Select an area for service",
                                    style: TextStyle(
                                      color: AppColors.zimkeyDarkGrey,
                                      fontWeight: selectedArea != null && selectedArea.name.isNotEmpty
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedArea = null;
                                    });
                                  },
                                  child: Icon(
                                    (selectedArea != null &&
                                            selectedArea.name != null &&
                                            selectedArea.name.isNotEmpty)
                                        ? Icons.clear
                                        : Icons.keyboard_arrow_down_rounded,
                                    size: (selectedArea != null &&
                                            selectedArea.name != null &&
                                            selectedArea.name.isNotEmpty)
                                        ? 18
                                        : 22,
                                    color: (selectedArea != null &&
                                            selectedArea.name != null &&
                                            selectedArea.name.isNotEmpty)
                                        ? AppColors.zimkeyOrange
                                        : AppColors.zimkeyDarkGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          //select area is not mandatory
                          if (selectedArea != null && selectedArea.name.isNotEmpty) Get.offAllNamed('/dashboard');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width - 250,
                          padding: const EdgeInsets.symmetric(
                            vertical: 17,
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
                            'Next',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.zimkeyWhite,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showErrorAlert)
          AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sorry!',
                  style: TextStyle(
                    color: AppColors.zimkeyBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      showErrorAlert = false;
                    });
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: AppColors.zimkeyDarkGrey.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.clear,
                      color: AppColors.zimkeyDarkGrey,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'We aren\'t servicing your area yet. Would you like us to let you know when we\'re there?\n\nLike to check out our services anyway?',
                  style: TextStyle(
                    color: AppColors.zimkeyBlack,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  // TO DO - call mutation here!!!!!!!!!!!
                  Get.offAllNamed('/dashboard');
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 10.0, bottom: 10),
                  child: Text(
                    ' Skip to Services',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.zimkeyOrange,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
