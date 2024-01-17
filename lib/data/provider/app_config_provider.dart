
import 'package:customer/ui/splash/model/app_config_response.dart';

import '../../utils/helper/helper_functions.dart';
import '../../utils/object_factory.dart';
import '../model/data_handling/state_model/state_model.dart';

class AppConfigProvider{

  Future<ResponseModel> loadAppConfiguration() async {
    final response = await ObjectFactory().apiClient.loadAppConfiguration();
    return HelperFunctions.handleResponse<AppConfigResponse>(response);
  }
}