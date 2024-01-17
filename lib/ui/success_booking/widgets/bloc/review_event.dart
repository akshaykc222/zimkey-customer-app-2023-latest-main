part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();
}
class AddFirstBookingReview extends ReviewEvent{
  final dynamic request;

  const AddFirstBookingReview({required this.request});
  @override
  List<Object?> get props => [request];

}
