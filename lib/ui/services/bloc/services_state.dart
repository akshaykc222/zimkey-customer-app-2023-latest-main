part of 'services_bloc.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();
}

class ServicesInitial extends ServicesState {
  @override
  List<Object> get props => [];
}


class ServicesLoading extends ServicesState {
  @override
  List<Object> get props => [];
}
class SingleServiceLoaded extends ServicesState {
  final SingleServiceResponse serviceResponse;

  const SingleServiceLoaded({required this.serviceResponse});
  @override
  List<Object> get props => [serviceResponse];
}


