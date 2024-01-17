import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import '../../../../data/model/data_handling/state_model/state_model.dart';
import '../../../../data/provider/services_provider.dart';
import '../../model/service_category_response.dart';

part 'service_category_event.dart';
part 'service_category_state.dart';

class ServiceCategoryBloc extends Bloc<ServiceCategoryEvent, ServiceCategoryState> {
  final ServicesProvider servicesProvider;
  ServiceCategoryBloc({required this.servicesProvider}) : super(ServiceCategoryInitialState()) {
    on<LoadServiceCategories>((event, emit) async {
      emit(ServiceCategoryLoadingState());
      ResponseModel responseModel = await servicesProvider.loadServiceCategories();
      if(responseModel is SuccessResponse){
        emit(ServiceCategoryLoadedState(serviceCategoryResponse: responseModel.value));
      }else if(responseModel is ErrorResponse){
        emit(ServiceCategoryErrorState());
      }
    });
  }
}
