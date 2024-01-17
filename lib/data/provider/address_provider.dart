import '../../utils/helper/helper_functions.dart';
import '../../utils/object_factory.dart';
import '../model/address/add_address_response.dart';
import '../model/address/address_list_response.dart';
import '../model/address/delete_address_response.dart';
import '../model/address/update_address_response.dart';
import '../model/data_handling/state_model/state_model.dart';

class AddressProvider {
  Future<ResponseModel> fetchAddressList(options) async {
    final response = await ObjectFactory().apiClient.fetchAddressList(options);
    return HelperFunctions.handleResponse<AddressListResponse>(response);
  }
  Future<ResponseModel> addAddress(options) async {
    final response = await ObjectFactory().apiClient.addAddress(options);
    return HelperFunctions.handleResponse<AddAddressResponse>(response);
  }
  Future<ResponseModel> updateAddress(options) async {
    final response = await ObjectFactory().apiClient.updateAddress(options);
    return HelperFunctions.handleResponse<UpdateAddressResponse>(response);
  }
  Future<ResponseModel> deleteAddress(options) async {
    final response = await ObjectFactory().apiClient.deleteAddress(options);
    return HelperFunctions.handleResponse<DeleteAddressResponse>(response);
  }
}