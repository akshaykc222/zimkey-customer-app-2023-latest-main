

import '../../utils/helper/helper_functions.dart';
import '../../utils/object_factory.dart';
import '../model/auth/register_user_response.dart';
import '../model/auth/send_otp_response.dart';
import '../model/auth/user_detail_response.dart';
import '../model/auth/verify_otp_response.dart';
import '../model/data_handling/state_model/state_model.dart';
import '../model/profile/edit_profile/update_user_response.dart';


class AuthProvider {

  Future<ResponseModel> getUserDetails() async {
    final response = await ObjectFactory().apiClient.getUserDetails();
    return HelperFunctions.handleResponse<UserDetailsResponse>(response);
  }
  Future<ResponseModel> sendOtp(String phoneNum) async {
    final response = await ObjectFactory().apiClient.sendOtp(phoneNum);
    return HelperFunctions.handleResponse<SendOtpResponse>(response);
  }
  Future<ResponseModel> verifyOtp(options) async {
    final response = await ObjectFactory().apiClient.verifyOtp(options);
    return HelperFunctions.handleResponse<VerifyOtpResponse>(response);
  }
  Future<ResponseModel> registerUser(request) async {
    final response = await ObjectFactory().apiClient.registerUser(request);
    return HelperFunctions.handleResponse<RegisterUserResponse>(response);
  }
  Future<ResponseModel> updateUser(request) async {
    final response = await ObjectFactory().apiClient.updateUser(request);
    return HelperFunctions.handleResponse<UpdateUserResponse>(response);
  }
  // Future<StateModel> createAccount(request) async {
  //   final response = await ObjectFactory().apiClient.createAccount(request);
  //   debugPrint("response : $response");
  //   return HelperFunctions.handleResponse<LoginResponse>(response);
  // }
  //
  // Future<StateModel> login(request) async {
  //   final response = await ObjectFactory().apiClient.login(request);
  //   debugPrint("response : $response");
  //   return HelperFunctions.handleResponse<LoginResponse>(response);
  // }


  // Future<StateModel> validateEmail(request) async {
  //   final response = await ObjectFactory().apiClient.validateEmail(request);
  //   debugPrint("response : $response");
  //   return HelperFunctions.handleResponse<ValidateEmailResponse>(response);
  // }

// Future<StateModel> deleteAccount() async {
//   final response = await ObjectFactory().apiClient.deleteAccount();
//   print("response" + response.toString());
//   if (response!.statusCode == 200) {
//     // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
//     return StateModel<DelAccountResponse>.success(
//         DelAccountResponse.fromJson(response.data));
//   } else {
//     return StateModel<String>.error("Error Occurred");
//   }
// }
}
