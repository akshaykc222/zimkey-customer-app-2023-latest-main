
import '../../utils/helper/helper_functions.dart';
import '../../utils/object_factory.dart';
import '../model/data_handling/state_model/state_model.dart';
import '../model/review/first_booking_review_response.dart';

class ReviewProvider{

  Future<ResponseModel> addFirstBookingReview(options) async {
    final response = await ObjectFactory().apiClient.addFirstBookingReview(options);
    return HelperFunctions.handleResponse<FirstBookingReviewResponse>(response);
  }
}