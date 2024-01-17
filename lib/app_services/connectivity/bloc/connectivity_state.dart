part of 'connectivity_bloc.dart';

abstract class ConnectivityState extends Equatable {
  const ConnectivityState();
}

class ConnectivityInitial extends ConnectivityState {
  @override
  List<Object> get props => [];
}

class NoInternetState extends ConnectivityState {
  final bool fetchApi;

  const NoInternetState({required this.fetchApi});
  @override
  List<Object> get props => [fetchApi];
}

class InternetLiveState extends ConnectivityState {
  final bool fetchApi;

  const InternetLiveState({required this.fetchApi});
  @override
  List<Object> get props => [fetchApi];
}
