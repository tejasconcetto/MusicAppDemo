
import 'package:itunesmusicapp/common/itune_client.dart';

/// This provides the base network service api for communicating with the network;
abstract class BaseNetworkService {
  final ITuneClient client;
  final String host;

  BaseNetworkService(this.client, this.host);

  bool isSuccessful(int responseCode) => responseCode ~/ 100 == 2;
}

class HttpException implements Exception {
  final String responseBody;
  final int responseCode;

  HttpException(this.responseCode, this.responseBody);
}

class NetworkException implements Exception {
  final NonHttpNetworkError type;
  final String message;

  NetworkException(this.type, this.message);
}

enum NonHttpNetworkError { ConnectionError, HeaderParsingError }
