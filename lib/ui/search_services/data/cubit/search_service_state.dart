part of 'search_service_cubit.dart';

abstract class SearchServiceState extends Equatable {
  const SearchServiceState();
}

class SearchServiceInitialState extends SearchServiceState {
  @override
  List<Object> get props => [];
}
class SearchServiceLoadingState extends SearchServiceState {
  @override
  List<Object> get props => [];
}
class SearchServiceLoadedState extends SearchServiceState {
  final SearchServiceResponse searchServiceResponse;

  const SearchServiceLoadedState({required this.searchServiceResponse});

  @override
  List<Object> get props => [];
}
class SearchServiceErrorState extends SearchServiceState {
  @override
  List<Object> get props => [];
}
