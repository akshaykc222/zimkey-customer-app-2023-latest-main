import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/model/data_handling/state_model/state_model.dart';
import '../../../data/model/home/home_response.dart';
import '../../../data/provider/home_provider.dart';
import '../../location_selection/model/get_cities_response.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeProvider homeProvider;
  HomeBloc({required this.homeProvider}) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<LoadHome>((event,emit) async {
      emit(HomeLoading());
      ResponseModel stateModel  = await homeProvider.loadHome();
      if(stateModel is SuccessResponse){
        emit(HomeLoaded(homeResponse: stateModel.value));
      }
      else{
        emit(HomeError());
      }

    });
   on<LoadCityList>((event,emit) async {
      emit(HomeLoading());
      ResponseModel stateModel  = await homeProvider.loadCities();
      if(stateModel is SuccessResponse){
        emit(LocationLoaded(citiesResponse: stateModel.value));
      }
      else{
        emit(HomeError());
      }

    });
  }

}
