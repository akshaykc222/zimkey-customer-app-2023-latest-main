import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../data/client/mutations.dart';
import '../../../../data/model/data_handling/state_model/state_model.dart';
import '../../../../data/provider/review_provider.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewProvider reviewProvider;
  ReviewBloc({required this.reviewProvider}) : super(ReviewInitialState()) {
    on<ReviewEvent>((event, emit) {
    });
    on<AddFirstBookingReview>((event, emit) async {
      emit(ReviewLoadingState());
      final MutationOptions options = MutationOptions(
        document: gql(Mutations.addReview),
        variables: event.request,
      );
      ResponseModel response = await reviewProvider.addFirstBookingReview(options);
      if (response is SuccessResponse) {
        emit(ReviewAddedState());
      } else if(response is ErrorResponse) {
        emit(ReviewErrorState());
      }
    });
  }
}
