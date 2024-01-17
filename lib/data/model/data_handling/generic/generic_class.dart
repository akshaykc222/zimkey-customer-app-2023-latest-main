

import '../../../../ui/booking_details/model/accept_or_decline_response.dart';
import '../../../../ui/booking_details/model/call_partner_response.dart';
import '../../../../ui/booking_details/model/cancel_booking_response.dart';
import '../../../../ui/booking_details/model/pending_payment_response.dart';
import '../../../../ui/booking_details/model/single_booking_details_response.dart';
import '../../../../ui/booking_details/presentation/widgets/reschedule/model/reschedule_work_response.dart';
import '../../../../ui/booking_details/presentation/widgets/rework/model/rework_requested_response.dart';
import '../../../../ui/location_selection/model/get_cities_response.dart';
import '../../../../ui/search_services/model/search_service_response.dart';
import '../../../../ui/service_categories/model/service_category_response.dart';
import '../../../../ui/splash/model/app_config_response.dart';
import '../../../../utils/buttons/favourite/model/update_favourite_response.dart';
import '../../../../utils/object_factory.dart';
import '../../address/add_address_response.dart';
import '../../address/address_list_response.dart';
import '../../address/delete_address_response.dart';
import '../../address/update_address_response.dart';
import '../../auth/register_user_response.dart';
import '../../auth/send_otp_response.dart';
import '../../auth/user_detail_response.dart';
import '../../auth/verify_otp_response.dart';
import '../../booking_slot/booking_slots_response.dart';
import '../../bookings/booking_list_response.dart';
import '../../checkout/booking_created_response.dart';
import '../../checkout/checkout_summary_response.dart';
import '../../checkout/update_payment/payment_updated_response.dart';
import '../../home/home_response.dart';
import '../../profile/cms_content/get_cms_content_response.dart';
import '../../profile/customer_support/customer_support_response.dart';
import '../../profile/edit_profile/update_user_response.dart';
import '../../profile/faq/faq_response.dart';
import '../../review/first_booking_review_response.dart';
import '../../services/single_service_response.dart';

class Generic {
  /// If T is a List, K is the subtype of the list.
  static T fromJson<T>(dynamic data) {
    if (T == UserDetailsResponse) {
      return UserDetailsResponse.fromJson(data) as T;
    } else if (T == HomeResponse) {
      handleHomeResponse(data);
      return HomeResponse.fromJson(data) as T;
    } else if (T == RegisterUserResponse) {
      handleRegisterUserResponse(data);
      return RegisterUserResponse.fromJson(data) as T;
    } else if (T == SingleServiceResponse) {
      return SingleServiceResponse.fromJson(data) as T;
    } else if (T == PendingPaymentResponse) {
      return PendingPaymentResponse.fromJson(data) as T;
    } else if (T == SearchServiceResponse) {
      return SearchServiceResponse.fromJson(data) as T;
    } else if (T == AcceptOrDeclineResponse) {
      return AcceptOrDeclineResponse.fromJson(data) as T;
    } else if (T == CallPartnerResponse) {
      return CallPartnerResponse.fromJson(data) as T;
    } else if (T == AppConfigResponse) {
      return AppConfigResponse.fromJson(data) as T;
    } else if (T == ReworkRequestedResponse) {
      return ReworkRequestedResponse.fromJson(data) as T;
    } else if (T == AddressListResponse) {
      return AddressListResponse.fromJson(data) as T;
    } else if (T == AddAddressResponse) {
      return AddAddressResponse.fromJson(data) as T;
    } else if (T == CancelBookingDetailResponse) {
      return CancelBookingDetailResponse.fromJson(data) as T;
    } else if (T == UpdateAddressResponse) {
      return UpdateAddressResponse.fromJson(data) as T;
    } else if (T == CustomerSupportResponse) {
      return CustomerSupportResponse.fromJson(data) as T;
    } else if (T == DeleteAddressResponse) {
      return DeleteAddressResponse.fromJson(data) as T;
    } else if (T == SendOtpResponse) {
      return SendOtpResponse.fromJson(data) as T;
    } else if (T == VerifyOtpResponse) {
      handleVerifyOtpResponse(data);
      return VerifyOtpResponse.fromJson(data) as T;
    } else if (T == BookingSlotsResponse) {
      return BookingSlotsResponse.fromJson(data) as T;
    } else if (T == ServiceCategoryResponse) {
      return ServiceCategoryResponse.fromJson(data) as T;
    } else if (T == CheckoutSummaryResponse) {
      return CheckoutSummaryResponse.fromJson(data) as T;
    } else if (T == BookingCreatedResponse) {
      return BookingCreatedResponse.fromJson(data) as T;
    } else if (T == FirstBookingReviewResponse) {
      return FirstBookingReviewResponse.fromJson(data) as T;
    } else if (T == RescheduleWorkResponse) {
      return RescheduleWorkResponse.fromJson(data) as T;
    } else if (T == PaymentUpdatedResponse) {
      return PaymentUpdatedResponse.fromJson(data) as T;
    } else if (T == UpdateFavouriteResponse) {
      return UpdateFavouriteResponse.fromJson(data) as T;
    } else if (T == BookingListResponse) {
      return BookingListResponse.fromJson(data) as T;
    } else if (T == GetCitiesResponse) {
      return GetCitiesResponse.fromJson(data) as T;
    } else if (T == SingleBookingDetailResponse) {
      return SingleBookingDetailResponse.fromJson(data) as T;
    } else if (T == UpdateUserResponse) {
      return UpdateUserResponse.fromJson(data) as T;
    } else if (T == GetCmsContentsResponse) {
      return GetCmsContentsResponse.fromJson(data) as T;
    } else if (T == FaqResponse) {
      return FaqResponse.fromJson(data) as T;
    } else if (T == bool || T == String || T == int || T == double) {
      // primitives
      return data;
    } else {
      throw Exception("Unknown class");
    }
  }

  static void  handleVerifyOtpResponse(data) {
    VerifyOtpResponse verifyOtpResponse = VerifyOtpResponse.fromJson(data);
    ObjectFactory().prefs.setAuthToken(token: verifyOtpResponse.verifyOtp.data.token);
    ObjectFactory().prefs.setIsLoggedIn(verifyOtpResponse.verifyOtp.data.isCustomerRegistered);
    ObjectFactory().prefs.saveUserData(verifyOtpResponse.verifyOtp.data.user);
  }

  static void handleRegisterUserResponse(data) {
    RegisterUserResponse registerUserResponse = RegisterUserResponse.fromJson(data);
    ObjectFactory().prefs.saveUserData(registerUserResponse.registerUser);
  }

  static void handleHomeResponse(data) {
    HomeResponse homeResponse = HomeResponse.fromJson(data);
    ObjectFactory().prefs.saveAreaList(getAreaList: homeResponse.getCombinedHome.getAreas!);
  }
}
