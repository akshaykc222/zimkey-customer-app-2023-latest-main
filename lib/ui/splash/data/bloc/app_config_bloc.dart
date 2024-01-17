
import 'package:customer/data/model/data_handling/state_model/state_model.dart';
import 'package:customer/ui/splash/model/app_config_response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/provider/app_config_provider.dart';

part 'app_config_event.dart';
part 'app_config_state.dart';

class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  final AppConfigProvider appConfigProvider;
  AppConfigBloc({required this.appConfigProvider}) : super(AppConfigInitialState()) {
    on<LoadAppConfiguration>((event, emit) async {
      emit(AppConfigLoadingState());
      ResponseModel responseModel = await appConfigProvider.loadAppConfiguration();
      if(responseModel is SuccessResponse){
        emit(AppConfigDataLoadedState(appConfigResponse: responseModel.value));
      }else{
        emit(AppConfigErrorState());
      }
    });
  }
}
