import 'package:flutter/material.dart';

import '../data/model/checkout/update_payment/payment_update_request.dart';
import '../ui/auth/auth_screen.dart';
import '../ui/auth/user_register_screen.dart';
import '../ui/booking_details/model/single_booking_details_response.dart';
import '../ui/booking_details/presentation/booking_details_screen.dart';
import '../ui/booking_details/presentation/widgets/reschedule/reschedule_work.dart';
import '../ui/booking_details/presentation/widgets/rework/presentation/rework_service.dart';
import '../ui/bookings/presentation/booking_list/bookings_list_screen.dart';
import '../ui/bottom_navigation/bottom_navigation_screen.dart';
import '../ui/location_selection/presentation/location_selction_screen.dart';
import '../ui/onboarding/presentation/onboarding_screen.dart';
import '../ui/profile/profile_screen.dart';
import '../ui/profile/widgets/address/add_address.dart';
import '../ui/profile/widgets/address/address_argument.dart';
import '../ui/profile/widgets/address/address_list_screen.dart';
import '../ui/profile/widgets/customer_support/customer_support_screen.dart';
import '../ui/profile/widgets/edit_profile/edit_profile_screen.dart';
import '../ui/profile/widgets/faq/faq_screen.dart';
import '../ui/profile/widgets/html_view/html_view_screen.dart';
import '../ui/sample/sample_page.dart';
import '../ui/search_services/search_services_screen.dart';
import '../ui/services/service_details_screen.dart';
import '../ui/service_categories/presentation/screens/service_category_screen.dart';
import '../ui/splash/splash_screen.dart';
import '../ui/success_booking/success_booking_screen.dart';
import '../utils/helper/helper_widgets.dart';

class RouteGenerator {
  RouteGenerator._();

  static const initialScreen = '/';
  static const splashScreen = '/splash';
  static const authScreen = '/auth';
  static const userRegisterScreen = '/user_register';
  static const homeScreen = '/home';
  static const serviceDetailsScreen = '/service_details';
  static const bookingListScreen = '/booking_list';
  static const profileScreen = '/profile';
  static const addAddressScreen = '/add_address';
  static const addAddressScreenCopy = '/add_address_copy';
  static const bookingSuccessScreen = '/booking_success';
  static const customerSupportScreen = '/customer_support';
  static const faqScreen = '/faq';
  static const htmlViewerScreen = '/html_viewer';
  static const locationSelectionScreen = '/location_selection';
  static const comingSoonScreen = '/coming_soon';
  static const editProfileScreen = '/edit_profile';
  static const addressListScreen = '/address_list';
  static const singleBookingDetailScreen = '/single_booking_details';
  static const serviceCategoryScreen = '/service_category';
  static const searchServiceScreen = '/search_service';
  static const sampleScreen = '/sample_screen';
  static const reScheduleScreen = '/reschedule';
  static const reworkScreen = '/rework';
  static const onboardingScreen = '/onboarding';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case authScreen:
        return animatedRoute(const AuthScreen());

      case userRegisterScreen:
        return animatedRoute(const UserRegisterScreen());

      case homeScreen:
        final HomeNavigationArg arg = settings.arguments as HomeNavigationArg;
        return animatedRoute(BottomNavigation(
          arg: arg,
        ));

      case bookingListScreen:
        final int index = settings.arguments as int;
        return animatedRoute( BookingsListScreen(tabIndex: index,));

      case profileScreen:
        return animatedRoute(const ProfileScreen());

      case customerSupportScreen:
        return animatedRoute(const CustomerSupport());

      case faqScreen:
        return animatedRoute(const FaqScreen());

      case sampleScreen:
        return animatedRoute(const SamplePage());

      case editProfileScreen:
        return animatedRoute(const EditProfile());

      case onboardingScreen:
        return animatedRoute(const Onboarding());

      case addressListScreen:
        return animatedRoute(const AddressListScreen());

      case reScheduleScreen:
        final GetBookingServiceItem item = settings.arguments as GetBookingServiceItem;
        return animatedRoute( RescheduleBooking(serviceItem: item,));

      case reworkScreen:
        final GetBookingServiceItem item = settings.arguments as GetBookingServiceItem;
        return animatedRoute( ReworkService(serviceItem: item,));

      case locationSelectionScreen:
        return animatedRoute(const LocationSelectionScreen());

      case serviceCategoryScreen:
        return animatedRoute(const ServiceCategoryScreen());

      case searchServiceScreen:
        return animatedRoute(const SearchServiceScreen());

      case singleBookingDetailScreen:
        final BookingDetailScreenArg arg = settings.arguments as BookingDetailScreenArg;
        return animatedRoute(SingleBookingDetailScreen(bookingDetailScreenArg: arg,));

      case comingSoonScreen:
        return _comingSoonRoute();

      case htmlViewerScreen:
        final htmlViewerScreenArg = settings.arguments as HtmlViewerScreenArg;
        return animatedRoute(HtmlViewerScreen(htmlViewerScreenArg: htmlViewerScreenArg));

      case addAddressScreen:
        final AddressArgument addressArgument = settings.arguments as AddressArgument;
        return animatedRoute(AddAddress(
          addressArgument: addressArgument,
        ));

      case serviceDetailsScreen:
        final String id = settings.arguments as String;
        return animatedRoute(ServiceDetailsScreen(
          id: id,
        ));

      case bookingSuccessScreen:
        final PaymentConfirmGqlInput paymentConfirmGqlInput = settings.arguments as PaymentConfirmGqlInput;
        return animatedRoute(BookingSuccessScreen(paymentConfirmGqlInput: paymentConfirmGqlInput));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> normalRoute(Widget screenName) {
    return MaterialPageRoute(builder: (_) => screenName);
  }

  static PageRouteBuilder animatedRoute(Widget screenName) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screenName,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.black38),
          foregroundColor: Colors.white,
          title: const Text(""),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: SizedBox(height: 200, width: 250, child: HelperWidgets.errorWidget()),
        ),
      );
    });
  }

  static Route<dynamic> _comingSoonRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.black38),
          foregroundColor: Colors.white,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: SizedBox(height: 200, width: 250, child: HelperWidgets.lottieComingSoon()),
        ),
      );
    });
  }
}
class BookingDetailScreenArg{
  final String id;
  final bool fromPaymentPending;

  BookingDetailScreenArg({required this.id, required this.fromPaymentPending});
}
class HomeNavigationArg{
  final int bottomNavIndex;
  final int bookingTabIndex;

  HomeNavigationArg({ this.bottomNavIndex=0,this.bookingTabIndex=0});
}
