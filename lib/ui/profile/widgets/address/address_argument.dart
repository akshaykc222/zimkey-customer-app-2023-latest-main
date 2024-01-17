
import '../../../../data/model/address/address_list_response.dart';

class AddressArgument {
  final bool isUpdate;
  final CustomerAddress? address;
  const AddressArgument({required this.isUpdate,this.address});

}