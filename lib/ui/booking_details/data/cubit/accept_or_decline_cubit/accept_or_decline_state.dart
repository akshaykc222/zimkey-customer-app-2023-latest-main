part of 'accept_or_decline_cubit.dart';

abstract class AcceptOrDeclineState extends Equatable {
  const AcceptOrDeclineState();
}

class AcceptOrDeclineInitialState extends AcceptOrDeclineState {
  @override
  List<Object> get props => [];
}
class AcceptOrDeclineLoadingState extends AcceptOrDeclineState {
  @override
  List<Object> get props => [];
}
class AcceptOrDeclineSuccessState extends AcceptOrDeclineState {
  final AcceptOrDeclineResponse acceptOrDeclineResponse;

  const AcceptOrDeclineSuccessState({required this.acceptOrDeclineResponse});
  @override
  List<Object> get props => [acceptOrDeclineResponse];
}
class AcceptOrDeclineErrorState extends AcceptOrDeclineState {
  @override
  List<Object> get props => [];
}
