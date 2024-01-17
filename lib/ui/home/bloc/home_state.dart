part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}
class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}


class HomeLoaded extends HomeState {
  final HomeResponse homeResponse;

  const HomeLoaded({required this.homeResponse});
  @override
  List<Object> get props => [homeResponse];
}
class LocationLoaded extends HomeState {
  final GetCitiesResponse citiesResponse;

  const LocationLoaded({required this.citiesResponse});
  @override
  List<Object> get props => [citiesResponse];
}


class HomeError extends HomeState {
  @override
  List<Object> get props => [];
}
