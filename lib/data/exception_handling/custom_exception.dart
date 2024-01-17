class CustomException implements Exception {
  final String? _prefix;

  CustomException([this._prefix]);

  @override
  String toString() {
    return _prefix.toString();
  }
}
class FetchDataException extends CustomException {
  FetchDataException([String? message]) : super(message ?? "Error in Data Fetch");
}
class BadRequestException extends CustomException {
  BadRequestException([String? message]) : super(message ?? "BadRequest");
}
class UnauthorisedException extends CustomException {
  UnauthorisedException([String? message]) : super(message ?? "Unauthorised Access");
}
class DeviceAlreadyAssignedToSameAccountException extends CustomException {
  DeviceAlreadyAssignedToSameAccountException([String? message]) : super(message ?? "Device Already Assigned to same account");
}
class DeviceAlreadyAssignedToOtherAccountException extends CustomException {
  DeviceAlreadyAssignedToOtherAccountException([String? message]) : super(message ?? "Device Already Assigned to other account");
}
class InvalidButtonException extends CustomException {
  InvalidButtonException([String? message]) : super(message ?? "Device Already Assigned to other account");
}
