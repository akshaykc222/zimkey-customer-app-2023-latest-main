
import 'package:customer/data/model/data_handling/state_model/state_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../data/client/mutations.dart';
import '../../../../data/provider/profile_provider.dart';
import '../model/update_favourite_response.dart';

part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  final ProfileProvider profileProvider;
  FavouriteCubit({required this.profileProvider}) : super(FavouriteInitial());
  void updateFavourite({required String serviceId,required bool status}) async {
    emit(FavouriteLoadingState());
    final MutationOptions options = MutationOptions(
      document: gql(Mutations.updateFavourite),
      variables:<String, dynamic>{
        "serviceId":serviceId,
        "status":status
      },
      fetchPolicy: FetchPolicy.noCache,
    );
    ResponseModel responseModel = await profileProvider.updateFavourite(options);
    if(responseModel is SuccessResponse){
      emit(FavouriteLoadedState(response: responseModel.value));
    }

  }
}
