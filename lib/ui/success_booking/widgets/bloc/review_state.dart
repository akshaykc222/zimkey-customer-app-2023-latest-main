part of 'review_bloc.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();
}

class ReviewInitialState extends ReviewState {
  @override
  List<Object> get props => [];
}
class ReviewLoadingState extends ReviewState {
  @override
  List<Object> get props => [];
}
class ReviewAddedState extends ReviewState {
  @override
  List<Object> get props => [];
}
class ReviewErrorState extends ReviewState {
  @override
  List<Object> get props => [];
}
