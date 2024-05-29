import 'package:customer/data/provider/app_config_provider.dart';
import 'package:customer/ui/splash/data/bloc/app_config_bloc.dart';
import 'package:customer/utils/buttons/favourite/cubit/favourite_cubit.dart';
import 'package:customer/utils/helper/no_internet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_services/connectivity/bloc/connectivity_bloc.dart';
import 'app_services/connectivity/connectivity_service.dart';
import 'data/cubit/theme_cubit.dart';
import 'data/provider/address_provider.dart';
import 'data/provider/auth_provider.dart';
import 'data/provider/bookings_provider.dart';
import 'data/provider/checkout_provider.dart';
import 'data/provider/home_provider.dart';
import 'data/provider/profile_provider.dart';
import 'data/provider/review_provider.dart';
import 'data/provider/schedule_provider.dart';
import 'data/provider/services_provider.dart';
import 'navigation/route_generator.dart';
import 'ui/auth/bloc/auth_bloc.dart';
import 'ui/booking_details/data/cubit/pending_payment/pending_payment_cubit.dart';
import 'ui/bookings/bloc/bookings_bloc.dart';
import 'ui/home/bloc/home_bloc.dart';
import 'ui/profile/widgets/address/bloc/address_bloc.dart';
import 'ui/search_services/data/cubit/search_service_cubit.dart';
import 'ui/services/cubit/calculate_service_cost_cubit.dart';
import 'ui/services/cubit/overview_data_cubit.dart';
import 'ui/services/widgets/3_build_payment/bloc/checkout_bloc/checkout_bloc.dart';
import 'ui/services/widgets/3_build_payment/bloc/summary_bloc/summary_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  /// {@macro app}
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConnectionStatusManager(
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => ConnectivityService()),
          RepositoryProvider(create: (context) => AuthProvider()),
          RepositoryProvider(create: (context) => HomeProvider()),
          RepositoryProvider(create: (context) => ServicesProvider()),
          RepositoryProvider(create: (context) => ScheduleProvider()),
          RepositoryProvider(create: (context) => AddressProvider()),
          RepositoryProvider(create: (context) => CheckoutProvider()),
          RepositoryProvider(create: (context) => ProfileProvider()),
          RepositoryProvider(create: (context) => BookingsProvider()),
          RepositoryProvider(create: (context) => ReviewProvider()),
          RepositoryProvider(create: (context) => AppConfigProvider()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit()),
            BlocProvider(create: (_) => OverviewDataCubit()),
            BlocProvider(create: (_) => CalculatedServiceCostCubit()),
            BlocProvider(
                create: (context) => SearchServiceCubit(
                    servicesProvider:
                        RepositoryProvider.of<ServicesProvider>(context))),
            BlocProvider(
                create: (context) => PendingPaymentCubit(
                    bookingsProvider:
                        RepositoryProvider.of<BookingsProvider>(context))),
            BlocProvider(
                create: (context) => FavouriteCubit(
                    profileProvider:
                        RepositoryProvider.of<ProfileProvider>(context))),
            BlocProvider(
                create: (context) => AppConfigBloc(
                    appConfigProvider:
                        RepositoryProvider.of<AppConfigProvider>(context))),
            BlocProvider(
                create: (context) => AuthBloc(
                    authProvider:
                        RepositoryProvider.of<AuthProvider>(context))),
            BlocProvider(
                create: (context) => AddressBloc(
                    addressProvider:
                        RepositoryProvider.of<AddressProvider>(context))),
            BlocProvider(
                create: (context) => ConnectivityBloc(
                    connectivityService:
                        RepositoryProvider.of<ConnectivityService>(context))),
            BlocProvider(
                create: (context) => HomeBloc(
                    homeProvider:
                        RepositoryProvider.of<HomeProvider>(context))),
            BlocProvider(
                create: (context) => BookingsBloc(
                    bookingsProvider:
                        RepositoryProvider.of<BookingsProvider>(context))),
            BlocProvider(
                create: (context) => CheckoutBloc(
                    checkoutProvider:
                        RepositoryProvider.of<CheckoutProvider>(context))),
            BlocProvider(
                create: (context) => SummaryBloc(
                    checkoutProvider:
                        RepositoryProvider.of<CheckoutProvider>(context))),
          ],
          child: const AppView(),
        ),
      ),
    );
  }
}

/// A [StatelessWidget] that:
/// * reacts to state changes in the [ThemeCubit]
/// and updates the theme of the [MaterialApp].
/// * renders the initial route.
class AppView extends StatelessWidget {
  /// {@macro app_view}
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (_, theme) {
        return MaterialApp(
          theme: theme,
          navigatorKey: navigatorKey,
          builder: (context, child) {
            return MediaQuery(
              // Set the default textScaleFactor to 1.0 for the whole subtree.
              data: MediaQuery.of(context).copyWith(
                  textScaleFactor:
                      MediaQuery.of(context).size.shortestSide < 600
                          ? 0.85
                          : 1.5),
              child: child!,
            );
          },
          initialRoute: RouteGenerator.splashScreen,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
