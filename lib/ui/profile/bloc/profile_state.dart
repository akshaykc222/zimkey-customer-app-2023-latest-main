part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitialState extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoadingState extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoadedState extends ProfileState {
  @override
  List<Object> get props => [];
}
class ProfileCmsContentLoadedState extends ProfileState {
  final GetCmsContentsResponse getCmsContentsResponse;

  const ProfileCmsContentLoadedState({required this.getCmsContentsResponse});
  @override
  List<Object> get props => [];
}

class CustomerSupportAddedState extends ProfileState {
  final CustomerSupportResponse customerSupportResponse;

  const CustomerSupportAddedState({required this.customerSupportResponse});
  @override
  List<Object> get props => [customerSupportResponse];
}

class ProfileErrorState extends ProfileState {
  @override
  List<Object> get props => [];
}
