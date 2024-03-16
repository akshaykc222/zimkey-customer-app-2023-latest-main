class ResponseModel<T> {
  ResponseModel._();
  factory ResponseModel.success(T value) = SuccessResponse<T>;
  factory ResponseModel.error(T msg) = ErrorResponse<T>;
  factory ResponseModel.unAuthorized() = UnAuthorized<T>;
}

class ErrorResponse<T> extends ResponseModel<T> {
  ErrorResponse(this.msg) : super._();
  final T msg;
}

class UnAuthorized<T> extends ResponseModel<T> {
  UnAuthorized() : super._();
}

class SuccessResponse<T> extends ResponseModel<T> {
  SuccessResponse(this.value) : super._();
  final T value;
}
