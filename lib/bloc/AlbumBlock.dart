import 'dart:async';

import 'package:itunesmusicapp/common/app_config_base.dart';
import 'package:itunesmusicapp/common/itune_client.dart';
import 'package:itunesmusicapp/models/album.dart';
import 'package:itunesmusicapp/service/album_network_service.dart';
import 'package:itunesmusicapp/utils/network_manager_impl.dart';

/// Block for fetch album data from api and provide data to UI
class AlbumBloc {
  AlbumNetworkService _albumNetworkService;
  StreamController _albumDataController;
  List<Album> _albumList;
  NetworkManagerImpl _networkManagerImpl;

  StreamSink<List<Album>> get albumDataSink => _albumDataController.sink;

  Stream<List<Album>> get albumDataStream => _albumDataController.stream;

  AlbumBloc() {
    _albumDataController = StreamController<List<Album>>();
    _albumNetworkService =
        AlbumNetworkService(ITuneClient(), AppConfigBase.iTunesAlbumHost);
    _networkManagerImpl = NetworkManagerImpl();
  }

  /*Fetch all album list from api and send to UI*/
  fetchAlbumList() async {
    try {
      NetworkState networkState = await _networkManagerImpl.getNetworkState();
      if (networkState != NetworkState.off) {
        albumDataSink.add(null);
        _albumList = await _albumNetworkService.getAlbumList();
        albumDataSink.add(_albumList);
      }
      else {
        albumDataSink.addError("No internet connection available");
      }
    } catch (e) {
      albumDataSink.addError("Unable to fetch data from api");
      print(e);
    }
  }

  /*Sort data which is new released*/
  sortAlbumListToNewest() async {
    NetworkState networkState = await _networkManagerImpl.getNetworkState();
    if (networkState != NetworkState.off) {
      _albumList?.sort((albumItem1, albumItem2) {
        return _convertDate(albumItem2.releaseDate).compareTo(_convertDate(albumItem1.releaseDate));
      });
      albumDataSink.add(_albumList);
    }
    else {
      albumDataSink.addError("No internet connection available");
    }
  }

  /*Sort data which is oldest based on released date*/
  sortAlbumListToOldest() async {
    NetworkState networkState = await _networkManagerImpl.getNetworkState();
    if (networkState != NetworkState.off) {
      _albumList?.sort((albumItem1, albumItem2) {
        return _convertDate(albumItem1.releaseDate).compareTo(_convertDate(albumItem2.releaseDate));
      });
      albumDataSink.add(_albumList);
    }
    else {
      albumDataSink.addError("No internet connection available");
    }
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
