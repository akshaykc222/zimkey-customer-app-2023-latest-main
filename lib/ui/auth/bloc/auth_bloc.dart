import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../data/client/mutations.dart';
import '../../../data/model/auth/register_user_response.dart';
import '../../../data/model/auth/send_otp_response.dart';
import '../../../data/model/auth/user_detail_response.dart';
import '../../../data/model/auth/verify_otp_response.dart';
import '../../../data/model/data_handling/state_model/state_model.dart';
import '../../../data/model/profile/edit_profile/update_user_response.dart';
import '../../../data/provider/auth_provider.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthProvider authProvider;

  AuthBloc({required this.authProvider}) : super(AuthInitialState()) {
    on<AuthEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<LoadAuthInitialState>((event, emit) async {
      emit(AuthInitialState());
    });
    on<SendOtp>((event, emit) async {
      emit(AuthLoadingState());
      ResponseModel stateModel = await authProvider.sendOtp(event.phoneNum);
      if (stateModel is SuccessResponse) {
        emit(OtpSendSuccessState(sendOtpResponse: stateModel.value));
      } else {}
    });
    on<ReSendOtp>((event, emit) async {
      ResponseModel stateModel = await authProvider.sendOtp(event.phoneNum);
      if (stateModel is SuccessResponse) {
        emit(OtpSendSuccessState(sendOtpResponse: stateModel.value));
      } else {}
    });

    on<VerifyOtp>((event, emit) async {
      emit(AuthLoadingState());
      final MutationOptions options =
          MutationOptions(document: gql(Mutations.verifyOtp), variables: {
        "phoneNumber": event.phoneNum,
        "otp": event.otp,
        "deviceId": event.deviceId,
        "device": event.device,
        "token": event.fcmToken,
        "app": "CUSTOMER"
      });
      print("verify");
      print(options.variables);
      ResponseModel stateModel = await authProvider.verifyOtp(options);

      if (stateModel is SuccessResponse) {
        emit(OtpVerifySuccessState(verifyOtpResponse: stateModel.value));
      } else if (stateModel is ErrorResponse) {
        emit(OtpVerifyErrorState(errorMsg: stateModel.msg.toString()));
      }
    });

    on<RegisterUser>((event, emit) async {
      emit(AuthLoadingState());
      ResponseModel stateModel = await authProvider.registerUser({
        "data": {
          "name": event.name,
          "email": event.mail,
          "refUid": event.referral
        }
      });
      if (stateModel is SuccessResponse) {
        emit(UserRegistrationSuccessState(
            registerUserResponse: stateModel.value));
      } else {}
    });

    on<UpdateUser>((event, emit) async {
      emit(AuthLoadingState());
      ResponseModel stateModel = await authProvider
          .updateUser({"name": event.name, "email": event.mail});
      if (stateModel is SuccessResponse) {
        print("Response is success");
        emit(UserUpdateSuccessState(updateUserResponse: stateModel.value));
        add(GetUserDetails());
      } else if (stateModel is ErrorResponse) {
        print(stateModel.msg);
        emit(AuthErrors());
      }
    });

    on<LoadInitialState>((event, emit) async {
      emit(AuthInitialState());
    });

    on<GetUserDetails>((event, emit) async {
      try{
        emit(AuthLoadingState());
        ResponseModel stateModel = await authProvider.getUserDetails();

        if (stateModel is SuccessResponse) {
          emit(AuthUserDataLoadedState(userDetailsResponse: stateModel.value));
        } else if (stateModel is ErrorResponse) {
          emit(AuthErrors());
        }
      }catch(e){


      }

    });
  }
}
