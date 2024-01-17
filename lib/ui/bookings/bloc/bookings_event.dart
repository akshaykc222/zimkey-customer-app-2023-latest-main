part of 'bookings_bloc.dart';

abstract class BookingsEvent extends Equatable {
  const BookingsEvent();
}

class LoadBookingList extends BookingsEvent{
  final BookingListArg bookingListArg;
  const LoadBookingList({required this.bookingListArg});

  @override
  List<Object?> get props => [bookingListArg];

}
