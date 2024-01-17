import 'package:bloc/bloc.dart';
import 'package:customer/data/client/mutations.dart';
import 'package:customer/ui/booking_details/model/cancel_booking_response.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../data/client/queries.dart';
import '../../../../data/model/data_handling/state_model/state_model.dart';
import '../../../../data/provider/bookings_provider.dart';
import '../../model/single_booking_details_response.dart';

part 'booking_details_event.dart';
part 'booking_details_state.dart';

class BookingDetailsBloc
    extends Bloc<BookingDetailsEvent, BookingDetailsState> {
  final BookingsProvider bookingsProvider;
  BookingDetailsBloc({required this.bookingsProvider})
      : super(BookingDetailsInitialState()) {
    on<LoadSingleBookingEvent>((event, emit) async {
      emit(BookingDetailsLoadingState());
      final QueryOptions options = QueryOptions(
        document: gql(Queries.getSingleBookingDetails),
        fetchPolicy: FetchPolicy.noCache,
        variables: <String, dynamic>{"id": event.bookingId},
      );
      ResponseModel responseModel =
          await bookingsProvider.loadSingleBookingDetails(options);
      print(responseModel);
      if (responseModel is SuccessResponse) {
        SingleBookingDetailResponse singleBookingDetailResponse =
            responseModel.value as SingleBookingDetailResponse;
        emit(BookingDetailsLoadedState(
            getBookingServiceItem:
                singleBookingDetailResponse.getBookingServiceItem));
      } else {
        emit(BookingDetailsErrorState());
      }
    });
    on<CancelWork>((event, emit) async {
      emit(BookingDetailsLoadingState());
      final MutationOptions options = MutationOptions(
        document: gql(Mutations.cancelWork),
        fetchPolicy: FetchPolicy.noCache,
        variables: <String, dynamic>{"id": event.bookingId},
      );
      ResponseModel responseModel = await bookingsProvider.cancelWork(options);
      if (responseModel is SuccessResponse) {
        CancelBookingDetailResponse cancelBookingDetailResponse =
            responseModel.value as CancelBookingDetailResponse;
        emit(BookingDetailsLoadedState(
            getBookingServiceItem:
                cancelBookingDetailResponse.getBookingServiceItem));
      } else {
        emit(BookingDetailsErrorState());
      }
    });
  }
}
