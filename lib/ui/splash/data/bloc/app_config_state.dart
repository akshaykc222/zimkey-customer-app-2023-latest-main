part of 'app_config_bloc.dart';

abstract class AppConfigState extends Equatable {
  const AppConfigState();
}

class AppConfigInitialState extends AppConfigState {
  @override
  List<Object> get props => [];
}

class AppConfigLoadingState extends AppConfigState {
  @override
  List<Object> get props => [];
}
class AppConfigDataLoadedState extends AppConfigState {
  final AppConfigResponse appConfigResponse;

  const AppConfigDataLoadedState({required this.appConfigResponse});
  @override
  List<Object> get props => [appConfigResponse];
}
class AppConfigErrorState extends AppConfigState {
  @override
  List<Object> get props => [];
}
