import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../../data/model/home/home_response.dart';
import '../../../utils/helper/helper_functions.dart';
import '../../../utils/helper/helper_widgets.dart';
import '../../../utils/object_factory.dart';
import '../../home/bloc/home_bloc.dart';


class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {

  bool isSelectedArea = false;

  bool checked = false;
  // Location location = new Location();
  // bool _serviceEnabled;
  // PermissionStatus _permissionGranted;
  // Position position;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static ValueNotifier<bool> showSearchLocation = ValueNotifier(false);
  static ValueNotifier<String> selectedLoc = ValueNotifier("");



  void showLocationSelection(bool value) {
    showSearchLocation.value = value;
  }

  void selectedUserLoc({required GetArea selectedArea}) {
    selectedLoc.value = selectedArea.name!;
    ObjectFactory().prefs.setSelectedLocation(location: selectedLoc.value);
    // pinCodeListNotifier.value = pinCodeList;
  }



  @override
  void initState() {
    super.initState();
    selectedLoc.value = ObjectFactory().prefs.getSelectedLocation()??"";
    BlocProvider.of<HomeBloc>(context).add(LoadCityList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocBuilder<HomeBloc, HomeState>(
  builder: (context, homeState) {
    if(homeState is HomeLoading){
      return Center(child: HelperWidgets.progressIndicator(),);
    }else if( homeState is LocationLoaded) {
      return SafeArea(
        child: Stack(
          children: [
            Container(

              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              color: AppColors.zimkeyWhite,
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
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
                        Container(
                          // height: 55,
                          decoration: BoxDecoration(
                            color: AppColors.zimkeyLightGrey,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          alignment: Alignment.center,
                          child: const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Cochin',
                                  style: TextStyle(
                                    color: AppColors.zimkeyGrey1,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
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
                          onTap: () => showLocationSelection(true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.zimkeyLightGrey,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 13, bottom: 13),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ValueListenableBuilder(
                                    valueListenable: selectedLoc,
                                    builder: (BuildContext context, String value, Widget? child) {
                                     return Text(
                                        value.isNotEmpty ?value: "Select an area for service",
                                        style: const TextStyle(
                                          color: AppColors.zimkeyDarkGrey,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      );
                                    },

                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {});
                                  },
                                  child: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 22,
                                    color: AppColors.zimkeyDarkGrey,
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
                        onTap: () =>HelperFunctions.navigateToHome(context),
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 250,
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
            Positioned(right: 25,top: 25,
                child: GestureDetector(
                  onTap: () =>HelperFunctions.navigateToHome(context),
                  child: SizedBox(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HelperWidgets.buildText(text: Strings.skip,fontWeight: FontWeight.bold,fontSize: 14,color: AppColors.zimkeyDarkGrey2),
                      )),
                )),
            HelperWidgets.searchLocationScreen(areaList: homeState.citiesResponse.getCities.first.areas!,
                showLocationSelection: showLocationSelection,
                selectUserLoc: selectedUserLoc,
                valueNotifier: showSearchLocation)
          ],
        ),
      );
    }else{
      return Container(color: Colors.white,);
    }
  },
),
    );
  }
}
