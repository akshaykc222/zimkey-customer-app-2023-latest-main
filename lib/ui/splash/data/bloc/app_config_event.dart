part of 'app_config_bloc.dart';

abstract class AppConfigEvent extends Equatable {
  const AppConfigEvent();
}
class LoadAppConfiguration extends AppConfigEvent {
  @override
  List<Object?> get props => [];
}
