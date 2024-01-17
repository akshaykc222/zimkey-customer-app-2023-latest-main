import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../../../../constants/assets.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/strings.dart';
import '../../../../data/model/home/home_response.dart';
import '../../../../utils/helper/helper_functions.dart';
import '../../../../utils/helper/helper_extension.dart';
import '../../../../utils/helper/helper_widgets.dart';
import '../../../../utils/object_factory.dart';
import 'address_argument.dart';
import 'bloc/address_bloc.dart';

class AddAddress extends StatefulWidget {
  final AddressArgument addressArgument;

  const AddAddress({Key? key, required this.addressArgument}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final TextEditingController _locality = TextEditingController();
  final TextEditingController _city = TextEditingController(text: "Kochi");
  final TextEditingController _pinCode = TextEditingController();
  final TextEditingController _addressType = TextEditingController(text: "HOME");
  final TextEditingController _area = TextEditingController();
  final TextEditingController _houseNo = TextEditingController();
  final TextEditingController _landmark = TextEditingController();

  //focus nodes
  final FocusNode _pinCodeNode = FocusNode();
  final FocusNode _localityNode = FocusNode();
  final FocusNode _areaAddrNode = FocusNode();
  final FocusNode _cityNode = FocusNode();
  final FocusNode _addressTypeNode = FocusNode();
  final FocusNode _houseNoNode = FocusNode();
  final FocusNode _landmarkNode = FocusNode();

  ValueNotifier<CheckTextField> houseNotifier = ValueNotifier(CheckTextField());
  ValueNotifier<CheckTextField> localityNotifier = ValueNotifier(CheckTextField());
  ValueNotifier<CheckTextField> landmarkNotifier = ValueNotifier(CheckTextField());
  ValueNotifier<CheckTextField> areaNotifier = ValueNotifier(CheckTextField());
  ValueNotifier<CheckTextField> cityNotifier = ValueNotifier(CheckTextField(hasValue: true));
  ValueNotifier<CheckTextField> pinCodeNotifier = ValueNotifier(CheckTextField());
  ValueNotifier<CheckTextField> addressTypeNotifier = ValueNotifier(CheckTextField());
  ValueNotifier<bool> showOtherAddressType = ValueNotifier(false);
  ValueNotifier<bool> makeDefaultNotifier = ValueNotifier(true);
  ValueNotifier<String> addressTypeSelectedNotifier = ValueNotifier("Home");

  List<String> addressType = ['Home', 'Office', 'Other'];
  List<ValueNotifier<CheckTextField>> valueNotifierList = List.empty(growable: true);
  List<FocusNode> focusNodeList = List.empty(growable: true);

  ValueNotifier<bool> showSearchLocation = ValueNotifier(false);
  ValueNotifier<String> selectedLoc = ValueNotifier("");
  ValueNotifier<String> selectedAreaId = ValueNotifier("");
  ValueNotifier<List<PinCode>> pinCodeListNotifier = ValueNotifier(List.empty(growable: true));

  void showLocationSelection(bool value) {
    showSearchLocation.value = value;
  }

  void selectedUserLoc({required GetArea selectedArea}) {
    selectedLoc.value = selectedArea.name!;
    selectedAreaId.value = selectedArea.id!;

    pinCodeListNotifier.value = selectedArea.pinCodes!;
    checkPinCodeInsideArea(pinCodeList: selectedArea.pinCodes!);
  }

  void checkPinCodeInsideArea({required List<PinCode> pinCodeList}) {
    bool isPinCodeInsideArea = false;
    if (_pinCode.text.isNotEmpty) {
      if (_pinCode.text.length == 6 && pinCodeList.isNotEmpty) {
        for (var element in pinCodeList) {
          if (element.pinCode == _pinCode.text) {
            isPinCodeInsideArea = true;
          }
        }
        if (!isPinCodeInsideArea) {
          pinCodeNotifier.value =
              CheckTextField(hasError: true, hasValue: true, errorMsg: "This pin-code is not within the selected area");
        } else {
          pinCodeNotifier.value = CheckTextField(hasError: false, hasValue: true, errorMsg: "");
        }
      } else {
        pinCodeNotifier.value = CheckTextField(hasError: false, hasValue: true, errorMsg: "");
      }
    } else {
      pinCodeNotifier.value = CheckTextField(hasError: false, hasValue: false, errorMsg: "");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    valueNotifierList.addAll([
      houseNotifier,
      localityNotifier,
      landmarkNotifier,
      pinCodeNotifier,
      cityNotifier,
      areaNotifier,
    ]);
    focusNodeList.addAll([_houseNoNode, _localityNode, _landmarkNode, _pinCodeNode]);
    if (widget.addressArgument.isUpdate) {
      _houseNo.text = widget.addressArgument.address!.buildingName;
      _locality.text = widget.addressArgument.address!.locality;
      _landmark.text = widget.addressArgument.address!.landmark;
      _pinCode.text = widget.addressArgument.address!.postalCode;
      _addressType.text = widget.addressArgument.address!.otherText;
      selectedLoc.value = widget.addressArgument.address!.area.name;
      selectedAreaId.value = widget.addressArgument.address!.areaId;
      addressTypeSelectedNotifier.value = widget.addressArgument.address!.addressType.capitalize();
      showOtherAddressType.value = widget.addressArgument.address!.addressType.capitalize() == "Other";
      makeDefaultNotifier.value = widget.addressArgument.address!.isDefault;

      houseNotifier.value = CheckTextField(hasError: false, hasValue: true);
      houseNotifier.value = CheckTextField(hasError: false, hasValue: true);
      localityNotifier.value = CheckTextField(hasError: false, hasValue: true);
      landmarkNotifier.value = CheckTextField(hasError: false, hasValue: true);
      pinCodeNotifier.value = CheckTextField(hasError: false, hasValue: true);
      areaNotifier.value = CheckTextField(hasError: false, hasValue: true);
      cityNotifier.value = CheckTextField(hasError: false, hasValue: true);
      addressTypeNotifier.value = CheckTextField(
          hasError: false, hasValue: widget.addressArgument.address!.addressType.capitalize() == "Other");
    }
  }

  @override
  void dispose() {
    _locality.dispose();
    _landmark.dispose();
    _houseNo.dispose();
    _pinCode.dispose();
    _area.dispose();
    _addressType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              buildSliverAppBar(
                  context: context,
                  title: widget.addressArgument.isUpdate ? Strings.updateAddressTitle : Strings.addAddressTitle),
            ],
            body: KeyboardActions(
              config: HelperFunctions.buildConfig(context: context, focusNodeList: focusNodeList),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  addAddressForm(),
                  const SizedBox(
                    height: 35,
                  ),
                  buildButton(context),
                ],
              ),
            ),
          ),
          HelperWidgets.searchLocationScreen(
              areaList: ObjectFactory().prefs.getAreaList(),
              showLocationSelection: showLocationSelection,
              selectUserLoc: selectedUserLoc,
              valueNotifier: showSearchLocation)
        ],
      ),
    );
  }

  SliverAppBar buildSliverAppBar({required BuildContext context, required String title}) {
    return SliverAppBar(
      backgroundColor: AppColors.zimkeyOrange,
      expandedHeight: 0.0,
      floating: false,
      pinned: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          size: 18,
          color: AppColors.zimkeyWhite,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        title: HelperWidgets.buildText(
          text: title,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.zimkeyWhite,
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () => buttonClick(),
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width - 250,
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
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
            'Save',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: 'Inter',
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget addAddressForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //house no
          buildAddressTextField(
              controller: _houseNo,
              focusNode: _houseNoNode,
              icon: Assets.iconHouse,
              valueNotifier: houseNotifier,
              hintText: Strings.houseEditorHintText),
          buildAddressTextField(
              controller: _locality,
              valueNotifier: localityNotifier,
              focusNode: _localityNode,
              icon: Assets.iconLocality,
              hintText: Strings.localityEditorHintText),
          buildAddressTextField(
              controller: _landmark,
              focusNode: _landmarkNode,
              icon: Assets.iconLandmark,
              valueNotifier: landmarkNotifier,
              hintText: Strings.landmarkEditorHintText),

          buildAddressTextField(
              controller: _city,
              focusNode: _cityNode,
              icon: Assets.iconCity,
              valueNotifier: cityNotifier,
              readOnly: true,
              hintText: Strings.cityEditorHintText),
          ValueListenableBuilder(
            valueListenable: selectedLoc,
            builder: (BuildContext context, String value, Widget? child) {
              _area.text = value;
              if (value.isNotEmpty) {
                areaNotifier.value = CheckTextField(hasValue: true, hasError: false);
              }
              return buildAddressTextField(
                  valueNotifier: areaNotifier,
                  controller: _area,
                  focusNode: _areaAddrNode,
                  readOnly: true,
                  onTap: () => showSearchLocation.value = true,
                  icon: Assets.iconArea,
                  hintText: Strings.areaEditorHintText);
            },
          ),
          ValueListenableBuilder(
            valueListenable: pinCodeListNotifier,
            builder: (BuildContext context, List<PinCode> pinCodeList, Widget? child) {
              return buildAddressTextField(
                  controller: _pinCode,
                  valueNotifier: pinCodeNotifier,
                  focusNode: _pinCodeNode,
                  onChanged: (val) => checkPinCodeInsideArea(pinCodeList: pinCodeList),
                  icon: Assets.iconPostal,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                  ],
                  keyboardType: TextInputType.number,
                  hintText: Strings.pinCodeEditorHintText);
            },
          ),
          const SizedBox(
            height: 15,
          ),
          buildAddressType(),
          const SizedBox(
            height: 20,
          ),
          //make default
          buildSetDefaultAddress(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  ValueListenableBuilder<bool> buildSetDefaultAddress() {
    return ValueListenableBuilder(
      valueListenable: makeDefaultNotifier,
      builder: (BuildContext context, value, Widget? child) {
        return InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => makeDefaultNotifier.value = !value,
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.iconTickCircle,
                height: 20,
                colorFilter: ColorFilter.mode(
                    value ? AppColors.zimkeyOrange : AppColors.zimkeyDarkGrey.withOpacity(0.3), BlendMode.srcIn),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: HelperWidgets.buildText(
                  text: Strings.setDefaultAddress,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Column buildAddressType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HelperWidgets.buildText(
            text: Strings.addressTypeTitle, fontSize: 14, color: AppColors.zimkeyBlack.withOpacity(0.3)),
        const SizedBox(
          height: 10,
        ),
        //address buttons
        ValueListenableBuilder(
          valueListenable: addressTypeSelectedNotifier,
          builder: (BuildContext context, value, Widget? child) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    addressType.length,
                    (index) => InkWell(
                          child: Container(
                            margin: const EdgeInsets.only(right: 3),
                            width: 100,
                            constraints: const BoxConstraints(maxHeight: 120, minWidth: 90),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              color: value == addressType[index] ? AppColors.zimkeyBodyOrange : AppColors.zimkeyWhite,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: value == addressType[index] ? AppColors.zimkeyOrange : AppColors.zimkeyLightGrey,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  addressType[index],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: value == addressType[index]
                                        ? AppColors.zimkeyBlack
                                        : AppColors.zimkeyDarkGrey.withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            if (addressType[index] == "Other") {
                              _addressType.clear();

                              showOtherAddressType.value = true;
                            } else {
                              showOtherAddressType.value = false;
                              _addressType.text = addressType[index].toUpperCase();
                            }
                            addressTypeSelectedNotifier.value = addressType[index];
                          },
                        )));
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ValueListenableBuilder(
          valueListenable: showOtherAddressType,
          builder: (BuildContext context, value, Widget? child) {
            return Visibility(
              visible: value,
              child: buildAddressTextField(
                  controller: _addressType,
                  valueNotifier: addressTypeNotifier,
                  focusNode: _addressTypeNode,
                  icon: Assets.iconSaveTick,
                  hintText: Strings.addressTypeEditorHintText),
            );
          },
        ),
      ],
    );
  }

  Widget buildAddressTextField(
      {required TextEditingController controller,
      required String icon,
      required FocusNode focusNode,
      int? maxLength,
      VoidCallback? onTap,
      ValueChanged<String>? onChanged,
      required ValueNotifier<CheckTextField> valueNotifier,
      TextInputType keyboardType = TextInputType.text,
      List<TextInputFormatter> inputFormatters = const [],
      bool hasError = false,
      bool readOnly = false,
      required String hintText}) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (BuildContext context, textNotifier, Widget? child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: textNotifier.hasError ? AppColors.zimkeyRed : AppColors.zimkeyDarkGrey2.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    icon,
                    height: 20,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: HelperWidgets.buildTextField(
                        controller: controller,
                        hintText: hintText,
                        focusNode: focusNode,
                        keyboardType: keyboardType,
                        inputFormatters: inputFormatters,
                        maxLength: maxLength,
                        onTap: onTap,
                        onChanged: onChanged ??
                            (val) {
                              if (val.isNotEmpty) {
                                valueNotifier.value = CheckTextField(hasError: false, hasValue: true);
                              } else if (val.isEmpty) {
                                valueNotifier.value = CheckTextField(hasError: false, hasValue: false);
                              }
                            },
                        readOnly: readOnly,
                        textCapitalization: TextCapitalization.sentences),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Visibility(
                    visible: textNotifier.hasValue && !readOnly,
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () {
                        controller.clear();
                        valueNotifier.value = CheckTextField(hasError: false, hasValue: false);
                      },
                      icon: const Icon(
                        Icons.clear,
                        size: 16,
                        color: AppColors.zimkeyBlack,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: readOnly,
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        size: 18,
                        color: AppColors.zimkeyBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
                visible: textNotifier.errorMsg.isNotEmpty,
                child: HelperWidgets.buildText(text: textNotifier.errorMsg, color: AppColors.zimkeyOrange)),
          ],
        );
      },
    );
  }

  buttonClick() {
    bool readyForUpload = true;
    for (var element in valueNotifierList) {
      if (!element.value.hasValue) {
        readyForUpload = false;
        element.value =
            CheckTextField(hasValue: false, hasError: true, errorMsg: "Please fill this field and continue");
      } else {
        element.value = CheckTextField(hasValue: true, hasError: false, errorMsg: "");
      }
    }
    if (addressTypeSelectedNotifier.value == "Other") {
      if (!addressTypeNotifier.value.hasValue) {
        readyForUpload = false;
        addressTypeNotifier.value =
            CheckTextField(hasValue: false, hasError: true, errorMsg: "Please fill this field and continue");
      } else {
        addressTypeNotifier.value = CheckTextField(hasValue: true, hasError: false, errorMsg: "");
      }
    }

    if (readyForUpload) {
      final request = <String, dynamic>{
        "buildingName": _houseNo.text,
        "locality": _locality.text,
        "landmark": _landmark.text,
        'areaId': selectedAreaId.value,
        'postalCode': _pinCode.text,
        "addressType": showOtherAddressType.value ? "OTHER" : _addressType.text,
        "otherText": _addressType.text,
        "isDefault": makeDefaultNotifier.value
      };
      if (widget.addressArgument.isUpdate) {
        request["addressId"] = widget.addressArgument.address!.id.toString();
        BlocProvider.of<AddressBloc>(context).add(UpdateAddressEvent(addressRequest: request));
      } else {
        BlocProvider.of<AddressBloc>(context).add(AddAddressEvent(addressRequest: request));
      }
      Navigator.pop(context);
    }
  }
}

class CheckTextField {
  bool hasValue;
  bool hasError;
  String errorMsg;

  CheckTextField({this.hasError = false, this.hasValue = false, this.errorMsg = ""});
}
