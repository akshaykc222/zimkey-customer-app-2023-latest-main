import 'package:customer/ui/search_services/model/search_service_response.dart';
import 'package:customer/ui/service_categories/model/service_category_response.dart';

import '../../utils/helper/helper_functions.dart';
import '../../utils/object_factory.dart';
import '../model/data_handling/state_model/state_model.dart';
import '../model/services/single_service_response.dart';

class ServicesProvider{

  Future<ResponseModel> fetchSingleService(id) async {
    final response = await ObjectFactory().apiClient.fetchSingleService(id);
    return HelperFunctions.handleResponse<SingleServiceResponse>(response);
  }
  Future<ResponseModel> loadServiceCategories() async {
    final response = await ObjectFactory().apiClient.loadServiceCategories();
    return HelperFunctions.handleResponse<ServiceCategoryResponse>(response);
  }
  Future<ResponseModel> searchServices(text) async {
    final response = await ObjectFactory().apiClient.searchServices(text);
    return HelperFunctions.handleResponse<SearchServiceResponse>(response);
  }
}