import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/bookings/booking_list_response.dart';
import '../../../data/model/data_handling/state_model/state_model.dart';
import '../../../data/provider/bookings_provider.dart';
import '../presentation/booking_list/bookings_list_screen.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final BookingsProvider bookingsProvider;
  BookingsBloc({required this.bookingsProvider}) : super(BookingsInitialState()) {

    on<LoadBookingList>((event,emit) async {
      emit(BookingsLoadingState());
      ResponseModel responseModel = await bookingsProvider.loadBookingList(event.bookingListArg);
      if(responseModel is SuccessResponse){
        emit(BookingListLoadedState(bookingListResponse: responseModel.value));
      }else if(responseModel is ErrorResponse){
        emit(BookingsErrorState());
      }
    });

  }
}

