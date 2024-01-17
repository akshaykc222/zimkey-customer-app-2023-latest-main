part of 'bookings_bloc.dart';

abstract class BookingsState extends Equatable {
  const BookingsState();
}

class BookingsInitialState extends BookingsState {
  @override
  List<Object> get props => [];
}
class BookingsLoadingState extends BookingsState {
  @override
  List<Object> get props => [];
}
class BookingListLoadedState extends BookingsState {
  final BookingListResponse bookingListResponse;
  const BookingListLoadedState({required this.bookingListResponse});
  @override
  List<Object> get props => [bookingListResponse];
}
class BookingsErrorState extends BookingsState {
  @override
  List<Object> get props => [];
}
