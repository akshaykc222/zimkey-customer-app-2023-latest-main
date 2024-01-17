part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();
}

class FetchAddress extends AddressEvent {
  @override
  List<Object?> get props => [];
}

class FetchAddressEvent extends AddressEvent {
  @override
  List<Object?> get props => [];
}

class AddAddressEvent extends AddressEvent {
  final dynamic addressRequest;

  const AddAddressEvent({required this.addressRequest});

  @override
  List<Object?> get props => [addressRequest];
}

class UpdateAddressEvent extends AddressEvent {
  final dynamic addressRequest;
  const UpdateAddressEvent({required this.addressRequest});
  @override
  List<Object?> get props => [addressRequest];
}

class DeleteAddressEvent extends AddressEvent {
  final String id;
  const DeleteAddressEvent({required this.id});
  @override
  List<Object?> get props => [id];
}
