part of 'booking_details_bloc.dart';

abstract class BookingDetailsState extends Equatable {
  const BookingDetailsState();
}

class BookingDetailsInitialState extends BookingDetailsState {
  @override
  List<Object> get props => [];
}

class BookingDetailsLoadingState extends BookingDetailsState {
  @override
  List<Object> get props => [];
}

class BookingDetailsLoadedState extends BookingDetailsState {
  final GetBookingServiceItem getBookingServiceItem;

  const BookingDetailsLoadedState({required this.getBookingServiceItem});

  @override
  List<Object> get props => [getBookingServiceItem];
}

class BookingDetailsErrorState extends BookingDetailsState {
  @override
  List<Object> get props => [];
}
