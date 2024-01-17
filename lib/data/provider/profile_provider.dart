
import '../../utils/buttons/favourite/model/update_favourite_response.dart';
import '../../utils/helper/helper_functions.dart';
import '../../utils/object_factory.dart';
import '../model/data_handling/state_model/state_model.dart';
import '../model/profile/cms_content/get_cms_content_response.dart';
import '../model/profile/customer_support/customer_support_response.dart';
import '../model/profile/faq/faq_response.dart';

class ProfileProvider{

  Future<ResponseModel> loadFAQ(options) async {
    final response = await ObjectFactory().apiClient.loadFAQ(options);
    return HelperFunctions.handleResponse<FaqResponse>(response);
  }

  Future<ResponseModel> loadCmsContent() async {
    final response = await ObjectFactory().apiClient.loadCmsContent();
    return HelperFunctions.handleResponse<GetCmsContentsResponse>(response);
  }

  Future<ResponseModel> addCustomerSupport(options) async {
    final response = await ObjectFactory().apiClient.addCustomerSupport(options);
    return HelperFunctions.handleResponse<CustomerSupportResponse>(response);
  }
  Future<ResponseModel> updateFavourite(options) async {
    final response = await ObjectFactory().apiClient.updateFavourite(options);
    return HelperFunctions.handleResponse<UpdateFavouriteResponse>(response);
  }
}