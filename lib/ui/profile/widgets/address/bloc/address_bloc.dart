import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../data/client/mutations.dart';
import '../../../../../data/client/queries.dart';
import '../../../../../data/model/address/add_address_response.dart';
import '../../../../../data/model/address/address_list_response.dart';
import '../../../../../data/model/address/delete_address_response.dart';
import '../../../../../data/model/address/update_address_response.dart';
import '../../../../../data/model/data_handling/state_model/state_model.dart';
import '../../../../../data/provider/address_provider.dart';

part 'address_event.dart';

part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressProvider addressProvider;

  AddressBloc({required this.addressProvider}) : super(AddressInitialState()) {
    on<FetchAddressEvent>((event, emit) async {
      emit(AddressLoadingState());
      final QueryOptions options = QueryOptions(
        document: gql(Queries.fetchAddressList),
      );
      ResponseModel stateModel = await addressProvider.fetchAddressList(options);
      if (stateModel is SuccessResponse) {
        AddressListResponse addressListResponse = stateModel.value;
        emit(AddressLoadedState(addressList: addressListResponse.getCustomerAddresses.customerAddresses));
      } else {
        emit(AddressErrorState());
      }
    });
    on<AddAddressEvent>((event, emit) async {
      emit(AddressLoadingState());
      final MutationOptions options =
          MutationOptions(document: gql(Mutations.addAddress), variables: event.addressRequest
              // variables: {"data":event.addressRequest.toJson()}
              // variables: const <String, dynamic>{
              //   "buildingName": "yrxcfhcfhc building",
              //   "locality": "test locality",
              //   "landmark": "test landmark",
              //   "areaId": "149dacd0-9f16-141a-a625-86abdedc3aa2",
              //   "postalCode": "999000",
              //   "addressType": "HOME",
              //   "addressPhone": "+918989000010"
              // }
              );
      ResponseModel stateModel = await addressProvider.addAddress(options);
      if (stateModel is SuccessResponse) {
        AddAddressResponse addAddressResponse = stateModel.value;
        emit(AddressLoadedState(addressList: addAddressResponse.addCustomerAddress.customerAddresses));
      } else {
        emit(AddressErrorState());
      }
    });
    on<UpdateAddressEvent>((event, emit) async {
      emit(AddressLoadingState());
      final MutationOptions options =
          MutationOptions(document: gql(Mutations.updateAddress), variables: event.addressRequest);

      ResponseModel stateModel = await addressProvider.updateAddress(options);
      if (stateModel is SuccessResponse) {
        UpdateAddressResponse updateAddressResponse = stateModel.value;
        emit(AddressLoadedState(addressList: updateAddressResponse.updateCustomerAddress.customerAddresses));
      } else {
        emit(AddressErrorState());
      }
    });
    on<DeleteAddressEvent>((event, emit) async {
      emit(AddressLoadingState());
      final MutationOptions options =
          MutationOptions(document: gql(Mutations.deleteAddress), variables: {"id": event.id});

      ResponseModel stateModel = await addressProvider.deleteAddress(options);
      if (stateModel is SuccessResponse) {
        DeleteAddressResponse deleteAddressResponse = stateModel.value;
        emit(AddressLoadedState(addressList: deleteAddressResponse.deleteCustomerAddress.customerAddresses));
      } else {
        emit(AddressErrorState());
      }
    });
  }
}
