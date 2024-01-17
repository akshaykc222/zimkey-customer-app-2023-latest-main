import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:customer/constants/strings.dart';
import 'package:customer/data/provider/services_provider.dart';
import 'package:customer/ui/service_categories/data/bloc/service_category_bloc.dart';
import 'package:customer/ui/service_categories/model/service_category_response.dart';
import 'package:customer/utils/helper/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../../constants/colors.dart';
import '../../../../navigation/route_generator.dart';
import '../../../auth/bloc/auth_bloc.dart';

class ServiceCategoryScreen extends StatefulWidget {
  const ServiceCategoryScreen({Key? key}) : super(key: key);

  @override
  State<ServiceCategoryScreen> createState() => _ServiceCategoryScreenState();
}

class _ServiceCategoryScreenState extends State<ServiceCategoryScreen> {
  ValueNotifier<bool> showFavourites = ValueNotifier(false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceCategoryBloc(servicesProvider: RepositoryProvider.of<ServicesProvider>(context))
        ..add(LoadServiceCategories()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.zimkeyOrange,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: ValueListenableBuilder(
              valueListenable: showFavourites,
              builder: (BuildContext context, bool value, Widget? child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          value ? 'Favourites' : 'Services',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.zimkeyWhite,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        child: SvgPicture.asset(
                          value
                              ? 'assets/images/icons/newIcons/heartFilled.svg'
                              : 'assets/images/icons/newIcons/heart.svg',
                          height: 20,
                          color: AppColors.zimkeyWhite,
                        ),
                        onTap: () {
                          if (value) {
                            BlocProvider.of<ServiceCategoryBloc>(context).add(LoadServiceCategories());
                          } else {
                            BlocProvider.of<AuthBloc>(context).add(GetUserDetails());
                          }
                          showFavourites.value = !value;
                        })
                  ],
                );
              }),
          // bottom: PreferredSize(
          //   preferredSize: Size.fromHeight(25.0),
          //   child: Container(
          //     padding: EdgeInsets.only(left: 10, right: 18, bottom: 35),
          //     width: double.infinity,
          //     child:   ),
          // ),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthLoadingState) {
              return Center(
                child: HelperWidgets.progressIndicator(),
              );
            }
            return BlocBuilder<ServiceCategoryBloc, ServiceCategoryState>(
              builder: (context, serviceCategoryState) {
                if (serviceCategoryState is ServiceCategoryLoadedState) {
                  var categoryList = serviceCategoryState.serviceCategoryResponse.getServiceCategories;
                  return ValueListenableBuilder(
                    valueListenable: showFavourites,
                    builder: (BuildContext context, bool showFav, Widget? child) {
                      return LiquidPullToRefresh(
                        // key: refreshIndicatorKey,
                        color: AppColors.zimkeyOrange,
                        showChildOpacityTransition: false,
                        onRefresh: () async {
                          BlocProvider.of<ServiceCategoryBloc>(context).add(LoadServiceCategories());
                          final Completer<void> completer = Completer<void>();
                          Timer(const Duration(seconds: 2), () {
                            completer.complete();
                          });
                          return completer.future.then<void>((_) {});
                          // return BlocProvider.of<HomeBloc>(context).add(LoadHome());
                        },
                        springAnimationDurationInMilliseconds: 600,
                        child: Container(
                          width: double.infinity,
                          color: AppColors.zimkeyWhite,
                          height: MediaQuery.of(context).size.height,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                showFav
                                    ? const SizedBox()
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List.generate(
                                            categoryList.length,
                                            (index) => serviceSection(
                                                  context,
                                                  categoryList[index].name,
                                                  categoryList[index].services,
                                                ))),
                                authState is AuthUserDataLoadedState && showFav
                                    ? SizedBox(
                                        height: MediaQuery.of(context).size.height / 3,
                                        child: authState.userDetailsResponse.me.customerDetails.favoriteServices.isEmpty
                                            ? InkWell(
                                                onTap: () {
                                                  // widget.updateFav(!widget.isFav);
                                                },
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/images/icons/newIcons/heart-add.svg',
                                                        color: AppColors.zimkeyOrange,
                                                        height: 50,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      const Text(
                                                        'No favourite services added.',
                                                        style: TextStyle(
                                                            // color: AppColors.zimkeyOrange,
                                                            // fontSize: 16,
                                                            // fontWeight: FontWeight.bold,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),authState.userDetailsResponse.me.customerDetails.favoriteServices
                                                      .length<=3?
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                        child: Row(
                                                          children: List.generate(authState.userDetailsResponse.me.customerDetails.favoriteServices
                                                            .length, (index) => Padding(
                                                              padding: const EdgeInsets.only(right: 5.0,),
                                                              child: serviceTile(
                                                              context,
                                                              authState.userDetailsResponse.me.customerDetails
                                                                  .favoriteServices[index],
                                                              true),
                                                            )),),
                                                      )
                                                      :
                                                  Wrap(
                                                    spacing: 5,
                                                    runSpacing: 5,
                                                    alignment: WrapAlignment.start,
                                                    crossAxisAlignment: WrapCrossAlignment.start,
                                                    runAlignment: WrapAlignment.start,
                                                    children: List.generate(
                                                      authState.userDetailsResponse.me.customerDetails.favoriteServices
                                                          .length,
                                                      (index) => serviceTile(
                                                          context,
                                                          authState.userDetailsResponse.me.customerDetails
                                                              .favoriteServices[index],
                                                          true),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (serviceCategoryState is ServiceCategoryLoadingState) {
                  return Center(
                    child: HelperWidgets.progressIndicator(),
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget serviceSection(
    BuildContext context,
    String serviceCatg,
    List<Service> services,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Text(
                serviceCatg,
                style: TextStyle(
                  color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Wrap(
            spacing: 5,
            runSpacing: 5,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.center,
            children: List.generate(services.length, (index) => serviceTile(context, services[index], false))),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget serviceTile(BuildContext context, dynamic service, bool fromFavourite) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, RouteGenerator.serviceDetailsScreen, arguments: service.id).then(
          (value) => !fromFavourite
              ? BlocProvider.of<ServiceCategoryBloc>(context).add(LoadServiceCategories())
              : BlocProvider.of<AuthBloc>(context).add(GetUserDetails())),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.zimkeyLightGrey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        // constraints: const BoxConstraints(
        //   maxHeight: 90,
        //   minHeight: 60,
        //   maxWidth: 90,
        //   minWidth: 60,
        // ),
        // color: AppColors.zimkeyLightGrey,
        width: 80,
        height: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            service.icon.url.isEmpty
                ? SvgPicture.asset(
                    'assets/images/icons/img_icon.svg',
                    height: 30,
                    width: 30,
                  )
                : Image.network(Strings.mediaUrl + service.icon.url, height: 30, width: 30),
            const SizedBox(
              height: 7,
            ),
            AutoSizeText(
              service.name,
              maxFontSize: 11,
              minFontSize: 9,
              style: const TextStyle(
                color: AppColors.zimkeyDarkGrey,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
