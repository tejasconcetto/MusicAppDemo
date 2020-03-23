import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itunesmusicapp/bloc/AlbumBlock.dart';
import 'package:itunesmusicapp/common/custom_bottom_sheet.dart';
import 'package:itunesmusicapp/common/screenutil.dart';
import 'package:itunesmusicapp/models/album.dart';
import 'package:itunesmusicapp/ui/album_card.dart';
import 'package:itunesmusicapp/ui/albumn_card_loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///Display all album list
class HomeAlbumListPage extends StatefulWidget {
  HomeAlbumListPage({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<HomeAlbumListPage> {
  AlbumBloc _albumBloc;
  RefreshController _refreshController;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _refreshController = RefreshController();
    _albumBloc = AlbumBloc();
    _albumBloc.fetchAlbumList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height / 4;
    return MaterialApp(
      title: 'Music App',
      home: Scaffold(
        backgroundColor: Color(0xff2C2B2B),
        appBar: AppBar(
          textTheme: TextTheme(
              title: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: "Proxima Nova")),
          backgroundColor: Colors.white,
          title: Text('Music App'),
          centerTitle: true,
          actions: <Widget>[_buildMoreOption()],
        ),
        body: SafeArea(
          child: SmartRefresher(
            header: MaterialClassicHeader(
              backgroundColor: Colors.white,
              color: Colors.black,
            ),
            controller: _refreshController,
            enablePullDown: true,
            onRefresh: _onRefresh,
            child: ListView(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              children: <Widget>[
                StreamBuilder<List<Album>>(
                  stream: _albumBloc.albumDataStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _albumGridCards(snapshot.data
                          .map((album) => Container(
                                height: height,
                                child: AlbumCard(album),
                              ))
                          .toList());
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return _albumGridLoadingCards();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*Generate grid view and display data into two column*/
  Widget _albumGridCards(List<Widget> items) {
    int count = 2;
    double _childAspectRatioTab = 150 / 200;

    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: count,
      mainAxisSpacing: 25,
      crossAxisSpacing: 21,
      childAspectRatio: _childAspectRatioTab,
      padding: EdgeInsets.all(ScreenUtil.getResponsiveWidthOfWidget(
          20, MediaQuery.of(context).size.width)),
      children: items,
    );
  }

  /*When data is fetching from api then display this like place holder*/
  Widget _albumGridLoadingCards() {
    var loadingCards =
        [0, 1, 2, 3, 4, 5].map((_) => AlbumCardLoading()).toList();
    return _albumGridCards(loadingCards);
  }

  /*Created widget for more options for display it on App bar*/
  Widget _buildMoreOption() {
    return GestureDetector(
      onTap: () => _buildActionSheetForSortAlbumList(),
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil.getResponsiveWidthOfWidget(
            15, MediaQuery.of(context).size.width)),
        child: Icon(Icons.more_vert, size: 16, color: Colors.black),
      ),
    );
  }

  /*Created bottom sheet for filtering data based on released date*/
  void _buildActionSheetForSortAlbumList() async {
    final ThemeData appTheme = ThemeData(
        cupertinoOverrideTheme:
            CupertinoThemeData(brightness: Brightness.light));
    await showCustomModalBottomSheet(
      context: context,
      isStopAnimation: false,
      rootNavigator: true,
      builder: (BuildContext context) {
        return Theme(
          data: appTheme,
          child: CupertinoActionSheet(
            actions: [
              Container(
                  color: Colors.white,
                  child: CupertinoActionSheetAction(
                    child: Text('Oldest',
                        style: TextStyle(
                          fontFamily: "Proxima Nova",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        )),
                    onPressed: () {
                      _albumBloc.sortAlbumListToOldest();
                      Navigator.pop(context);
                    },
                  )),
              Container(
                color: Colors.white,
                child: CupertinoActionSheetAction(
                  child: Text(
                    "Latest",
                    style: TextStyle(
                      fontFamily: "Proxima Nova",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    _albumBloc.sortAlbumListToNewest();
                    Navigator.pop(context);
                  },
                ),
              )
            ],
            cancelButton: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              child: CupertinoActionSheetAction(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: "Proxima Nova",
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        );
      },
    );
  }

  /*Fetched latest album list when user perform pull to refresh operation*/
  void _onRefresh() {
    _albumBloc.fetchAlbumList();
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    _albumBloc.dispose();
    super.dispose();
  }
}
