part of 'service_category_bloc.dart';

abstract class ServiceCategoryState extends Equatable {
  const ServiceCategoryState();
}

class ServiceCategoryInitialState extends ServiceCategoryState {
  @override
  List<Object> get props => [];
}
class ServiceCategoryLoadingState extends ServiceCategoryState{
  @override
  List<Object?> get props => [];

}
class ServiceCategoryLoadedState extends ServiceCategoryState{
  final ServiceCategoryResponse serviceCategoryResponse;

  const ServiceCategoryLoadedState({required this.serviceCategoryResponse});

  @override
  List<Object?> get props => [serviceCategoryResponse];

}
class ServiceCategoryErrorState extends ServiceCategoryState{
  @override
  List<Object?> get props => [];

}
