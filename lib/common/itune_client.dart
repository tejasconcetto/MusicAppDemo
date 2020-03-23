
import 'package:http/http.dart' as http;

///Used to define all get, post, put method globally and call api using http client
class ITuneClient {

  http.Client client = http.Client();

  /// TODO
  /// This does not need to be called from outside the iTune_client and has to
  /// be made private.
  static String addQueryParamsToUrl(String originalUrl, Map<String, String> queryParams) {
    assert(originalUrl != null);
    var oldUrl = Uri.parse(originalUrl);
    var oldQueryParams = oldUrl.queryParameters;
    var newQueryParams = {
      ...oldQueryParams,
      if (queryParams != null && queryParams.isNotEmpty) ...queryParams,
    };
    var newUrl = oldUrl.replace(queryParameters: newQueryParams);
    return newUrl.toString();
  }

  Future<http.Response> get(url, {Map<String, String> headers, Map<String, String> queryParams}) {
    final newUrl = addQueryParamsToUrl(url, queryParams);

    return client.get(newUrl, headers: headers);
  }
}
