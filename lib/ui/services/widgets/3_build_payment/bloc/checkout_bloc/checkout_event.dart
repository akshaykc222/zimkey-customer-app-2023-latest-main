part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();
}

class CreateBookingEvent extends CheckoutEvent{
 final BookingGqlInput bookingGqlInput;

  const CreateBookingEvent({required this.bookingGqlInput});
  @override
  List<Object?> get props => [bookingGqlInput];

}

class UpdatePaymentStatus extends CheckoutEvent{
 final PaymentConfirmGqlInput paymentConfirmGqlInput;

  const UpdatePaymentStatus({required this.paymentConfirmGqlInput});
  @override
  List<Object?> get props => [paymentConfirmGqlInput];

}
class ChangeStateToInitial extends CheckoutEvent{
  @override
  List<Object?> get props => [];

}

