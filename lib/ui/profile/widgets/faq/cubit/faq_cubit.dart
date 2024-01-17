
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../data/client/queries.dart';
import '../../../../../data/model/data_handling/state_model/state_model.dart';
import '../../../../../data/model/profile/faq/faq_response.dart';
import '../../../../../data/provider/profile_provider.dart';

part 'faq_state.dart';

class FaqCubit extends Cubit<FaqState> {
  final ProfileProvider profileProvider;
  FaqCubit({required this.profileProvider}) : super(FaqInitialState());
  void loadFAQ() async {
    emit(FaqLoadingState());
    final QueryOptions options = QueryOptions(
      document: gql(Queries.getFaqs),
    );
    ResponseModel stateModel = await profileProvider.loadFAQ(options);
    if(stateModel is SuccessResponse){
      emit(FaqLoadedState(faqResponse: stateModel.value));
    }
    else{
      emit(FaqErrorState());
    }


  }
}
