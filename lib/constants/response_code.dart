class ResponseCode {
  ResponseCode._();

  //General
  static const int success = 200;
  static const int created = 201;
  static const int unAuthorised = 401;
  // static const int badRequest = 403;
  static const int deviceAlreadyAssignedToSameAccount = 202;
  static const int deviceAlreadyAssignedToOtherAccount = 403;
  static const int invalidButton = 406;
  static const int notFound = 404;
  static const int internalServerError = 500;
  static const int authWrongCredential = 442;
}
