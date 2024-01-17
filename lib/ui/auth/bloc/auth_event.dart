part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}
class LoadAuthInitialState extends AuthEvent{
  @override
  List<Object?> get props => [];

}
class GetUserDetails extends AuthEvent{
  @override
  List<Object?> get props => [];

}

class SendOtp extends AuthEvent {
  final String phoneNum;

  const SendOtp({required this.phoneNum});
  @override
  List<Object?> get props =>[phoneNum];

}

class ReSendOtp extends AuthEvent {
  final String phoneNum;

  const ReSendOtp({required this.phoneNum});
  @override
  List<Object?> get props =>[phoneNum];

}

class VerifyOtp extends AuthEvent {
  final String phoneNum;
  final String otp;
  final String fcmToken;
  final String deviceId;
  final String device;

  const VerifyOtp({required this.otp,required this.phoneNum,required this.fcmToken,required this.deviceId,required this.device});
  @override
  List<Object?> get props =>[otp,phoneNum,fcmToken,deviceId,device];

}
class RegisterUser extends AuthEvent {
  final String name;
  final String mail;
  final String referral;

  const RegisterUser({required this.name,required this.mail,required this.referral});
  @override
  List<Object?> get props =>[name,mail,referral];

}
class UpdateUser extends AuthEvent {
  final String name;
  final String mail;


  const UpdateUser({required this.name,required this.mail});
  @override
  List<Object?> get props =>[name,mail];

}
class LoadInitialState extends AuthEvent {
  @override
  List<Object?> get props =>[];

}