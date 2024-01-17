part of 'booking_details_bloc.dart';

abstract class BookingDetailsEvent extends Equatable {
  const BookingDetailsEvent();
}

class LoadSingleBookingEvent extends BookingDetailsEvent{
  final String bookingId;
  const LoadSingleBookingEvent({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];

}
class CancelWork extends BookingDetailsEvent{
  final String bookingId;
  const CancelWork({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];

}

class AcceptOrDeclineRequest extends BookingDetailsEvent{
  @override
  List<Object?> get props => [];

}
