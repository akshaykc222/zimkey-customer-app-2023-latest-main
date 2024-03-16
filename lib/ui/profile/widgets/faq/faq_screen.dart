import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/colors.dart';
import '../../../../data/model/profile/faq/faq_response.dart';
import '../../../../data/provider/profile_provider.dart';
import '../../../../utils/helper/helper_widgets.dart';
import 'cubit/faq_cubit.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => FaqScreenState();
}

class FaqScreenState extends State<FaqScreen> with TickerProviderStateMixin {
  TextEditingController subjectController = TextEditingController();
  final FocusNode _subjectNode = FocusNode();
  ValueNotifier<bool> isFilled = ValueNotifier(false);
  ValueNotifier<List<GetFaq>> searchList =
      ValueNotifier(List.empty(growable: true));
  List<GetFaq> faqList = List.empty(growable: true);
  ValueNotifier<List<String>> searchFaqCategories =
      ValueNotifier(List.empty(growable: true));
  List<String> faqCategories = List.empty(growable: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subjectController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    String newValue = subjectController.text;
    searchItem(newValue); // Update your search based on the new value
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FaqCubit(
          profileProvider: RepositoryProvider.of<ProfileProvider>(context))
        ..loadFAQ(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.zimkeyWhite,
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(
            color: AppColors.zimkeyBlack,
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.chevron_left,
              color: AppColors.zimkeyDarkGrey,
              size: 30,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30.0),
            child: Container(
              color: AppColors.zimkeyWhite,
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FAQs',
                    style: TextStyle(
                      color: AppColors.zimkeyBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  // SizedBox(
                  //   height: 3,
                  // ),
                  // Text(
                  //   'Browse through our FAQ to find answeres to your queries',
                  //   style: TextStyle(
                  //     color: AppColors.zimkeyDarkGrey,
                  //     fontSize: 12,
                  //   ),
                  // ),
                  const SizedBox(
                    height: 7,
                  ),
                  Divider(
                    color: AppColors.zimkeyDarkGrey2.withOpacity(0.5),
                    height: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: AppColors.zimkeyWhite,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: BoxDecoration(
                    color: AppColors.zimkeyLightGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/images/icons/newIcons/search.svg',
                        color: AppColors.zimkeyDarkGrey,
                        height: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: TextFormField(
                          focusNode: _subjectNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          maxLength: 200,
                          controller: subjectController,
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
                            hintText: 'Search a faq keyword',
                            fillColor: AppColors.zimkeyOrange,
                            focusColor: AppColors.zimkeyOrange,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          // onChanged: (val) => searchItem(val),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: isFilled,
                        builder: (BuildContext context, value, Widget? child) {
                          return Visibility(
                            visible: value,
                            child: InkWell(
                              onTap: () {
                                subjectController.clear();
                                searchItem("");
                              },
                              child: const SizedBox(
                                width: 30,
                                child: Center(
                                  child: Icon(
                                    Icons.clear,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocConsumer<FaqCubit, FaqState>(
                  listener: (context, state) {
                    if (state is FaqLoadedState) {
                      faqList.clear();
                      faqList.addAll(state.faqResponse.getFaqs);
                      faqCategories.clear();
                      List<GetFaq> tempFaqList = List.empty(growable: true);
                      List<String> tempFaqCategoryList =
                          List.empty(growable: true);

                      for (GetFaq item in faqList) {
                        tempFaqList.add(item);
                        if (!faqCategories.contains(item.category)) {
                          tempFaqCategoryList.add(item.category);
                        }
                      }
                      faqCategories.clear();
                      faqCategories.addAll(tempFaqCategoryList);
                      searchFaqCategories.value.clear();
                      searchFaqCategories.value =
                          tempFaqCategoryList.toSet().toList();
                      searchList.value = tempFaqList;
                    }
                  },
                  builder: (context, state) {
                    if (state is FaqLoadingState) {
                      return Center(child: HelperWidgets.progressIndicator());
                    } else if (state is FaqLoadedState) {
                      return ValueListenableBuilder(
                          valueListenable: searchFaqCategories,
                          builder: (BuildContext context, faqCategoryValue,
                              Widget? child) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                    faqCategoryValue.length,
                                    (faqCategoryIndex) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: Text(
                                                faqCategoryValue[
                                                    faqCategoryIndex],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  // fontWeight: FontWeight.bold,
                                                  color: AppColors.zimkeyOrange
                                                      .withOpacity(1),
                                                ),
                                              ),
                                            ),
                                            ValueListenableBuilder(
                                              valueListenable: searchList,
                                              builder: (BuildContext context,
                                                  value, Widget? child) {
                                                return Column(
                                                    children: List.generate(
                                                        value.length,
                                                        (index) =>
                                                            FAQItemWidget(
                                                              faqItem:
                                                                  value[index],
                                                              thisMixin: this,
                                                              faqCatg:
                                                                  faqCategoryValue[
                                                                      faqCategoryIndex],
                                                            )));
                                              },
                                            ),
                                          ],
                                        )));
                          });
                    }

                    return const SizedBox(
                      height: 20,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void searchItem(String val) {
    searchList.value.clear();
    searchFaqCategories.value.clear();
    List<GetFaq> tempFaqList = List.empty(growable: true);
    List<String> tempFaqCategoryList = List.empty(growable: true);
    if (val.isNotEmpty) {
      isFilled.value = true;
      for (GetFaq item in faqList) {
        if (item.question.toLowerCase().contains(val.toLowerCase()) ||
            item.answer.toLowerCase().contains(val.toLowerCase())) {
          tempFaqList.add(item);
          if (!tempFaqCategoryList.contains(item.category)) {
            tempFaqCategoryList.add(item.category);
          }
        }
      }

      searchFaqCategories.value = tempFaqCategoryList;
      searchList.value = tempFaqList;
    } else {
      tempFaqList.addAll(faqList);
      tempFaqCategoryList.addAll(faqCategories);
      isFilled.value = false;
      searchFaqCategories.value = tempFaqCategoryList;
      searchList.value = tempFaqList;
    }
  }
}

// List<FAQItemModel> generateItems(int numberOfItems) {
//   return List.generate(numberOfItems, (int index) {
//     return FAQItemModel(
//       headerValue: 'FAQ Topic/ Question',
//       expandedValue:
//           'Details for FAQ goes here.\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
//     );
//   });
// }

class FAQItemWidget extends StatefulWidget {
  final GetFaq faqItem;
  final FaqScreenState thisMixin;
  final String faqCatg;

  const FAQItemWidget({
    Key? key,
    required this.faqItem,
    required this.thisMixin,
    required this.faqCatg,
  }) : super(key: key);

  @override
  State<FAQItemWidget> createState() => _FAQItemWidgetState();
}

class _FAQItemWidgetState extends State<FAQItemWidget> {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: widget.thisMixin,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );
    //---
  }

  _toggleContainer(GetFaq faqItem) {
    setState(() {
      faqItem.isExpanded = !faqItem.isExpanded;
    });
    if (faqItem.isExpanded) {
      _controller.forward();
    } else {
      _controller.animateBack(0, duration: const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.faqCatg.toLowerCase() == widget.faqItem.category.toLowerCase()) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            color: widget.faqItem.isExpanded
                ? Colors.grey[100]
                : AppColors.zimkeyWhite,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[100]!,
                blurRadius: 6.0, // soften the shadow
                spreadRadius: 2.0, //extend the shadow
                offset: const Offset(
                  1.0, // Move to right 10  horizontally
                  1.0, // Move to bottom 10 Vertically
                ),
              )
            ],
            border: Border.all(
              color: AppColors.zimkeyLightGrey,
            )),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _toggleContainer(widget.faqItem),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.faqItem.question,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.zimkeyDarkGrey.withOpacity(1),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.zimkeyDarkGrey,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
            if (widget.faqItem.isExpanded)
              SizeTransition(
                sizeFactor: _animation,
                axis: Axis.vertical,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    widget.faqItem.answer,
                    style: TextStyle(
                      // fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: AppColors.zimkeyDarkGrey.withOpacity(1),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      return const SizedBox(
        height: 0,
      );
    }
  }
}

class FAQItemModel {
  String expandedValue;
  String headerValue;
  bool isExpanded;

  FAQItemModel({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });
}
