part of 'services_bloc.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();
}

class LoadSingleService extends ServicesEvent{
  final String id;

 const LoadSingleService({required this.id});

  @override
  // TODO: implement props
  List<Object?> get props => [id];

}

