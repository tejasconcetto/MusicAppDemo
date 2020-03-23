import 'dart:convert';

import 'package:itunesmusicapp/common/itune_client.dart';
import 'package:itunesmusicapp/common/itune_exception.dart';
import 'package:itunesmusicapp/models/album.dart';

import '../service/base_network_service.dart';

class AlbumNetworkService extends BaseNetworkService {
  AlbumNetworkService(ITuneClient client, String host) : super(client, host);

  /// get all album list from api
  Future<List<Album>> getAlbumList() async {
    final requestUrl =
        '$host/api/v1/in/apple-music/new-releases/all/100/non-explicit.json';
    try {
      final response = await client.get(requestUrl);
      if (isSuccessful(response.statusCode)) {
        Iterable items =
            json.decode(response.body)["feed"]["results"];
        return items.map((item) => Album.fromJson(item)).toList();
      } else {
        throw ITuneException.make(
            HttpException(response.statusCode, response.body));
      }
    } catch (e) {
      throw ITuneException.make(NetworkException(
          NonHttpNetworkError.ConnectionError,
          "Network error while calling the network service"));
    }
  }


}
