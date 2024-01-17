import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';


import '../../../../../constants/colors.dart';
import '../../../../../data/model/checkout/checkout_summary_response.dart';
import '../../../../../utils/helper/helper_widgets.dart';
import '../../../cubit/calculate_service_cost_cubit.dart';
import '../bloc/summary_bloc/summary_bloc.dart';

class CouponListingScreen extends StatefulWidget {
  final List<Coupon> couponList;
  final String selectedBillingId;
  final int selectedUnit;

  const CouponListingScreen(
      {Key? key, required this.couponList, required this.selectedUnit, required this.selectedBillingId})
      : super(key: key);

  @override
  State<CouponListingScreen> createState() => _CouponListingScreenState();
}

class _CouponListingScreenState extends State<CouponListingScreen> {
  ValueNotifier<List<Coupon>> couponListNotifier = ValueNotifier(List.empty(growable: true));

  @override
  void initState() {
    super.initState();
    couponListNotifier.value = widget.couponList;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: AppColors.zimkeyOrange,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Apply Coupon',
              style: TextStyle(
                color: AppColors.zimkeyWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(
              color: AppColors.zimkeyWhite,
            ),
            leading: InkWell(
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.zimkeyWhite,
                size: 18,
              ),
              onTap: () => BlocProvider.of<CalculatedServiceCostCubit>(context).showCouponListingScreen(show: false),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
          ),
          body: Container(
            color: AppColors.zimkeyWhite,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - 170,
                  child: ValueListenableBuilder(
                    valueListenable: couponListNotifier,
                    builder: (BuildContext context, list, Widget? child) {
                      return list.isNotEmpty
                          ? SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                    list.length, (index) => couponWidgetItem(list[index], context, index)),
                              ),
                            )
                          : const Center(
                              child: Text(
                                'Empty',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                    },
                  ),
                ),
                // }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget couponWidgetItem(Coupon coupon, BuildContext context, int index) {
    return InkWell(
      onTap: () async {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, top: 5),
        decoration: BoxDecoration(
            color: AppColors.zimkeyWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.zimkeyLightGrey)),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: AppColors.zimkeyLightGrey, borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Coupon Code - ',
                                  style: TextStyle(
                                    color: AppColors.zimkeyOrange,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  coupon.code,
                                  style: const TextStyle(
                                    color: AppColors.zimkeyOrange,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: HelperWidgets.buildText(
                                  text: coupon.description,
                                  color: AppColors.zimkeyDarkGrey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  overflow: null),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HelperWidgets.buildText(
                                  text: 'Minimum amount - ₹${coupon.minOrder}',
                                  color: AppColors.zimkeyDarkGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () => showOrHideTerms(index),
                                  child: HelperWidgets.buildText(
                                    text: 'T&C',
                                    color: AppColors.zimkeyBlue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            if (coupon.canApply) {
                              BlocProvider.of<SummaryBloc>(context).add(LoadCheckoutSummary(
                                  serviceBillingOptionId: widget.selectedBillingId,
                                  units: widget.selectedUnit,
                                  couponCode: coupon.code));
                              BlocProvider.of<CalculatedServiceCostCubit>(context).showCouponListingScreen(show: false);
                            }
                          },
                          child: SizedBox(
                            child: Center(
                              child: HelperWidgets.buildText(
                                text: coupon.couponApplied ? 'Coupon Applied' : 'Apply',
                                color: coupon.canApply || coupon.couponApplied
                                    ? AppColors.zimkeyOrange
                                    : AppColors.zimkeyDarkGrey.withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
                visible: coupon.showTerms,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HelperWidgets.buildText(
                            text: 'Terms And Conditions',
                            color: AppColors.zimkeyDarkGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            onPressed: () => showOrHideTerms(index),
                            icon: const Icon(
                              Icons.close,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Html(data: coupon.terms),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  showOrHideTerms(int index) {
    List<Coupon> tempList = couponListNotifier.value;
    tempList[index].showTerms = !(tempList[index].showTerms);
    couponListNotifier.value = [];
    couponListNotifier.value = tempList;
  }
}
