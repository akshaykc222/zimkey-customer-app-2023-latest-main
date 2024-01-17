part of 'faq_cubit.dart';

abstract class FaqState extends Equatable {
  const FaqState();
}

class FaqInitialState extends FaqState {
  @override
  List<Object> get props => [];
}
class FaqLoadingState extends FaqState {
  @override
  List<Object> get props => [];
}
class FaqErrorState extends FaqState {
  @override
  List<Object> get props => [];
}
class FaqLoadedState extends FaqState {
  final FaqResponse faqResponse;

  const FaqLoadedState({required this.faqResponse});
  @override
  List<Object> get props => [faqResponse];
}
