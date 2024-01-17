

import '../data/model/address/address_list_response.dart';
import '../data/model/booking_slot/booking_slots_response.dart';
import '../ui/services/cubit/calculate_service_cost_cubit.dart';
import '../ui/services/cubit/overview_data_cubit.dart';
import 'strings.dart';

class InitialObjectValues {
  InitialObjectValues._();

  static CustomerAddress address = CustomerAddress(
      id: "",
      buildingName: "",
      locality: "",
      landmark: "",
      areaId: "",
      postalCode: "",
      addressType: "",
      isDefault: false,
      otherText: "",
      area: Area(
        name: '',
      ));

  static OverviewDataCubitState overviewDataCubitState = OverviewDataCubitState(
      selectedRequirementList: List.empty(growable: true),
      otherRequirementText: "",
      customerNote: "",
      selectedBillingOption: List.empty(growable: true),
      daysList: List.empty(growable: true),
      selectedDay: DateTime.utc(2000),
      selectedSlotTiming: GetServiceBookingSlot(start: DateTime.now(), end: DateTime.now(), available: false),
      slotTimingList: List.empty(growable: true),
      customerAddress: InitialObjectValues.address,
      mobileNum: "",
      selectedMonth: Strings.months[DateTime.now().month - 1]);

  //build option
  static ServiceCostCalculated initialServiceCost = const ServiceCostCalculated(
      totalCost: "0", btnName: Strings.book, rewardPoint: "", selectedBillingId: "", selectedUnit: 0,showCouponListingScreen: false,couponList: []);

  static ServiceCostCalculated serviceCostCalculating = const ServiceCostCalculated(
      totalCost: "", btnName: Strings.book, rewardPoint: "", selectedBillingId: "", selectedUnit: 0,showCouponListingScreen: false,couponList: []);
}
