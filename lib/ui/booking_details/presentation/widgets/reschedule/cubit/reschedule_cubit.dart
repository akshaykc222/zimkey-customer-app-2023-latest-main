
import 'package:customer/data/model/data_handling/state_model/state_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../../data/client/mutations.dart';
import '../../../../../../data/provider/bookings_provider.dart';

part 'reschedule_state.dart';

class RescheduleCubit extends Cubit<RescheduleState> {
  final BookingsProvider bookingsProvider;
  RescheduleCubit({required this.bookingsProvider}) : super(RescheduleInitialState());

  void rescheduleWork({required String bookingServiceItemId,
  required DateTime scheduleTime,
  required DateTime scheduleEndDateTime,
  required String modificationReason}) async {
    emit(RescheduleLoadingState());
    final MutationOptions options = MutationOptions(
      document: gql(Mutations.rescheduleWork),
      variables: <String, dynamic>{
        "bookingServiceItemId": bookingServiceItemId,
        "scheduleTime": scheduleTime.toIso8601String(),
        "scheduleEndDateTime": scheduleEndDateTime.toIso8601String(),
        "modificationReason": modificationReason
      },
    );
    ResponseModel responseModel = await bookingsProvider.rescheduleWork(options);
    if(responseModel is SuccessResponse){
      emit(RescheduleUpdatedState());
    }else{
      emit(RescheduleErrorState());
    }
  }

}

