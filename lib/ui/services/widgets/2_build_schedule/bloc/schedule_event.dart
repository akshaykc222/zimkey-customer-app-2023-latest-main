part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}

class LoadTimeSlots extends ScheduleEvent {
  final String billingId;
  final String date;

  const LoadTimeSlots({required this.billingId,required this.date});

  @override
  List<Object?> get props => [billingId,date];

}