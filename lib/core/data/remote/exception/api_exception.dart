import 'app_exception.dart';

class FetchDataException extends AppException {
  FetchDataException({required String message})
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised Request: ");
}

class InvalidInputException extends AppException {
  InvalidInputException({required String message})
      : super(message, "Invalid Input: ");
}
