part of 'summary_bloc.dart';

abstract class SummaryEvent extends Equatable {
  const SummaryEvent();
}
class LoadCheckoutSummary extends SummaryEvent{
  final String serviceBillingOptionId;
  final int units;
  final String couponCode;
  final double redeemPoints;

  const LoadCheckoutSummary({required this.serviceBillingOptionId,required this.units,this.couponCode="",this.redeemPoints=0});
  @override
  List<Object?> get props => [serviceBillingOptionId,units,couponCode,redeemPoints];

}