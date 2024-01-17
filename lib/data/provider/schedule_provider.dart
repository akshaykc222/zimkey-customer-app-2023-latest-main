import '../../utils/helper/helper_functions.dart';
import '../../utils/object_factory.dart';
import '../model/booking_slot/booking_slots_response.dart';
import '../model/data_handling/state_model/state_model.dart';

class ScheduleProvider {
  Future<ResponseModel> getTimeSlots(options) async {
    print("getting time slots");
    final response = await ObjectFactory().apiClient.getTimeSlots(options);
    print("response $response");
    return HelperFunctions.handleResponse<BookingSlotsResponse>(response);
  }
}
