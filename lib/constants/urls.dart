class Urls {
  Urls._();

  /// base url
  // static const String baseUrlDev = "https://1clickbackenddev.retrostacks.com";
  static const String baseUrlDev = "https://1clickbackenddev.retrostacks.com/";

  ///master provider
  static const String getDashboardData = "/api/Dashboard";

  ///auth provider
  static const String authenticationRequest = "/api/customer/login";
  static const String createAccountRequest = "/api/customer/register";
  static const String validateEmail = "/api/customer/emailCheck";

  /// Address provider
  static const String viewAllAddressList = "/api/customerAddress/showAll";
  static const String addOrUpdateAddress = "/api/customerAddress/Add";
  static const String deleteAddress = "/api/customerAddress/destroy/";

  /// Ecom provider
  static const String fetchProviderCategory = "/api/providers/showActiveCategories";
  static const String fetchProviderList = "/api/providers/showActiveProviders/";

  ///group provider
  static const String fetchGroups = "/api/customerGroups/showAll";

  static const String deleteGroups = "/api/customerGroups/destroy/";

  /// order provider
  static const String fetchOrders = "/api/customerOrder/list";
  static const String fetchOneOrder = "/api/customerOrder/showOne";

  ///shop provider
  static const String fetchShops = "/api/grocerystore/list";

  static const String fetchProducts = "/api/grocerystore/productList";

  static const String createGroup = "/api/customerGroups/Add";

  /// onboarding provider
  static const String updateStatus = "/api/button/updateProgress";

  /// button provider
  static const String validateDevice = "/api/button/validate";

  /// finish setup provider
  static const String finishSetup = "/api/button/SaveConfig";
}
