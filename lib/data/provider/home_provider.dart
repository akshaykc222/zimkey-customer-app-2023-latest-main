
import '../../ui/location_selection/model/get_cities_response.dart';
import '../../utils/helper/helper_functions.dart';
import '../../utils/object_factory.dart';
import '../model/data_handling/state_model/state_model.dart';
import '../model/home/home_response.dart';


class HomeProvider {
  Future<ResponseModel> loadHome() async {
    final response = await ObjectFactory().apiClient.loadHome();
    return HelperFunctions.handleResponse<HomeResponse>(response);
  }
  Future<ResponseModel> loadCities() async {
    final response = await ObjectFactory().apiClient.loadCities();
    return HelperFunctions.handleResponse<GetCitiesResponse>(response);
  }
}