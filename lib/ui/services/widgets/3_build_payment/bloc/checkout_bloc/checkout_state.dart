part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();
}

class CheckoutInitialState extends CheckoutState {
  @override
  List<Object> get props => [];
}

class CheckoutLoadingState extends CheckoutState {
  @override
  List<Object> get props => [];
}


class CheckoutBookingCreatedState extends CheckoutState {
  final CreateBooking createBooking;
  const CheckoutBookingCreatedState({required this.createBooking});
  @override
  List<Object> get props => [createBooking];
}

class CheckoutPaymentUpdatedState extends CheckoutState {
  final PaymentUpdatedResponse paymentUpdatedResponse;

  const CheckoutPaymentUpdatedState({required this.paymentUpdatedResponse});
  @override
  List<Object> get props => [paymentUpdatedResponse];
}


class CheckoutErrorState extends CheckoutState {
  final OperationException error;

  const CheckoutErrorState({required this.error});
  @override
  List<Object> get props => [error];
}

