part of 'pending_payment_cubit.dart';

abstract class PendingPaymentState extends Equatable {
  const PendingPaymentState();
}

class PendingPaymentInitialState extends PendingPaymentState {
  @override
  List<Object> get props => [];
}
class PendingPaymentLoadingState extends PendingPaymentState {
  @override
  List<Object> get props => [];
}
class PendingPaymentLoadedState extends PendingPaymentState {
  final PendingPaymentResponse paymentResponse;

 const  PendingPaymentLoadedState({required this.paymentResponse});
  @override
  List<Object> get props => [paymentResponse];
}
class PendingPaymentErrorState extends PendingPaymentState {
  @override
  List<Object> get props => [];
}
