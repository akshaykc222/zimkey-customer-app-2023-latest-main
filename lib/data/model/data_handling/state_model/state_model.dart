class ResponseModel<T>{
  ResponseModel._();
  factory ResponseModel.success(T value) = SuccessResponse<T>;
  factory ResponseModel.error(T msg) = ErrorResponse<T>;
}

class ErrorResponse<T> extends ResponseModel<T> {
  ErrorResponse(this.msg) : super._();
  final T msg;
}

class SuccessResponse<T> extends ResponseModel<T> {
  SuccessResponse(this.value) : super._();
  final T value;
}