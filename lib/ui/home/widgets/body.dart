import 'dart:async';

import 'package:customer/navigation/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../constants/assets.dart';
import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../../data/model/home/home_response.dart';
import '../../../utils/helper/helper_functions.dart';
import '../../../utils/helper/helper_widgets.dart';
import '../../../utils/object_factory.dart';
import '../bloc/home_bloc.dart';
import 'build_carousel_banner.dart';
import 'build_services.dart';
import 'build_static_banner.dart';
import 'popular_services.dart';

class HomeBody extends StatefulWidget {
  final HomeLoaded homeLoadedState;

  const HomeBody({
    Key? key,
    required this.homeLoadedState,
  }) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  static PageController bannerController = PageController();
  static ValueNotifier<bool> showSearchLocation = ValueNotifier(false);
  static ValueNotifier<String> selectedLoc = ValueNotifier("");

  void showLocationSelection(bool value) {
    showSearchLocation.value = value;
  }

  void selectedUserLoc({required GetArea selectedArea}) {
    selectedLoc.value = selectedArea.name!;
    ObjectFactory().prefs.setSelectedLocation(location: selectedLoc.value);
    ObjectFactory().prefs.setSelectedLocationModel(location: selectedArea);
    // pinCodeListNotifier.value = pinCodeList;
  }

  @override
  void initState() {
    super.initState();
    selectedLoc.value = ObjectFactory().prefs.getSelectedLocation() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            locationSelection(context),
            searchService(),
            Expanded(
              child: LiquidPullToRefresh(
                // key: refreshIndicatorKey,
                color: AppColors.zimkeyOrange,
                showChildOpacityTransition: false,
                onRefresh: () async {
                  BlocProvider.of<HomeBloc>(context).add(LoadHome());
                  final Completer<void> completer = Completer<void>();
                  Timer(const Duration(seconds: 2), () {
                    completer.complete();
                  });
                  return completer.future.then<void>((_) {});
                  // return BlocProvider.of<HomeBloc>(context).add(LoadHome());
                },
                springAnimationDurationInMilliseconds: 600,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 5),
                    BuildCarouselBanner(
                        banners: widget.homeLoadedState.homeResponse
                            .getCombinedHome.getBanners!),
                    const SizedBox(height: 10),
                    widget.homeLoadedState.homeResponse.getCombinedHome
                                .getHomeContent !=
                            null
                        ? BuildStaticBanners(
                            homeContent: widget.homeLoadedState.homeResponse
                                .getCombinedHome.getHomeContent!)
                        : Container(),
                    const SizedBox(height: 15),
                    //Home Services----------
                    BuildServices(state: widget.homeLoadedState),
                    const SizedBox(height: 15),
                    buildViewAllService(),
                    const SizedBox(height: 15),
                    // Popular Services--------
                    PopularService(
                        popularService: widget.homeLoadedState.homeResponse
                            .getCombinedHome.getPopularServices!),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
        HelperWidgets.searchLocationScreen(
            areaList:
                widget.homeLoadedState.homeResponse.getCombinedHome.getAreas!,
            showLocationSelection: showLocationSelection,
            selectUserLoc: selectedUserLoc,
            valueNotifier: showSearchLocation)
      ],
    );
  }

  Align buildViewAllService() {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () => HelperFunctions.navigateToServices(context),
        child: const Text(
          'View All',
          style: TextStyle(
            color: AppColors.zimkeyOrange,
            // fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget searchService() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RouteGenerator.searchServiceScreen);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.zimkeyLightGrey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              Assets.iconSearch,
              colorFilter: const ColorFilter.mode(
                  AppColors.zimkeyDarkGrey, BlendMode.srcIn),
              width: 18,
            ),
            const SizedBox(
              width: 10,
            ),
            const Expanded(
              child: Text(
                Strings.serviceLookingFor,
                style: TextStyle(
                  color: AppColors.zimkeyDarkGrey,
                  fontSize: 14,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell locationSelection(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onTap: () => showLocationSelection(true),
      child: Container(
        // color: Colors.pink,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(left: 12.0),
            //   child: Hero(
            //     tag: 'logo',
            //     child: SvgPicture.asset(
            //       'assets/images/graphics/zimkeyLogo.svg',
            //       height: 15.0,
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(
                top: 0.0,
              ),
              child: SvgPicture.asset(
                Assets.iconLocation,
                colorFilter: const ColorFilter.mode(
                    AppColors.zimkeyOrange, BlendMode.srcIn),
                fit: BoxFit.contain,
                height: 16,
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            ValueListenableBuilder(
              valueListenable: selectedLoc,
              builder: (BuildContext context, String value, Widget? child) {
                return Text(
                  value.isNotEmpty ? value : Strings.selectUserLoc,
                  style: TextStyle(
                    color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
