import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/initial_object_values.dart';
import '../../../data/model/address/address_list_response.dart';
import '../../../data/model/booking_slot/booking_slots_response.dart';
import '../../../data/model/services/single_service_response.dart';

class OverviewDataCubit extends Cubit<OverviewDataCubitState> {
  OverviewDataCubit() : super(InitialObjectValues.overviewDataCubitState);
  OverviewDataCubitState cubitState =
      InitialObjectValues.overviewDataCubitState;

  // requirement selection
  void addOrRemoveRequirement(Requirement requirement) {
    emit(InitialObjectValues.overviewDataCubitState);
    final List<Requirement> updatedList =
        List.of(cubitState.selectedRequirementList);
    if (updatedList.contains(requirement)) {
      updatedList.remove(requirement);
    } else {
      updatedList.add(requirement);
    }
    cubitState = cubitState.copyWith(selectedRequirementList: updatedList);
    emit(cubitState);
  }

  // setting billing option
  void setSelectedBillingOption(BillingOption billingOption) {
    emit(InitialObjectValues.overviewDataCubitState);
    cubitState = cubitState.copyWith(selectedBillingOption: [billingOption]);
    emit(cubitState);
  }

  void selectRoom(Room room) {
    cubitState = cubitState.copyWith(room: room);
  }

  void selectPropertyType(PropertyType propertyType) {
    cubitState = cubitState.copyWith(propertyType: propertyType);
  }

  void selectPropertyArea(
      PropertyArea propertyArea, List<BillingOption> billingOption) {
    cubitState = cubitState.copyWith(
        propertyArea: propertyArea, selectedBillingOption: billingOption);
  }

  void fetchAllSelectedValues() {
    emit(InitialObjectValues.overviewDataCubitState);
    emit(cubitState);
  }

  void addOtherRequirementText(String text) {
    emit(InitialObjectValues.overviewDataCubitState);
    cubitState = cubitState.copyWith(otherRequirementText: text);
    emit(cubitState);
  }

  void addCustomerNote(String text) {
    emit(InitialObjectValues.overviewDataCubitState);
    cubitState = cubitState.copyWith(customerNote: text);
    emit(cubitState);
  }

  //build schedule
  //1.month and days view
  void addSelectedMonth(String text) {
    emit(InitialObjectValues.overviewDataCubitState);
    cubitState = cubitState.copyWith(selectedMonth: text);
    emit(cubitState);
  }

  void addSelectedDay(DateTime dateTime) {
    emit(InitialObjectValues.overviewDataCubitState);
    cubitState = cubitState.copyWith(
        selectedDay: dateTime,
        selectedSlotTiming: GetServiceBookingSlot(
            start: DateTime.now(), end: DateTime.now(), available: false));
    emit(cubitState);
  }

  void addDaysList(List<DateTime> dateTimeList) {
    emit(InitialObjectValues.overviewDataCubitState);
    cubitState = cubitState.copyWith(daysList: dateTimeList);
    emit(cubitState);
  }

  // //2.booking slot view
  void addSlotTimingList(List<GetServiceBookingSlot> slotTimeList) {
    emit(InitialObjectValues.overviewDataCubitState);
    cubitState = cubitState.copyWith(slotTimingList: slotTimeList);
    emit(cubitState);
  }

  void addSelectedSlotTiming(GetServiceBookingSlot slotTiming) {
    emit(InitialObjectValues.overviewDataCubitState);
    cubitState = cubitState.copyWith(selectedSlotTiming: slotTiming);
    emit(cubitState);
  }

  //3. address view
  void addSelectedAddress(CustomerAddress customerAddress) {
    emit(InitialObjectValues.overviewDataCubitState);
    cubitState = cubitState.copyWith(customerAddress: customerAddress);
    emit(cubitState);
  }

  void setInitialAddress(CustomerAddress customerAddress) {
    emit(InitialObjectValues.overviewDataCubitState);
    cubitState =
        cubitState.copyWith(customerAddress: InitialObjectValues.address);
    emit(cubitState);
  }

  //4. mobile view
  void addMobileNum(String text) {
    emit(InitialObjectValues.overviewDataCubitState);
    cubitState = cubitState.copyWith(mobileNum: text);
    emit(cubitState);
  }

  void setFurnished(bool furnished) {
    cubitState = cubitState.copyWith(furnished: furnished);
  }

  void clearAllSelection() {
    cubitState = InitialObjectValues.overviewDataCubitState;
    emit(InitialObjectValues.overviewDataCubitState);
  }
}

class OverviewDataCubitState {
  final List<Requirement> selectedRequirementList;
  final String otherRequirementText;
  final String customerNote;
  final List<BillingOption> selectedBillingOption;
  final String selectedMonth;
  final DateTime selectedDay;
  final List<DateTime> daysList;
  final List<GetServiceBookingSlot> slotTimingList;
  final GetServiceBookingSlot selectedSlotTiming;
  final CustomerAddress customerAddress;
  final String mobileNum;
  final Room? room;
  final PropertyArea? propertyArea;
  final PropertyType? propertyType;
  final bool? furnished;
  OverviewDataCubitState(
      {required this.mobileNum,
      required this.customerNote,
      required this.customerAddress,
      required this.slotTimingList,
      required this.selectedSlotTiming,
      required this.selectedRequirementList,
      required this.otherRequirementText,
      required this.selectedBillingOption,
      required this.selectedMonth,
      required this.daysList,
      required this.selectedDay,
      this.room,
      this.propertyArea,
      this.propertyType,
      this.furnished});
  OverviewDataCubitState copyWith(
      {List<Requirement>? selectedRequirementList,
      String? otherRequirementText,
      List<BillingOption>? selectedBillingOption,
      String? selectedMonth,
      DateTime? selectedDay,
      List<DateTime>? daysList,
      GetServiceBookingSlot? selectedSlotTiming,
      List<GetServiceBookingSlot>? slotTimingList,
      CustomerAddress? customerAddress,
      String? mobileNum,
      String? customerNote,
      Room? room,
      PropertyType? propertyType,
      PropertyArea? propertyArea,
      bool? furnished}) {
    return OverviewDataCubitState(
        selectedRequirementList:
            selectedRequirementList ?? this.selectedRequirementList,
        otherRequirementText: otherRequirementText ?? this.otherRequirementText,
        selectedBillingOption:
            selectedBillingOption ?? this.selectedBillingOption,
        selectedMonth: selectedMonth ?? this.selectedMonth,
        selectedDay: selectedDay ?? this.selectedDay,
        daysList: daysList ?? this.daysList,
        selectedSlotTiming: selectedSlotTiming ?? this.selectedSlotTiming,
        slotTimingList: slotTimingList ?? this.slotTimingList,
        customerAddress: customerAddress ?? this.customerAddress,
        mobileNum: mobileNum ?? this.mobileNum,
        customerNote: customerNote ?? this.customerNote,
        room: room ?? this.room,
        propertyArea: propertyArea ?? this.propertyArea,
        propertyType: propertyType ?? this.propertyType,
        furnished: furnished ?? this.furnished);
  }
}
