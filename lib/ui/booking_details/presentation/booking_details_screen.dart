import 'package:customer/ui/booking_details/data/cubit/accept_or_decline_cubit/accept_or_decline_cubit.dart';
import 'package:customer/ui/booking_details/data/cubit/call_service_partner/call_partner_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../constants/colors.dart';
import '../../../data/provider/bookings_provider.dart';
import '../../../data/provider/review_provider.dart';
import '../../../navigation/route_generator.dart';
import '../../services/cubit/calculate_service_cost_cubit.dart';
import '../../services/cubit/overview_data_cubit.dart';
import '../../services/widgets/3_build_payment/bloc/checkout_bloc/checkout_bloc.dart';
import '../../success_booking/widgets/bloc/review_bloc.dart';
import '../data/bloc/booking_details_bloc.dart';
import 'widgets/details_body/bookings_details_body.dart';

class SingleBookingDetailScreen extends StatefulWidget {
  final BookingDetailScreenArg bookingDetailScreenArg;

  const SingleBookingDetailScreen(
      {Key? key, required this.bookingDetailScreenArg})
      : super(key: key);

  @override
  State<SingleBookingDetailScreen> createState() =>
      _SingleBookingDetailScreenState();
}

class _SingleBookingDetailScreenState extends State<SingleBookingDetailScreen> {
  ValueNotifier<bool> showReviewOption = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    Future.delayed(
        const Duration(
          seconds: 2,
        ),
        clearCubit);
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void clearCubit() {
    if (mounted) {
      BlocProvider.of<CheckoutBloc>(context).add(ChangeStateToInitial());
      BlocProvider.of<OverviewDataCubit>(context).clearAllSelection();
      BlocProvider.of<CalculatedServiceCostCubit>(context)
          .clearTotalCalculation();
    }
  }

  @override
  Widget build(BuildContext context) {
    // bottom = MediaQuery.of(context).viewInsets.bottom;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => BookingDetailsBloc(
                bookingsProvider:
                    RepositoryProvider.of<BookingsProvider>(context))
              ..add(LoadSingleBookingEvent(
                  bookingId: widget.bookingDetailScreenArg.id))),
        BlocProvider(
            create: (context) => AcceptOrDeclineCubit(
                bookingsProvider:
                    RepositoryProvider.of<BookingsProvider>(context))),
        BlocProvider(
            create: (context) => CallPartnerCubit(
                bookingsProvider:
                    RepositoryProvider.of<BookingsProvider>(context))),
        BlocProvider(
            create: (context) => ReviewBloc(
                reviewProvider: RepositoryProvider.of<ReviewProvider>(context)))
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColors.zimkeyOrange,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
          title: const Text(
            'Booking Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.zimkeyWhite,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.zimkeyWhite,
              size: 18,
            ),
            onPressed: () {
              if (widget.bookingDetailScreenArg.fromPaymentPending) {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteGenerator.homeScreen, (route) => false,
                    arguments: HomeNavigationArg(
                        bottomNavIndex: 2, bookingTabIndex: 2));
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: const DetailsBody(),
      ),
    );
  }
}
