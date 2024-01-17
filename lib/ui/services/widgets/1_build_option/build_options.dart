import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/colors.dart';
import '../../../../data/model/services/single_service_response.dart';
import '../../cubit/calculate_service_cost_cubit.dart';
import '../../cubit/overview_data_cubit.dart';
import 'widgets/1_build_subservice_selection.dart';
import 'widgets/2_build_billing_options.dart';
import 'widgets/5_build_how_it_works.dart';

ValueNotifier<bool> acceptTerms = ValueNotifier(false);

class BuildServiceOptions extends StatefulWidget {
  final GetService service;

  const BuildServiceOptions({Key? key, required this.service})
      : super(key: key);

  @override
  State<BuildServiceOptions> createState() => _BuildServiceOptionsState();
}

class _BuildServiceOptionsState extends State<BuildServiceOptions> {
  initValues() {
    var b = BlocProvider.of<OverviewDataCubit>(context);
    b.setFurnished(true);
    if (widget.service.room != null &&
        (widget.service.room?.isNotEmpty == true)) {
      try {
        b.selectRoom(widget.service.room!.first);
      } catch (e) {}
    }
    if (widget.service.propertyArea != null &&
        (widget.service.propertyArea?.isNotEmpty == true)) {
      b.selectPropertyArea(
          widget.service.propertyArea!.first, widget.service.billingOptions);
      BlocProvider.of<CalculatedServiceCostCubit>(context).addCurrentUnitHour(
          unitPrice: widget.service.billingOptions.first.unitPrice.unitPrice,
          billingId: widget.service.billingOptions.first.id,
          minPrice: widget.service.billingOptions.first.unitPrice.partnerPrice,
          maxUnit: widget.service.billingOptions.first.maxUnit,
          minUnit: widget.service.billingOptions.first.minUnit,
          selectedHour: widget.service.propertyArea!.first.hours);
      BlocProvider.of<OverviewDataCubit>(context)
          .setSelectedBillingOption(widget.service.billingOptions.first);
    }
    if (widget.service.propertyType != null &&
        (widget.service.propertyType?.isNotEmpty == true)) {
      b.selectPropertyType(widget.service.propertyType!.first);
    }
  }

