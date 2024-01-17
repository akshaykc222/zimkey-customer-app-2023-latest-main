import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../connectivity_service.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService connectivityService;
  bool fetchApi = false;
  ConnectivityBloc({required this.connectivityService}) : super(ConnectivityInitial()) {
    connectivityService.connectivityStream.stream.listen((event) {
      if (event == ConnectivityResult.none) {
        add(NoInternetEvent());
      } else {
        add(InternetLiveEvent());
      }
    });
    on<NoInternetEvent>((event,emit){
      fetchApi = true;
      emit(NoInternetState(fetchApi: fetchApi));
    });
    on<ApiFetchedEvent>((event,emit){
      fetchApi = false;
    });
    on<InternetLiveEvent>((event,emit){
      emit(InternetLiveState(fetchApi: fetchApi));
    });
  }
}
