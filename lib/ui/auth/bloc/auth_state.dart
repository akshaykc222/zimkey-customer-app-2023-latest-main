part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitialState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class OtpSendSuccessState extends AuthState {
  final SendOtpResponse sendOtpResponse;

  const OtpSendSuccessState({required this.sendOtpResponse});

  @override
  List<Object?> get props => [sendOtpResponse];
}

class OtpVerifySuccessState extends AuthState {
  final VerifyOtpResponse verifyOtpResponse;

  const OtpVerifySuccessState({required this.verifyOtpResponse});

  @override
  List<Object?> get props => [verifyOtpResponse];
}


class OtpVerifyErrorState extends AuthState {
  final String errorMsg;

  const OtpVerifyErrorState({required this.errorMsg});
  @override
  List<Object?> get props => [errorMsg];
}

class AuthUserDataLoadedState extends AuthState {
  final UserDetailsResponse userDetailsResponse;

  const AuthUserDataLoadedState({required this.userDetailsResponse});

  @override
  List<Object> get props => [userDetailsResponse];
}

class UserRegistrationSuccessState extends AuthState {
  final RegisterUserResponse registerUserResponse;

  const UserRegistrationSuccessState({required this.registerUserResponse});

  @override
  List<Object> get props => [registerUserResponse];
}
class UserUpdateSuccessState extends AuthState {
  final UpdateUserResponse updateUserResponse;

  const UserUpdateSuccessState({required this.updateUserResponse});

  @override
  List<Object> get props => [updateUserResponse];
}

class AuthErrors extends AuthState {
  @override
  List<Object> get props => [];
}
