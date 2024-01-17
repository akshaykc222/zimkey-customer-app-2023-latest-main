
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/data_handling/state_model/state_model.dart';
import '../../../../data/provider/services_provider.dart';
import '../../model/search_service_response.dart';

part 'search_service_state.dart';

class SearchServiceCubit extends Cubit<SearchServiceState> {
  final ServicesProvider servicesProvider;
  SearchServiceCubit({required this.servicesProvider}) : super(SearchServiceInitialState());

  void searchService(String text) async{
    emit(SearchServiceLoadingState());
    ResponseModel responseModel = await servicesProvider.searchServices(text);

    if(responseModel is SuccessResponse){
      emit(SearchServiceLoadedState(searchServiceResponse: responseModel.value));
    } else if(responseModel is ErrorResponse){
      emit(SearchServiceErrorState());

    }
  }
}
