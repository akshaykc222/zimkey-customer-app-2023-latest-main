
import 'package:customer/ui/booking_details/model/accept_or_decline_response.dart';

import '../../ui/booking_details/model/call_partner_response.dart';
import '../../ui/booking_details/model/cancel_booking_response.dart';
import '../../ui/booking_details/model/pending_payment_response.dart';
import '../../ui/booking_details/model/single_booking_details_response.dart';
import '../../ui/booking_details/presentation/widgets/reschedule/model/reschedule_work_response.dart';
import '../../ui/booking_details/presentation/widgets/rework/model/rework_requested_response.dart';
import '../../utils/helper/helper_functions.dart';
import '../../utils/object_factory.dart';
import '../model/bookings/booking_list_response.dart';
import '../model/data_handling/state_model/state_model.dart';

class BookingsProvider{

  Future<ResponseModel> loadBookingList(request) async {
    final response = await ObjectFactory().apiClient.loadBookingList(request);
    return HelperFunctions.handleResponse<BookingListResponse>(response);
  }
  Future<ResponseModel> loadSingleBookingDetails(options) async {
    final response = await ObjectFactory().apiClient.loadSingleBookingDetails(options);
    return HelperFunctions.handleResponse<SingleBookingDetailResponse>(response);
  }
  Future<ResponseModel> rescheduleWork(options) async {
    final response = await ObjectFactory().apiClient.rescheduleWork(options);
    return HelperFunctions.handleResponse<RescheduleWorkResponse>(response);
  }
  Future<ResponseModel> requestRework(options) async {
    final response = await ObjectFactory().apiClient.requestRework(options);
    return HelperFunctions.handleResponse<ReworkRequestedResponse>(response);
  }
  Future<ResponseModel> cancelWork(options) async {
    final response = await ObjectFactory().apiClient.cancelWork(options);
    return HelperFunctions.handleResponse<CancelBookingDetailResponse>(response);
  }
  Future<ResponseModel> acceptOrDeclineRequest(options) async {
    final response = await ObjectFactory().apiClient.acceptOrDeclineRequest(options);
    return HelperFunctions.handleResponse<AcceptOrDeclineResponse>(response);
  }
  Future<ResponseModel> callServicePartner(options) async {
    final response = await ObjectFactory().apiClient.callServicePartner(options);
    return HelperFunctions.handleResponse<CallPartnerResponse>(response);
  }
  Future<ResponseModel> payPendingPayment(options) async {
    final response = await ObjectFactory().apiClient.payPendingPayment(options);
    return HelperFunctions.handleResponse<PendingPaymentResponse>(response);
  }
}