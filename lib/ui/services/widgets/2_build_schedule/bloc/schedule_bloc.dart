import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../data/client/queries.dart';
import '../../../../../data/model/booking_slot/booking_slots_response.dart';
import '../../../../../data/model/data_handling/state_model/state_model.dart';
import '../../../../../data/provider/schedule_provider.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleProvider scheduleProvider;
  ScheduleBloc({required this.scheduleProvider}) : super(ScheduleInitial()) {
    on<ScheduleEvent>((event, emit) {
    });

    on<LoadTimeSlots> ((event,emit) async {
      emit(ScheduleLoading());
      final QueryOptions options = QueryOptions(
        document: gql(Queries.getTimeSlots),
        variables: <String, dynamic>{
          "date": event.date,
          "billingOptionId": event.billingId,
          "partnerId": ""
        },
      );
      ResponseModel stateModel = await scheduleProvider.getTimeSlots(options);
      if(stateModel is SuccessResponse){
        emit(ScheduleTimeSlotLoaded(bookingSlotsResponse: stateModel.value));
      }
      else{
        emit(ScheduleTimeSlotError());
      }

      
    });
  }
}
