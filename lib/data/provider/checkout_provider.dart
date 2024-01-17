import '../../utils/helper/helper_functions.dart';
import '../../utils/object_factory.dart';
import '../model/checkout/booking_created_response.dart';
import '../model/checkout/checkout_summary_response.dart';
import '../model/checkout/update_payment/payment_updated_response.dart';
import '../model/data_handling/state_model/state_model.dart';

class CheckoutProvider{
  Future<ResponseModel> loadCheckoutSummary(options) async {
    final response = await ObjectFactory().apiClient.loadCheckoutSummary(options);
    return HelperFunctions.handleResponse<CheckoutSummaryResponse>(response);
  }
  Future<ResponseModel> createBooking(options) async {
    final response = await ObjectFactory().apiClient.createBooking(options);
    return HelperFunctions.handleResponse<BookingCreatedResponse>(response);
  }
  Future<ResponseModel> paymentUpdate(options) async {
    final response = await ObjectFactory().apiClient.paymentUpdate(options);
    return HelperFunctions.handleResponse<PaymentUpdatedResponse>(response);
  }
}