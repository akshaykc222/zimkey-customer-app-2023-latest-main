import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/strings.dart';
import '../../../../../data/model/address/address_list_response.dart';
import '../../../../../navigation/route_generator.dart';
import '../../../../../utils/helper/helper_dialog.dart';
import '../../../../../utils/helper/helper_widgets.dart';
import '../../../../profile/widgets/address/address_argument.dart';
import '../../../../profile/widgets/address/bloc/address_bloc.dart';
import '../../../cubit/overview_data_cubit.dart';

class AddressListView extends StatefulWidget {
   final bool showAll;
   final bool fromProfile;
   const AddressListView({Key? key,this.showAll=false,this.fromProfile =false}) : super(key: key);

  @override
  State<AddressListView> createState() => _AddressListViewState();
}

class _AddressListViewState extends State<AddressListView> {
  static ValueNotifier<List<CustomerAddress>> addressListNotifier = ValueNotifier(List.empty(growable: true));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewDataCubit, OverviewDataCubitState>(
      builder: (context, cubitState) {
        return BlocConsumer<AddressBloc, AddressState>(
          listener: (context, state) {
            if (state is AddressLoadedState) {
              addressListNotifier.value = state.addressList;
              if (cubitState.customerAddress.id.isEmpty) {
                for (var element in state.addressList) {
                  if (element.isDefault) {
                    BlocProvider.of<OverviewDataCubit>(context).addSelectedAddress(element);
                  }
                }
              }
            }
          },
          builder: (context, state) {
            if (state is AddressLoadingState) {
              return Center(
                child: HelperWidgets.progressIndicator(),
              );
            } else if (state is AddressLoadedState) {
              return ValueListenableBuilder(
                valueListenable: addressListNotifier,
                builder: (BuildContext context, List<CustomerAddress> addressListValue, Widget? child) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    buildAddressTitle(
                        addressListValue: addressListValue,
                        context: context,
                        icon: Icons.add,
                        iconPressed: () => addressListValue.isNotEmpty && !(widget.showAll)
                            ? showAddressBottomSheet(context: context, addressList: addressListValue)
                            : Navigator.pushNamed(context, RouteGenerator.addAddressScreen,
                                arguments: const AddressArgument(isUpdate: false))),
                    buildAddressList(
                        context: context,
                        addressListValue: addressListValue,
                        selectedAddressValue: cubitState.customerAddress,showAll: widget.showAll),
                    addressListValue.isEmpty ? buildEmptyAddressView() : Container()
                  ]);
                },
              );
            } else {
              return Container();
            }
          },
        );
      },
    );
  }

  Column buildAddressList(
      {required BuildContext context,
      required List<CustomerAddress> addressListValue,
      required CustomerAddress selectedAddressValue,
      bool showAll = false}) {
    return Column(
      children: List.generate(
          addressListValue.length,
          (index) => addressListValue[index].id == selectedAddressValue.id || showAll
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.zimkeyLightGrey,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                  margin: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                  child: Center(
                    child: Row(mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 4,
                          child: SizedBox(
                            child: InkWell(
                              onTap: () {
                                if (showAll) {
                                  BlocProvider.of<OverviewDataCubit>(context).addSelectedAddress(addressListValue[index]);
                                  Navigator.pop(context);
                                } else {
                                  if (addressListValue.length > 2) {
                                    showAddressBottomSheet(context: context, addressList: addressListValue);
                                  }
                                }
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    HelperWidgets.buildText(
                                      text: ReCase(addressListValue[index].otherText).titleCase,
                                      color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    HelperWidgets.buildText(
                                      text: '${ReCase(addressListValue[index].buildingName).originalText}, ',
                                      color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                    Wrap(
                                      children: [
                                        HelperWidgets.buildText(
                                          text: '${ReCase(addressListValue[index].locality).originalText}, ',
                                          color: AppColors.zimkeyDarkGrey.withOpacity(0.9),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                        HelperWidgets.buildText(
                                          text: '${ReCase(addressListValue[index].landmark).originalText}, ',
                                          color: AppColors.zimkeyDarkGrey.withOpacity(0.9),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                        // HelperWidgets.buildText(text: ReCase(value[index].area.name).titleCase,
                                        // color:AppColors.zimkeyDarkGrey.withOpacity(0.9),fontWeight:
                                        // FontWeight.normal,
                                        // fontSize:12,),
                                      ],
                                    ),
                                    HelperWidgets.buildText(
                                      text: addressListValue[index].postalCode,
                                      color: AppColors.zimkeyDarkGrey.withOpacity(0.9),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(flex: 1,
                          child: Visibility(
                            visible: showAll,
                            child: InkWell(
                              onTap: () => HelperDialog.confirmActionDialog(
                                  title: Strings.confirmDelete,
                                  context: context,
                                  msg: Strings.confirmDeleteMsg,
                                  btn2Text: Strings.confirm,
                                  btn1Text: Strings.no,
                                  btn2Pressed: () => deleteConfirmPressed(context: context, id: addressListValue[index].id),
                                  btn1Pressed: () => Navigator.pop(context)),
                              child: SizedBox(
                              height: 50,
                                child: Center(
                                  child: HelperWidgets.buildText(
                                    text: Strings.delete,
                                    color: AppColors.zimkeyOrange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(flex: 1,
                          child: InkWell(
                            onTap: () => showAll
                                ?widget.fromProfile?
                            Navigator.pushNamed(context, RouteGenerator.addAddressScreen,
                                arguments: AddressArgument(isUpdate: true, address: addressListValue[index]))
                                : Navigator.pushReplacementNamed(context, RouteGenerator.addAddressScreen,
                                    arguments: AddressArgument(isUpdate: true, address: addressListValue[index]))
                                : showAddressBottomSheet(context: context, addressList: addressListValue),
                            child: SizedBox(
                              height: 50,
                              child: Center(
                                child: HelperWidgets.buildText(
                                  text: showAll ? Strings.edit : Strings.change,
                                  color: AppColors.zimkeyOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 0,
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox()),
    );
  }

  deleteConfirmPressed({required BuildContext context, required String id}) {
    // if(id==widget.selectedAddressIdNotifier.value){
    //   widget.selectedAddressIdNotifier.value="";
    // }
    BlocProvider.of<AddressBloc>(context).add(DeleteAddressEvent(id: id));
    Navigator.pop(context);
  }

  Container buildAddressTitle(
      {required List<CustomerAddress> addressListValue,
      required BuildContext context,
      required IconData icon,
      required VoidCallback iconPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HelperWidgets.buildText(
              text: addressListValue.isEmpty ? Strings.addAddressTitle : Strings.addressTitle,
              color: AppColors.zimkeyDarkGrey,
              fontWeight: FontWeight.bold,
              fontSize: 14),
          InkWell(
            onTap: iconPressed,
            child: Icon(
              icon,
              color: AppColors.zimkeyOrange,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyAddressView() {
    return SizedBox(
        height: 50,
        child: Center(
          child: HelperWidgets.buildText(text: "No Address Added"),
        ));
  }

  void showAddressBottomSheet({required BuildContext context, required List<CustomerAddress> addressList}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: addressList.length >= 3
              ? MediaQuery.sizeOf(context).height / 1.5
              : MediaQuery.sizeOf(context).height / 2.6,
          child: BlocBuilder<OverviewDataCubit, OverviewDataCubitState>(
            builder: (context, cubitState) {
              return ValueListenableBuilder(
                  valueListenable: addressListNotifier,
                  builder: (BuildContext context, value, Widget? child) => Column(
                        children: [
                          buildAddressTitle(
                              addressListValue: value,
                              context: context,
                              icon: Icons.add_circle,
                              iconPressed: () => Navigator.pushReplacementNamed(
                                  context, RouteGenerator.addAddressScreen,
                                  arguments: const AddressArgument(isUpdate: false))),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: buildAddressList(
                                  context: context,
                                  addressListValue: addressList,
                                  selectedAddressValue: cubitState.customerAddress,
                                  showAll: true),
                            ),
                          ),
                          value.isEmpty ? buildEmptyAddressView() : Container()
                        ],
                      ));
            },
          ),
        );
      },
    );
  }
}
