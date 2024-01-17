import 'package:customer/data/model/services/single_service_response.dart';
import 'package:customer/navigation/route_generator.dart';
import 'package:customer/ui/search_services/data/cubit/search_service_cubit.dart';
import 'package:customer/utils/helper/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recase/recase.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../data/provider/services_provider.dart';
import 'model/search_service_response.dart';

class SearchServiceScreen extends StatefulWidget {
  const SearchServiceScreen({
    Key? key,
  }) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchServiceScreen> {
  final TextEditingController _searchController = new TextEditingController();

  // List<AllServices> mostSearchedServices = [];
  ValueNotifier<bool> showMostSearched = ValueNotifier(true);
  ValueNotifier<bool> isFilled = ValueNotifier(false);

  final FocusNode _serachNode = FocusNode();
  bool isFilledAddService = false;
  bool showEmptyError = false;
  bool showedefaultServices = true;

  // List<AllServices> searchResults = [];

  bool isLoading = false;

  @override
  void initState() {
    BlocProvider.of<SearchServiceCubit>(context).searchService("");
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        isFilled.value = true;
      } else {
        isFilled.value = true;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.zimkeyWhite,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_outlined,
            color: AppColors.zimkeyDarkGrey,
            size: 28,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.zimkeyWhite,
        automaticallyImplyLeading: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            child: //search field
                Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              decoration: BoxDecoration(
                color: AppColors.zimkeyLightGrey,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/icons/newIcons/search.svg',
                    color: AppColors.zimkeyDarkGrey,
                    width: 18,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      focusNode: _serachNode,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 30,
                      controller: _searchController,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        counterText: '',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: AppColors.zimkeyDarkGrey.withOpacity(0.4),
                          fontWeight: FontWeight.normal,
                        ),
                        hintText: 'What service are you looking for?',
                        hintMaxLines: 2,
                        fillColor: AppColors.zimkeyOrange,
                        focusColor: AppColors.zimkeyOrange,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if(value.isEmpty){
                          showMostSearched.value= true;
                        }else{
                          showMostSearched.value = false;
                        }
                        BlocProvider.of<SearchServiceCubit>(context).searchService(value);
                        // // searchResults.clear();
                        // if (value.isNotEmpty) {
                        //   for (ServiceCategory item
                        //   in widget.allServiceCategories) {
                        //     for (AllServices servi in item.services) {
                        //       if (servi.name.toLowerCase().contains(
                        //           _searchController.text.toLowerCase())) {
                        //         setState(() {
                        //           showedefaultServices = false;
                        //           showEmptyError = false;
                        //           searchResults.add(servi);
                        //           searchResults =
                        //               Set.of(searchResults).toList();
                        //         });
                        //       } else {
                        //         if (searchResults.isEmpty) {
                        //           setState(() {
                        //             showEmptyError = true;
                        //             showedefaultServices = false;
                        //           });
                        //         }
                        //       }
                        //     }
                        //   }
                        // } else {
                        //   setState(() {
                        //     showedefaultServices = true;
                        //     showEmptyError = false;
                        //     isFilled = false;
                        //     // searchResults = List.from(widget.serviceCatgList);
                        //   });
                        // }
                        // print('!!!!!!!!!searchlist ${searchResults.length}');
                      },
                    ),
                  ),
                    ValueListenableBuilder(
                      valueListenable: isFilled,
                      builder: (BuildContext context, bool value, Widget? child) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              showedefaultServices = true;

                              _searchController.clear();
                              isFilled.value = false;
                              // searchResults.clear();
                              // searchResults = List.from(widget.serviceCatgList);
                              showEmptyError = false;
                            });
                          },
                          child: const Icon(
                            Icons.clear,
                            size: 18,
                          ),
                        );
                      },

                    )
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchServiceCubit, SearchServiceState>(
        builder: (context, state) {
          if (state is SearchServiceLoadedState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              color: AppColors.zimkeyWhite,
              height: MediaQuery.of(context).size.height,
              child:state.searchServiceResponse.getServices.isNotEmpty? ListView(
                children:[
                  ValueListenableBuilder(
                    valueListenable: showMostSearched,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return Visibility(
                        visible: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                          child: HelperWidgets.buildText(text: "Most Searched Services",fontWeight: FontWeight.bold,fontSize: 16),
                        ),
                      );
                    },

                  ),
                  ...List.generate(state.searchServiceResponse.getServices.length, (index) => serviceTile(state.searchServiceResponse.getServices[index]))
                ],
              ):emptySearchResults(),
            );
          } else if (state is SearchServiceLoadingState) {
           return Center(
              child: HelperWidgets.progressIndicator(),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget emptySearchResults() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Oh no! We aren\’t offering this service.',
            style: TextStyle(
              color: AppColors.zimkeyDarkGrey,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          Image.asset('assets/images/graphics/emptySearch.png'),
        ],
      ),
    );
  }

  Widget defaultServiceSection() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            // if (mostSearchedServices.isNotEmpty)
            const Center(
              child: Text(
                'Most searched services',
                style: TextStyle(
                  color: AppColors.zimkeyOrange,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: const Wrap(
                spacing: 5,
                runSpacing: 5,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.center,
                children: [
                  // for (AllServices serv in fbState.homeServices)
                  //   defaultserviceTile(context, serv),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Widget defaultserviceTile(BuildContext context, AllServices service) {
  //   // AllServices thisService;
  //   bool isFav = false;
  //   if (fbState.user != null &&
  //       fbState.user.value != null &&
  //       fbState.user.value.customerDetails != null &&
  //       fbState.user.value.customerDetails.favoriteServices.isNotEmpty) {
  //     for (AllServices favItem
  //     in fbState.user.value.customerDetails.favoriteServices) {
  //       if (favItem.id == service.id) isFav = true;
  //     }
  //   }
  //   String serviceImg = mediaUrl;
  //   serviceImg = service.icon != null && service.icon.url != null
  //       ? serviceImg + service.icon.url
  //       : "";
  //   Widget thisServiceThumb = serviceThumbImg(service);
  //   bool isPng = false;
  //   if (serviceImg.contains('png')) isPng = true;
  //   return InkWell(
  //     onTap: () async {
  //       // Navigator.push(
  //       //   context,
  //       //   PageTransition(
  //       //     type: PageTransitionType.rightToLeft,
  //       //     child: BookService(
  //       //       service: service,
  //       //       isFav: isFav,
  //       //       serviceThumb: thisServiceThumb,
  //       //     ),
  //       //     duration: Duration(milliseconds: 400),
  //       //   ),
  //       // );
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(
  //           color: AppColors.zimkeyLightGrey,
  //         ),
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       margin: EdgeInsets.symmetric(vertical: 2),
  //       constraints: BoxConstraints(
  //         maxHeight: 100,
  //         minHeight: 70,
  //         maxWidth: 100,
  //         minWidth: 70,
  //       ),
  //       width: 85,
  //       height: 90,
  //       padding: EdgeInsets.symmetric(horizontal: 3),
  //       // height: 85,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           serviceImg == null || serviceImg.isEmpty
  //               ? SvgPicture.asset(
  //             'assets/images/icons/img_icon.svg',
  //             height: 30,
  //             width: 30,
  //           )
  //               : (isPng)
  //               ? Image.network(
  //             serviceImg,
  //             height: 40,
  //             width: 40,
  //           )
  //               : SvgPicture.network(
  //             serviceImg,
  //             height: 30,
  //             width: 30,
  //           ),
  //           SizedBox(
  //             height: 5,
  //           ),
  //           Text(
  //             service.name,
  //             style: TextStyle(
  //               color: AppColors.zimkeyDarkGrey,
  //               fontSize: 10,
  //             ),
  //             textAlign: TextAlign.center,
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget serviceTile(SearchService service) {
    // bool isFav = false;
    // if (fbState.user != null &&
    //     fbState.user.value != null &&
    //     fbState.user.value.customerDetails != null &&
    //     fbState.user.value.customerDetails.favoriteServices.isNotEmpty) {
    //   for (AllServices favItem
    //   in fbState.user.value.customerDetails.favoriteServices) {
    //     if (favItem.id == service.id) isFav = true;
    //   }
    // }
    // Widget thisServiceThumb = serviceThumbImg(service);
    return InkWell(
      onTap: () =>
  Navigator.pushNamed(context, RouteGenerator.serviceDetailsScreen, arguments: service.id),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: AppColors.zimkeyDarkGrey.withOpacity(0.1),
          ),
        )),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        // color: Colors.grey,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            service.icon.url.isEmpty
                ? SvgPicture.asset(
              Assets.iconDummyServices,
              height: MediaQuery.of(context).size.width / 12.8,
              width: MediaQuery.of(context).size.width / 12.8,
            )
                : !(service.icon.url.contains('svg'))
                ? Image.network(
              Strings.mediaUrl + service.icon.url,
              height: MediaQuery.of(context).size.width / 12.8,
              width: MediaQuery.of(context).size.width / 12.8,
            )
                : SvgPicture.network(
              Strings.mediaUrl + service.icon.url,
              height: MediaQuery.of(context).size.width / 12.8,
              width: MediaQuery.of(context).size.width / 12.8,
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Text(
                ReCase(service.name).titleCase,
                style: TextStyle(
                  color: AppColors.zimkeyDarkGrey,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
              size: 23,
            ),
          ],
        ),
      ),
    );
  }
}
