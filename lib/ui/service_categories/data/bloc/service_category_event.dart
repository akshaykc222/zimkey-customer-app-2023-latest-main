part of 'service_category_bloc.dart';

abstract class ServiceCategoryEvent extends Equatable {
  const ServiceCategoryEvent();
}
class LoadServiceCategories extends ServiceCategoryEvent{
  @override
  List<Object?> get props => [];

}
