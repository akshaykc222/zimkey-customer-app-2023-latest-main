import 'package:customer/data/model/data_handling/state_model/state_model.dart';
import 'package:customer/ui/booking_details/model/accept_or_decline_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../data/client/mutations.dart';
import '../../../../../data/provider/bookings_provider.dart';

part 'accept_or_decline_state.dart';

class AcceptOrDeclineCubit extends Cubit<AcceptOrDeclineState> {
  final BookingsProvider bookingsProvider;
  AcceptOrDeclineCubit({required this.bookingsProvider}) : super(AcceptOrDeclineInitialState());

  void acceptOrDeclineRequest({required String id,required bool status})async{
    emit(AcceptOrDeclineLoadingState());
    final MutationOptions options = MutationOptions(
        document: gql(Mutations.acceptOrDeclineRequest),
        fetchPolicy: FetchPolicy.noCache,
        variables:  <String, dynamic>{
          "id":id,
          "status":status
        },);
    ResponseModel responseModel = await bookingsProvider.acceptOrDeclineRequest(options);

    if(responseModel is SuccessResponse){
      emit(AcceptOrDeclineSuccessState(acceptOrDeclineResponse: responseModel.value));
    } else if(responseModel is ErrorResponse){
        emit(AcceptOrDeclineErrorState());

    }

  }
}
