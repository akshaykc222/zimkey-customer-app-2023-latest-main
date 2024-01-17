part of 'reschedule_cubit.dart';

abstract class RescheduleState extends Equatable {
  const RescheduleState();
}

class RescheduleInitialState extends RescheduleState {
  @override
  List<Object> get props => [];
}

class RescheduleLoadingState extends RescheduleState {
  @override
  List<Object> get props => [];
}

class RescheduleUpdatedState extends RescheduleState {
  @override
  List<Object> get props => [];
}

class RescheduleErrorState extends RescheduleState {
  @override
  List<Object> get props => [];
}
