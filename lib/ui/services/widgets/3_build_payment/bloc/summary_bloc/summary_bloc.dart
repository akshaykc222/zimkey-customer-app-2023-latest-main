import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../../data/client/queries.dart';
import '../../../../../../data/model/checkout/checkout_summary_response.dart';
import '../../../../../../data/model/data_handling/state_model/state_model.dart';
import '../../../../../../data/provider/checkout_provider.dart';

part 'summary_event.dart';
part 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final CheckoutProvider checkoutProvider;
  SummaryBloc({required this.checkoutProvider}) : super(SummaryInitial()) {
    on<SummaryEvent>((event, emit) {});
    on<LoadCheckoutSummary>((event, emit) async {
      emit(SummaryLoadingState());
      print({
        "serviceBillingOptionId": event.serviceBillingOptionId,
        "units": event.units,
        "couponCode": event.couponCode,
        "redeemPoints": event.redeemPoints,
        "addressId": event.addressId
      });
      final QueryOptions options = QueryOptions(
        document: gql(Queries.getBookingSummary),
        variables: <String, dynamic>{
          "serviceBillingOptionId": event.serviceBillingOptionId,
          "units": event.units,
          "couponCode": event.couponCode,
          "redeemPoints": event.redeemPoints,
          "addressId": event.addressId
        },
      );
      ResponseModel response =
          await checkoutProvider.loadCheckoutSummary(options);
      if (response is SuccessResponse) {
        CheckoutSummaryResponse summaryResponse =
            response.value as CheckoutSummaryResponse;
        emit(SummaryLoadedState(
            bookingSummary: summaryResponse.getBookingSummary));
      } else {
        emit(SummaryErrorState());
      }
    });
  }
}
