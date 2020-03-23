import 'dart:async';

import 'package:itunesmusicapp/common/app_config_base.dart';
import 'package:itunesmusicapp/common/itune_client.dart';
import 'package:itunesmusicapp/models/album.dart';
import 'package:itunesmusicapp/service/album_network_service.dart';

/// Block for fetch album data from api and provide data to UI
class AlbumBloc {
  AlbumNetworkService _albumNetworkService;
  StreamController _albumDataController;
  List<Album> _albumList;

  StreamSink<List<Album>> get albumDataSink =>
      _albumDataController.sink;

  Stream<List<Album>> get albumDataStream =>
      _albumDataController.stream;

  AlbumBloc() {
    _albumDataController = StreamController<List<Album>>();
    _albumNetworkService = AlbumNetworkService(ITuneClient(), AppConfigBase.iTunesAlbumHost);
  }

  /*Fetch all album list from api and send to UI*/
  fetchAlbumList() async {
    try {
      albumDataSink.add(null);
      _albumList = await _albumNetworkService.getAlbumList();
      albumDataSink.add(_albumList);
    } catch (e) {
      albumDataSink.add(null);
      print(e);
    }
  }

  /*Sort data which is new released*/
  sortAlbumListToNewest() {
    _albumList?.sort((a,b) {
      return _convertDate(b.releaseDate).compareTo(_convertDate(a.releaseDate));
    });
    albumDataSink.add(_albumList);
  }

  /*Sort data which is oldest based on released date*/
  sortAlbumListToOldest() {
    _albumList?.sort((a,b) {
      return _convertDate(a.releaseDate).compareTo(_convertDate(b.releaseDate));
    });
    albumDataSink.add(_albumList);
  }

  /*Convert string date to DateTime*/
  DateTime _convertDate(String dateString) {
    return DateTime.parse(dateString);
  }

  /*All stream is closed when called this method*/
  dispose() {
    _albumDataController?.close();
  }
}