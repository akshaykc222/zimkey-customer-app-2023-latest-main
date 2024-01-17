part of 'rework_cubit.dart';

abstract class ReworkState extends Equatable {
  const ReworkState();
}

class ReworkInitialState extends ReworkState {
  @override
  List<Object> get props => [];
}
class ReworkLoadingState extends ReworkState {
  @override
  List<Object> get props => [];
}
class ReworkRequestedState extends ReworkState {
  @override
  List<Object> get props => [];
}
class ReworkErrorState extends ReworkState {
  @override
  List<Object> get props => [];
}
