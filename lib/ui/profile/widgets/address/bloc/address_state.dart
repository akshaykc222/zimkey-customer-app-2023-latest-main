part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  const AddressState();
}

class AddressInitialState extends AddressState {
  @override
  List<Object> get props => [];
}
class AddressLoadingState extends AddressState {
  @override
  List<Object> get props => [];
}

class AddressLoadedState extends AddressState {
  final List<CustomerAddress> addressList;

 const AddressLoadedState({required this.addressList});
  @override
  List<Object> get props => [addressList];
}

class AddressErrorState extends AddressState {
  @override
  List<Object> get props => [];
}


