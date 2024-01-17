part of 'summary_bloc.dart';

abstract class SummaryState extends Equatable {
  const SummaryState();
}

class SummaryInitial extends SummaryState {
  @override
  List<Object> get props => [];
}
class SummaryLoadingState extends SummaryState {
  @override
  List<Object> get props => [];
}
class SummaryLoadedState extends SummaryState {
  final GetBookingSummary bookingSummary;
  const SummaryLoadedState({required this.bookingSummary});
  @override
  List<Object> get props => [bookingSummary];
}
class SummaryErrorState extends SummaryState {
  @override
  List<Object> get props => [];
}
