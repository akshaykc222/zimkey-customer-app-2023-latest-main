part of 'favourite_cubit.dart';

abstract class FavouriteState extends Equatable {
  const FavouriteState();
}

class FavouriteInitial extends FavouriteState {
  @override
  List<Object> get props => [];
}
class FavouriteLoadingState extends FavouriteState {
  @override
  List<Object> get props => [];
}
class FavouriteLoadedState extends FavouriteState {
  final UpdateFavouriteResponse response;
  const FavouriteLoadedState({required this.response});

  @override
  List<Object> get props => [];
}
