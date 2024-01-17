import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../../data/client/mutations.dart';
import '../../../../../../data/model/data_handling/state_model/state_model.dart';
import '../../../../../../data/provider/bookings_provider.dart';

part 'rework_state.dart';

class ReworkCubit extends Cubit<ReworkState> {
  final BookingsProvider bookingsProvider;
  ReworkCubit({required this.bookingsProvider}) : super(ReworkInitialState());

  void requestRework({required String bookingServiceItemId,
    required DateTime scheduleTime,
    required DateTime scheduleEndDateTime,
    required String modificationReason}) async {
    emit(ReworkLoadingState());
    final MutationOptions options = MutationOptions(
      document: gql(Mutations.requestRework),
      variables: <String, dynamic>{
        "bookingServiceItemId": bookingServiceItemId,
        "scheduleTime": scheduleTime.toIso8601String(),
        "scheduleEndDateTime": scheduleEndDateTime.toIso8601String(),
        "modificationReason": modificationReason
      },
    );
    ResponseModel responseModel = await bookingsProvider.requestRework(options);
    if(responseModel is SuccessResponse){
      emit(ReworkRequestedState());
    }else{
      emit(ReworkErrorState());
    }
  }

}
