import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../data/client/mutations.dart';
import '../../../../../data/model/data_handling/state_model/state_model.dart';
import '../../../../../data/provider/bookings_provider.dart';

part 'call_partner_state.dart';

class CallPartnerCubit extends Cubit<CallPartnerState> {

  final BookingsProvider bookingsProvider;
  CallPartnerCubit({required this.bookingsProvider}) : super(CallPartnerInitialState());

  void callServicePartner({required String id})async{
    emit(CallPartnerLoadingState());
    final MutationOptions options = MutationOptions(
      document: gql(Mutations.callServicePartner),
      fetchPolicy: FetchPolicy.noCache,
      variables:  <String, dynamic>{
        "id":id,
      },);
    ResponseModel responseModel = await bookingsProvider.callServicePartner(options);

    if(responseModel is SuccessResponse){
      emit(CallPartnerSuccessState());
    } else if(responseModel is ErrorResponse){
      emit(CallPartnerErrorState());

    }

  }
}
