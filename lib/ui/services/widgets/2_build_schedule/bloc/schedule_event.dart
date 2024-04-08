part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}

class LoadTimeSlots extends ScheduleEvent {
  final String billingId;
  final String date;
  final bool? isReschedule;
  final String? bookingServiceItemId;

  const LoadTimeSlots({
    required this.billingId,
    required this.date,
    this.isReschedule,
    this.bookingServiceItemId,
  });

  @override
  List<Object?> get props => [billingId, date];
}
