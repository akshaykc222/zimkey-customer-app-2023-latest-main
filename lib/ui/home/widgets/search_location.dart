import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:recase/recase.dart';

import '../../../constants/assets.dart';
import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../../data/model/home/home_response.dart';

class SearchLocation extends StatefulWidget {
  final String contentText;
  final bool isFromHome;
  final List<GetArea> areaList;
  final Function showLocationSelection;
  final Function({required GetArea selectedArea}) selectedUserLoc;

  const SearchLocation(
      {Key? key,
      required this.areaList,
      required this.contentText,
      required this.isFromHome,
      required this.showLocationSelection,
      required this.selectedUserLoc})
      : super(key: key);

  @override
  SearchLocationState createState() => SearchLocationState();
}

class SearchLocationState extends State<SearchLocation> {
  TextEditingController searchAreaController = TextEditingController();

  ValueNotifier<List<GetArea>> searchResults =
      ValueNotifier(List.empty(growable: true));
  ValueNotifier<List<GetArea>> dropdownItems =
      ValueNotifier(List.empty(growable: true));

  ValueNotifier<bool> showClearIcon = ValueNotifier(false);
  ValueNotifier<bool> tapSearch = ValueNotifier(false);
  ValueNotifier<bool> showEmptyError = ValueNotifier(false);

  // bool showClearIcon = false;
  // bool showEmptyError = false;
  // String selectedArea;
  // bool tapSearch = false;

  @override
  void initState() {
    searchAreaController.text = '';
    // selectedArea = '';
    //initiate dropdon list
    dropdownItems.value.addAll(widget.areaList);
    //duplicate
    searchResults.value = List.from(dropdownItems.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColors.zimkeyWhite,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
                onPressed: () => widget.showLocationSelection(false),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.zimkeyDarkGrey,
                  size: 16,
                )),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.zimkeyLightGrey,
                  borderRadius: BorderRadius.circular(25),
                ),
                // width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      Assets.iconSearch,
                      color: AppColors.zimkeyDarkGrey,
                      width: 18,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(
                          color: AppColors.zimkeyDarkGrey,
                          // fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        controller: searchAreaController,
                        decoration: InputDecoration(
                          fillColor: AppColors.zimkeyOrange,
                          border: InputBorder.none,
                          hintText: Strings.searchAreaHintText,
                          hintStyle: TextStyle(
                            color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                            // fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            showClearIcon.value = true;
                            searchResults.value.clear();
                            searchResults.value = (searchPlace(value));
                          } else {
                            showClearIcon.value = false;
                            searchResults.value.clear();
                            searchResults.value =
                                List.from(dropdownItems.value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ValueListenableBuilder(
                        valueListenable: showClearIcon,
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return value
                              ? IconButton(
                                  onPressed: () {
                                    searchResults.value.clear();
                                    searchResults.value =
                                        List.from(dropdownItems.value);
                                    searchAreaController.clear();
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    size: 16,
                                    color: AppColors.zimkeyDarkGrey,
                                  ),
                                )
                              : const SizedBox();
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: AppColors.zimkeyWhite,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: ValueListenableBuilder(
          valueListenable: searchResults,
          builder: (BuildContext context, List<GetArea> value, Widget? child) {
            return value.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: ListView(
                      children: [
                        if (widget.isFromHome)
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: const Text(
                              Strings.listArea,
                              style: TextStyle(
                                color: AppColors.zimkeyOrange,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        if (widget.contentText.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              widget.contentText,
                              style: const TextStyle(
                                color: AppColors.zimkeyOrange,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        for (GetArea item in value)
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              widget.selectedUserLoc(selectedArea:item);
                              widget.showLocationSelection(false);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 17,
                                ),
                                child: Text(
                                  ReCase(item.name!).titleCase,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.zimkeyDarkGrey
                                        .withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : emptyWidget();
          },
        ),
      ),
    );
  }

  List<GetArea> searchPlace(String searchTerm) {
    return searchTerm.isNumericOnly
        ? dropdownItems.value
            .where((item) => item.pinCodes!.any((element) => element.pinCode!
                .toLowerCase()
                .contains(searchTerm.toLowerCase())))
            .toList()
        : dropdownItems.value
            .where((item) =>
                item.name!.toLowerCase().contains(searchTerm.toLowerCase()))
            .toList();
  }

  Widget emptyWidget() {
    return Container(
      color: AppColors.zimkeyWhite,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      alignment: Alignment.topCenter,
      child: const Text(
        Strings.searchItemEmpty,
        style: TextStyle(
          color: AppColors.zimkeyOrange,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
