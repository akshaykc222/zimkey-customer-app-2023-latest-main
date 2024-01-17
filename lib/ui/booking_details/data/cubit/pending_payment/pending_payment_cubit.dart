import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../data/client/mutations.dart';
import '../../../../../data/model/data_handling/state_model/state_model.dart';
import '../../../../../data/provider/bookings_provider.dart';
import '../../../model/pending_payment_response.dart';

part 'pending_payment_state.dart';

class PendingPaymentCubit extends Cubit<PendingPaymentState> {
  final BookingsProvider bookingsProvider;

  PendingPaymentCubit({required this.bookingsProvider}) : super(PendingPaymentInitialState());

  void payPendingPayment({required String id})async{
    emit(PendingPaymentLoadingState());
    final MutationOptions options = MutationOptions(
      document: gql(Mutations.payPendingPayment),
      fetchPolicy: FetchPolicy.noCache,
      variables:  <String, dynamic>{
        "id":id,
      },);
    ResponseModel responseModel = await bookingsProvider.payPendingPayment(options);

    if(responseModel is SuccessResponse){
      emit(PendingPaymentLoadedState(paymentResponse: responseModel.value));
    } else if(responseModel is ErrorResponse){
      emit(PendingPaymentErrorState());

    }

  }
}
