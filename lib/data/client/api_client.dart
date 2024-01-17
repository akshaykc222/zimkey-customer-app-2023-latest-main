// import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../ui/bookings/presentation/booking_list/bookings_list_screen.dart';
import '../../utils/object_factory.dart';
import 'mutations.dart';
import 'queries.dart';

class ApiClient {
  ApiClient() {
    initClient();
  }

  late AuthLink authLink;
  late HttpLink httpLink;
  late ValueNotifier<GraphQLClient> client;

  initClient() {
    authLink = AuthLink(getToken: () async {
      if (ObjectFactory().prefs.getAuthToken() != null) {
        return ObjectFactory().prefs.getAuthToken();
      } else {
        return '';
      }
    });

    httpLink = HttpLink(
      'https://staging.api.zimkey.in/graphql',
      defaultHeaders: {
        'x-source-platform': 'CUSTOMER_APP',
      },
    );

    final Link link = authLink.concat(httpLink);

    client = ValueNotifier(
      GraphQLClient(
          link: link,
          cache: GraphQLCache(store: InMemoryStore()),
          defaultPolicies: DefaultPolicies(
              query: Policies(
                  cacheReread: CacheRereadPolicy.ignoreAll,
                  fetch: FetchPolicy.noCache))),
    );
  }

  ///app config provider

  Future<dynamic> loadAppConfiguration() async {
    final QueryOptions options = QueryOptions(
      document: gql(Queries.getAppConfig),
    );
    return callQuery(client, options);
  }

  /// auth provider

  Future<dynamic> getUserDetails() async {
    final QueryOptions options = QueryOptions(
      document: gql(Queries.getUser),
    );
    return callQuery(client, options);
  }

  Future<dynamic> sendOtp(String phoneNum) async {
    final MutationOptions options = MutationOptions(
        document: gql(Mutations.sendOtp), variables: {"phoneNumber": phoneNum});
    return callMutation(client, options);
  }

  Future<dynamic> verifyOtp(options) async {
    return callMutation(client, options);
  }

  Future<dynamic> registerUser(request) async {
    final MutationOptions options = MutationOptions(
        document: gql(Mutations.registerUser), variables: request);
    return callMutation(client, options);
  }

  Future<dynamic> updateUser(request) async {
    final MutationOptions options = MutationOptions(
        document: gql(Mutations.updateUser), variables: request);
    return callMutation(client, options);
  }

  /// home provider
//query
  Future<dynamic> loadHome() async {
    final QueryOptions options = QueryOptions(
        document: gql(Queries.getHome), fetchPolicy: FetchPolicy.noCache);
    return callQuery(client, options);
  }

  Future<dynamic> loadCities() async {
    final QueryOptions options = QueryOptions(
        document: gql(Queries.getCities), fetchPolicy: FetchPolicy.noCache);
    return callQuery(client, options);
  }

  ///Services Provider
  Future<dynamic> fetchSingleService(id) async {
    print('service id :$id');
    final QueryOptions options = QueryOptions(
      document: gql(Queries.getServiceById),
      fetchPolicy: FetchPolicy.noCache,
      variables: {"id": id},
    );
    return callQuery(client, options);
  }

  Future<dynamic> loadServiceCategories() async {
    final QueryOptions options = QueryOptions(
      document: gql(Queries.getServiceCategories),
      fetchPolicy: FetchPolicy.noCache,
    );
    return callQuery(client, options);
  }

  Future<dynamic> searchServices(text) async {
    final QueryOptions options = QueryOptions(
      document: gql(Queries.searchService),
      fetchPolicy: FetchPolicy.noCache,
      variables: {"search": text},
    );
    return callQuery(client, options);
  }

  ///schedule Provider
  Future<dynamic> getTimeSlots(options) async {
    return callQuery(client, options);
  }

  ///review Provider
  Future<dynamic> addFirstBookingReview(options) async {
    return callMutation(client, options);
  }

  ///bookings Provider
  Future<dynamic> loadBookingList(BookingListArg request) async {
    final QueryOptions options = QueryOptions(
      document: gql(Queries.getUserBookings),
      fetchPolicy: FetchPolicy.noCache,
      variables: <String, dynamic>{
        "pageNumber": request.pageNumber,
        "pageSize": 50,
        "status": request.status
      },
    );
    return callQuery(client, options);
  }

  Future<dynamic> loadSingleBookingDetails(options) async {
    return callQuery(client, options);
  }

  Future<dynamic> rescheduleWork(options) async {
    return callMutation(client, options);
  }

  Future<dynamic> requestRework(options) async {
    return callMutation(client, options);
  }

  Future<dynamic> cancelWork(options) async {
    return callMutation(client, options);
  }

  Future<dynamic> acceptOrDeclineRequest(options) async {
    return callMutation(client, options);
  }

  Future<dynamic> callServicePartner(options) async {
    return callMutation(client, options);
  }

  Future<dynamic> payPendingPayment(options) async {
    return callMutation(client, options);
  }

  ///profile Provider
  Future<dynamic> loadFAQ(options) async {
    return callQuery(client, options);
  }

  Future<dynamic> loadCmsContent() async {
    final QueryOptions options = QueryOptions(
      document: gql(Queries.getCmsContent),
      fetchPolicy: FetchPolicy.noCache,
    );
    return callQuery(client, options);
  }

  Future<dynamic> addCustomerSupport(options) async {
    return callMutation(client, options);
  }

  Future<dynamic> updateFavourite(options) async {
    return callMutation(client, options);
  }

  ///address Provider
  Future<dynamic> fetchAddressList(options) async {
    return callQuery(client, options);
  }

  Future<dynamic> addAddress(options) async {
    return callMutation(client, options);
  }

  Future<dynamic> updateAddress(options) async {
    return callMutation(client, options);
  }

  Future<dynamic> deleteAddress(options) async {
    return callMutation(client, options);
  }

  ///checkout provider
  Future<dynamic> loadCheckoutSummary(options) async {
    return callQuery(client, options);
  }

  Future<dynamic> createBooking(options) async {
    return callMutation(client, options);
  }

  Future<dynamic> paymentUpdate(options) async {
    return callMutation(client, options);
  }
}

Future<dynamic> callMutation(client, options) async {
  try {
    return await client.value.mutate(options);
  } on DioException catch (ex) {
    handleDioError(ex);
  }
}

Future<dynamic> callQuery(client, options) async {
  try {
    return await client.value.query(options);
  } on DioException catch (ex) {
    handleDioError(ex);
  }
}

Future<dynamic> handleDioError(DioException ex) {
  if (ex.type == DioExceptionType.connectionTimeout) {
    throw Exception("Connection Timeout Exception");
  }
  throw Exception(ex.message);
}
