part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();
}

class NoInternetEvent extends ConnectivityEvent {
  @override
  List<Object?> get props => [];

}
class InternetLiveEvent extends ConnectivityEvent {
  @override
  List<Object?> get props => [];
}

class ApiFetchedEvent extends ConnectivityEvent {
  @override
  List<Object?> get props => [];
}
