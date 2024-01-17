import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';


import '../../../../../../data/client/mutations.dart';
import '../../../../../../data/model/checkout/booking_created_response.dart';
import '../../../../../../data/model/checkout/booking_gql_input.dart';
import '../../../../../../data/model/checkout/update_payment/payment_update_request.dart';
import '../../../../../../data/model/checkout/update_payment/payment_updated_response.dart';
import '../../../../../../data/model/data_handling/state_model/state_model.dart';
import '../../../../../../data/provider/checkout_provider.dart';

part 'checkout_event.dart';

part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutProvider checkoutProvider;

  CheckoutBloc({required this.checkoutProvider}) : super(CheckoutInitialState()) {
    on<CheckoutEvent>((event, emit) {});

    on<CreateBookingEvent>((event, emit) async {
      emit(CheckoutLoadingState());
      final MutationOptions options = MutationOptions(
        document: gql(Mutations.createBooking),
        variables: <String, dynamic>{"data": event.bookingGqlInput.toJson()},
      );
      Logger().i(event.bookingGqlInput.toJson());
      ResponseModel response = await checkoutProvider.createBooking(options);
      if (response is SuccessResponse) {
        BookingCreatedResponse bookingCreatedResponse = response.value as BookingCreatedResponse;
        emit(CheckoutBookingCreatedState(createBooking: bookingCreatedResponse.createBooking));
      } else if (response is ErrorResponse) {
        emit(CheckoutInitialState());
      }
    });
    on<UpdatePaymentStatus>((event, emit) async {
      emit(CheckoutLoadingState());
      final MutationOptions options = MutationOptions(
        document: gql(Mutations.updatePayment),
        variables: <String, dynamic>{"data": event.paymentConfirmGqlInput.toJson()},
      );
      ResponseModel response = await checkoutProvider.paymentUpdate(options);
      if (response is SuccessResponse) {
        emit(CheckoutPaymentUpdatedState(paymentUpdatedResponse: response.value));
      } else if (response is ErrorResponse) {
        emit(CheckoutErrorState(error: response.msg));
      }
    });
    on<ChangeStateToInitial>((event, emit) async {
      emit(CheckoutInitialState());

    });
  }
}
