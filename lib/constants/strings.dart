class Strings {
  Strings._();

  ///General
  static const String appName = "One Click";
  static const String underDevelopment = "Under development..!!";
  static const String mediaUrl = 'https://staging.api.zimkey.in/media-upload/';

  ///common api errors
  static const String unAuthorised = "Unauthorised Api";
  static const String somethingWentWrong = "something went wrong !!";

  //login
  static const String loginLabelText = "Outlook ID";
  static const String loginPasswordLabelText = "Password";
  static const String loginHelperText = "Please enter your Outlook ID";
  static const String loginPasswordHelperText = "Minimum 6 characters.";
  static const String loginOutConfirmationText = "Do you really want to logout?";
  static const String logoutText = "Logout";
  static const String confirmText = "Confirm";
  static const String requestCall = "Request Call";
  static const String logoutTitle = "Enter Login Details";
  static const String notValidEmail = "Not a Valid mail";
  static const String cancelBooking = "Booking Cancellation";
  static const String rescheduleWork = "Reschedule work";
  static const String callRequest = "Call Request";
  static const String cancelBookingDetails = "Do you really want to cancel the booking ?";
  static const String rescheduleBooking = "Do you really want to reschedule the booking ?";
  static const String declineRescheduleBooking = "Do you really want to decline the reschedule request ?";
  static const String callRequestDetails = "A request will be sent to your assigned service partner. You will receive a call from them soon.";

  ///image url
  static const String appLogo = 'assets/icon/login_logo.png';

  //dialog
  static const String cancel = "Cancel";
  static const String ok = "Ok";
  static const String yes = "Yes";
  static const String close = "Close";
  static const String skip = "SKIP";
  static const String update = "Update";
  static const String delete = "DELETE";
  static const String goToHome = "GO TO HOME";
  static const String next = "Next";
  static const String oops = "oops";
  static const String orderCancellation = "Confirm order cancellation?";

  static const String noDataText = "Nothing to show here";
  static const String powerBy = "powered by ";

  //settings
  static const String settingsTitle = "Settings";
  static const String privacyPolicy = "Privacy policy";
  static const String settingsTermsCondition = "Terms & conditions";

  //validators
  static const String emailNotValid = "Email is not valid";
  static const String usernameNotValid = "Username is not valid";
  static const String passwordLength = "Password length should be greater than 5 chars.";
  static const String invalidMobileNum = "Invalid mobile number";
  static const String invalidName = "Invalid name";
  static const String someErrorOccurred = "Some error occurred !!!";

  ///screens

  //List address
  static const String removeAddress = "Do you want to remove Address?";

  //user registration
  static const String nameHintText = 'Name';
  static const String mailHintText = 'Email';
  static const String referralHintText = 'Referral Code?';
  static const String registrationTitle = 'Great! Now hop onboard';
  static const String cautionMsg = 'We collect email to send invoices and notification about your orders.';
  static const String registrationSubTitle =
      'Share your email ID to get invoices, notifications, offers and updates, right in your inbox.';

  //home screen
  static const String serviceLookingFor = "What service are you looking for?";

  // static const String selectUserLoc = "Select an area for service";
  static const String selectUserLoc = "Select your area";

  //add address screen
  static const String houseEditorHintText = 'House/ Flat No. *';
  static const String localityEditorHintText = 'Street name/ Locality *';
  static const String landmarkEditorHintText = 'Landmark';
  static const String areaEditorHintText = 'Select Area *';
  static const String cityEditorHintText = 'City *';
  static const String pinCodeEditorHintText = 'Pin Code *';
  static const String addressTypeEditorHintText = 'Address Type';
  static const String setDefaultAddress = 'Set this as default address';

  /// widgets

  //total_payment and create booking button
  static const String chooseCoupon = "Choose A Coupon Code?";
  static const String couponApplied= "Coupon Applied";


  //build options
  static const String selectService = "Select a service";
  static const String selectHoursOrFrequencyOrCount = "Select hours/ frequency/ total count";
  static const String otherFieldHintText = 'Provide more details about the service you require.';
  static const String customerNote = 'Provide some notes';
  static const String book = "Book";
  static const String other = "OTHER";
  static const String makePayment = "Make Payment";
  static const String pleaseWait = "Please wait....";

  //build schedule
  static const String selectDate = 'Select date';
  static const String selectTime = 'Select time';

  //search location
  static const String searchItemEmpty =
      'Can’t find your area? No worries.\nSelect the area nearest to your location.\neg: If you can’t find ‘Ponnurunni’ select ‘Vyttila’.';
  static const String listArea =
      'We are servicing areas in and around Cochin.\nChoose the serviceable area from the list below';
  static const String searchAreaHintText = 'Enter your area name/ pin code';

  //add address
  static const String addressTypeTitle = 'Address Type';
  static const String addAddressTitle = 'Add Address';
  static const String addressTitle = 'Address';
  static const String updateAddressTitle = 'Update Address';
  static const String edit = 'EDIT';
  static const String change = 'CHANGE';
  static const String changeNumber = 'Enter new mobile no.';
  static const String updateMobNo = 'UPDATE';
  static const String wishToAddAnotherNum = 'Wish to add another contact number?';
  static const String confirmDelete = "Confirm Delete";
  static const String confirmDeleteMsg = 'Are you sure you want to delete this address?';
  static const String confirm ="Confirm" ;
  static const String no ="No" ;
  static const String bookingSlotsEmpty = "Oops..sorry, no booking slots on the selected date.";

  //build payment view (summary view)
  static const String address = 'Address';
  static const String bookingOverView = 'Booking Overview';
  static const String cancellationPolicy = 'Cancellation Policy';
  static const String billingOption = 'Billing Option';
  static const String bookingPhoneNum = "Booking Phone No.";
  static const String otherRequirement = 'Other Requirements';
  static const String paymentDetails = 'Payment Details';
  static const String dateAndTime = 'Date and Time';
  static const String subTotal = 'Sub total';
  static const String discount = 'Discount';
  static const String appliedCouponCode = 'Applied Coupon - CODE';
  static const String totalTax = 'Total Taxes';
  static const String total = 'Total';
  static const String kochi = "kochi";
  static const String redeemPoint = "Redeem Points?";
  static const String redeemPointHintText = "Enter Points?";
  static const String redeemButton = "Redeem";


  ///lists

  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
}
