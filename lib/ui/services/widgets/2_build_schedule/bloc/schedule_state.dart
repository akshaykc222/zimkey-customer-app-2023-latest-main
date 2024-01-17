part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();
}

class ScheduleInitial extends ScheduleState {
  @override
  List<Object> get props => [];
}

class ScheduleLoading extends ScheduleState {
  @override
  List<Object> get props => [];
}

class ScheduleTimeSlotLoaded extends ScheduleState {
  final BookingSlotsResponse bookingSlotsResponse;

  const ScheduleTimeSlotLoaded({required this.bookingSlotsResponse});
  @override
  List<Object> get props => [bookingSlotsResponse];
}
class ScheduleTimeSlotError extends ScheduleState {
  @override
  List<Object> get props => [];
}
