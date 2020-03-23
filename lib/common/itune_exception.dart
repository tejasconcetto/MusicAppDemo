import 'package:itunesmusicapp/service/base_network_service.dart';

/// This error type can be exposed to the app, so that the upstream ui part should
/// not care about the actual result of the api or service call.
/// The error data meaningful for the UI to take action upon is grouped here
enum ErrorType {
  NotStaleError,
  HeaderParsingError,
  Unauthorised,
  ConnectionError,
  ServerError,
  BadRequest,
  Other,
  DataIsNotAvailable,

}

///Handled all exception which are raised during api call
class ITuneException extends Error implements Exception {
  final ErrorType type;
  final String msg;
  final dynamic data;

  ITuneException(this.type, this.msg, [this.data]);

  factory ITuneException.make(Exception e) {
    if (e is HttpException) {
      switch (e.responseCode) {
        case 304:
          {
            return ITuneException(ErrorType.NotStaleError, "Cached resource is still valid and can be used");
          }
        case 400:
          {
            return ITuneException(ErrorType.BadRequest, e.responseBody);
          }
        case 401:
        case 403:
          {
            return ITuneException(ErrorType.Unauthorised, e.responseBody);
          }
          break;
        case 404:
          {
            return ITuneException(ErrorType.DataIsNotAvailable, e.responseBody);
          }
        case 500:
          {
            return ITuneException(ErrorType.ServerError, e.responseBody);
          }
          break;
        case 503:
          {
            return ITuneException(ErrorType.ConnectionError, e.responseBody);
          }
          break;
      }
    }
    return ITuneException(ErrorType.Other, e.toString());
  }


  StackTrace get stackTrace {
    return StackTrace.fromString("Error type: ${type.toString().split('.').last} Message: $msg");
  }

  String get message => msg;

  @override
  String toString() {
    return "Error type: ${type.toString().split('.').last} Message: $msg";
  }


}
