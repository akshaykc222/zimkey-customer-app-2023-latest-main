part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}
class LoadCmsContent extends ProfileEvent{
  @override
  List<Object?> get props => [];
}
class AddCustomerSupport extends ProfileEvent{
  final String subject;
  final String message;
  const AddCustomerSupport({required this.subject,required this.message});

  @override
  List<Object?> get props => [subject,message];
}
