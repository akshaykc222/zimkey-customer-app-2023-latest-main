import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../data/client/mutations.dart';
import '../../../data/model/data_handling/state_model/state_model.dart';
import '../../../data/model/profile/cms_content/get_cms_content_response.dart';
import '../../../data/model/profile/customer_support/customer_support_response.dart';
import '../../../data/provider/profile_provider.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileProvider profileProvider;
  ProfileBloc({required this.profileProvider}) : super(ProfileInitialState()) {
    on<LoadCmsContent>((event, emit) async {
      emit(ProfileLoadingState());
      ResponseModel responseModel = await profileProvider.loadCmsContent();
      if(responseModel is SuccessResponse){
        emit(ProfileCmsContentLoadedState(getCmsContentsResponse: responseModel.value));
      }
      else if(responseModel is ErrorResponse){
        emit(ProfileErrorState());
      }
    });
    on<AddCustomerSupport>((event, emit) async {
      emit(ProfileLoadingState());
      final MutationOptions options = MutationOptions(
        document: gql(Mutations.addCustomerSupport),
        variables:<String, dynamic>{
          "subject":event.subject,
          "message":event.message
        },
        fetchPolicy: FetchPolicy.noCache,
      );
      ResponseModel responseModel = await profileProvider.addCustomerSupport(options);
      if(responseModel is SuccessResponse){
        emit(CustomerSupportAddedState(customerSupportResponse: responseModel.value));
      }
      else if(responseModel is ErrorResponse){
        emit(ProfileErrorState());
      }
    });
  }
}