  @override
  void initState() {
    initValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<PropertyType?> propertyType = ValueNotifier(
        widget.service.propertyType == null ||
                widget.service.propertyType?.isEmpty == true
            ? null
            : widget.service.propertyType!.first);
    ValueNotifier<PropertyArea?> propertyArea = ValueNotifier(
        widget.service.propertyArea == null ||
                widget.service.propertyArea?.isEmpty == true
            ? null
            : widget.service.propertyArea!.first);
    bool serviceEnable = widget.service.isTeamService ?? false;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        serviceEnable ? _buildPropertyType(propertyType) : const SizedBox(),
        serviceEnable
            ? const SizedBox()
            : BuildSubServiceSelection(
                service: widget.service,
              ),
        // Frequency selector
        !serviceEnable
            ? BuildBillingOptions(
                service: widget.service,
              )
            : ValueListenableBuilder(
                valueListenable: propertyType,
                builder: (context, data, child) =>
                    data?.noRooms == true ? const SizedBox() : _buildRooms()),
        serviceEnable ? _buildPropertyArea(propertyArea) : const SizedBox(),
        // // //additional price section----
        // ...List.generate(widget.service.billingOptions.first.serviceAdditionalPayments.length,
        //     (index) => const BuildAdditionalPriceView()),

        // // Additional inputs section
        // BuildAdditionalInputsView(
        //   service: widget.service,
        // ),
        serviceEnable ? _buildHours(propertyArea) : const SizedBox(),
        BuildHowItWorks(
          service: widget.service,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 8.0),
              Row(
                children: [
                  ValueListenableBuilder(
                    builder: (context, data, child) {
                      return Checkbox(
                        value: data,
                        onChanged: (value) {
                          acceptTerms.value = !acceptTerms.value;
                          acceptTerms.notifyListeners();
                        },
                        activeColor: AppColors.zimkeyOrange,
                      );
                    },
                    valueListenable: acceptTerms,
                  ),
                  const Text(
                    'I accept the terms and conditions',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(
          height: MediaQuery.sizeOf(context).height * .15,
        )
      ],
    );
  }

  _buildPropertyType(ValueNotifier propertyType) {
    print("length ${widget.service.propertyType?.first}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Choose Property Type',
            style: TextStyle(
              color: AppColors.zimkeyDarkGrey,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
            children: widget.service.propertyType != null
                ? widget.service.propertyType!
                    .getRange(0, 2)
                    .map((e) => ValueListenableBuilder(
                        valueListenable: propertyType,
                        builder: (context, data, child) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Transform.scale(
                                  scale:
                                      1.5, // Adjust the scale factor based on your preference
                                  child: Checkbox(
                                    value: data == e,

                                    onChanged: (val) {
                                      propertyType.value = e;
                                      propertyType.notifyListeners();
                                      BlocProvider.of<OverviewDataCubit>(
                                              context)
                                          .selectPropertyType(e);
                                    },
                                    checkColor:
                                        Colors.white, // Set the check color
                                    activeColor: AppColors
                                        .zimkeyOrange, // Set the active color to transparent
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    splashRadius: 0,
                                    side: const BorderSide(
                                      width: 0.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(e.title)
                              ],
                            ),
                          );
                        }))
                    .toList()
                : []),
        Row(
            children: widget.service.propertyType != null
                ? widget.service.propertyType!
                    .getRange(2, widget.service.propertyType?.length ?? 0)
                    .map((e) => ValueListenableBuilder(
                        valueListenable: propertyType,
                        builder: (context, data, child) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Transform.scale(
                                  scale:
                                      1.5, // Adjust the scale factor based on your preference
                                  child: Checkbox(
                                    value: data == e,

                                    onChanged: (val) {
                                      propertyType.value = e;
                                      propertyType.notifyListeners();
                                      BlocProvider.of<OverviewDataCubit>(
                                              context)
                                          .selectPropertyType(e);
                                    },
                                    checkColor:
                                        Colors.white, // Set the check color
                                    activeColor: AppColors
                                        .zimkeyOrange, // Set the active color to transparent
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    splashRadius: 0,
                                    side: const BorderSide(
                                      width: 0.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(e.title)
                              ],
                            ),
                          );
                        }))
                    .toList()
                : []),
      ],
    );
  }

  _buildPropertyArea(ValueNotifier propertyArea) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Choose Property Area',
            style: TextStyle(
              color: AppColors.zimkeyDarkGrey,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: KeyedSubtree(
            key: UniqueKey(),
            child: ValueListenableBuilder(
                valueListenable: propertyArea,
                builder: (context, data, child) {
                  return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      children: List.generate(
                        widget.service.propertyArea?.length ?? 0,
                        (index) => InkWell(
                          onTap: () {
                            propertyArea.value =
                                widget.service.propertyArea![index];
                            propertyArea.notifyListeners();
                            BlocProvider.of<OverviewDataCubit>(context)
                                .selectPropertyArea(
                                    widget.service.propertyArea![index],
                                    widget.service.billingOptions);
                            BlocProvider.of<CalculatedServiceCostCubit>(context)
                                .addCurrentUnitHour(
                                    unitPrice:
                                        widget.service.billingOptions.first
                                            .unitPrice.unitPrice,
                                    billingId:
                                        widget.service.billingOptions.first.id,
                                    minPrice: widget.service.billingOptions
                                        .first.unitPrice.partnerPrice,
                                    maxUnit: widget
                                        .service.billingOptions.first.maxUnit,
                                    minUnit: widget
                                        .service.billingOptions.first.minUnit,
                                    selectedHour: widget
                                        .service.propertyArea![index].hours);
                            BlocProvider.of<OverviewDataCubit>(context)
                                .setSelectedBillingOption(
                                    widget.service.billingOptions.first);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: (MediaQuery.of(context).size.width / 3) - 20,
                            height:
                                (MediaQuery.of(context).size.width / 5.5) - 20,
                            decoration: BoxDecoration(
                              color: data == widget.service.propertyArea![index]
                                  ? AppColors.zimkeyBodyOrange
                                  : AppColors.zimkeyWhite,
                              border: Border.all(
                                color: data ==
                                        widget.service.propertyArea![index]
                                    ? AppColors.zimkeyOrange
                                    : AppColors.zimkeyDarkGrey.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            child: Text(
                              widget.service.propertyArea![index].title,
                              style: const TextStyle(
                                color: AppColors.zimkeyDarkGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ));
                }),
          ),
        )
      ],
    );
  }

  _buildRooms() {
    ValueNotifier<Room?> room = ValueNotifier(
        widget.service.room == null || widget.service.room?.isEmpty == true
            ? null
            : widget.service.room!.first);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Choose No.Of Rooms',
            style: TextStyle(
              color: AppColors.zimkeyDarkGrey,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: KeyedSubtree(
            key: UniqueKey(),
            child: ValueListenableBuilder(
                valueListenable: room,
                builder: (context, data, child) {
                  return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      children: List.generate(
                        widget.service.room?.length ?? 0,
                        (index) => InkWell(
                          onTap: () {
                            room.value = widget.service.room![index];
                            room.notifyListeners();
                            BlocProvider.of<OverviewDataCubit>(context)
                                .selectRoom(widget.service.room![index]);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: (MediaQuery.of(context).size.width / 3) - 20,
                            height:
                                (MediaQuery.of(context).size.width / 5.5) - 20,
                            decoration: BoxDecoration(
                              color: data == widget.service.room![index]
                                  ? AppColors.zimkeyBodyOrange
                                  : AppColors.zimkeyWhite,
                              border: Border.all(
                                color: data == widget.service.room![index]
                                    ? AppColors.zimkeyOrange
                                    : AppColors.zimkeyDarkGrey.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            child: Text(
                              widget.service.room![index].title,
                              style: const TextStyle(
                                color: AppColors.zimkeyDarkGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ));
                }),
          ),
        )
      ],
    );
  }

  _buildHours(ValueNotifier<PropertyArea?> propertyType) {
    ValueNotifier<bool> furnished = ValueNotifier(true);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Text(
                "Furnished ",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 10,
              ),
              ValueListenableBuilder(
                  valueListenable: furnished,
                  builder: (context, data, child) {
                    return Switch(
                        value: data,
                        activeColor: AppColors.zimkeyOrange,
                        onChanged: (val) {
                          furnished.value = !furnished.value;
                          BlocProvider.of<OverviewDataCubit>(context)
                              .setFurnished(furnished.value);
                        });
                  }),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          ValueListenableBuilder(
              valueListenable: propertyType,
              builder: (context, data, child) {
                return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "Minimum Hours : ${data?.hours ?? 0}",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
