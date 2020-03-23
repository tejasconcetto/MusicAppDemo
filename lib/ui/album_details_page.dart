import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itunesmusicapp/common/screenutil.dart';
import 'package:itunesmusicapp/models/album.dart';
import 'package:itunesmusicapp/ui/album_details_header.dart';
import 'package:url_launcher/url_launcher.dart';

///display all the details of specific album
class AlbumDetailsPage extends StatefulWidget {
  final Album album;

  const AlbumDetailsPage({this.album});

  @override
  _AlbumDetailsPageState createState() => _AlbumDetailsPageState();
}

class _AlbumDetailsPageState extends State<AlbumDetailsPage> {
  final _scrollController = ScrollController();
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff2C2B2B),
      body: SafeArea(child: buildMainContent(widget.album)),
    );
  }

  Widget buildMainContent(Album album) {
    return CustomScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        AlbumDetailsHeader(
          scrollController: _scrollController,
          album: album,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.album?.name ?? '',
                  style: TextStyle(
                    fontFamily: "Proxima Nova",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                SizedBox(
                    height:
                        ScreenUtil.getResponsiveHeightOfWidget(10, size.width)),
                Text(
                  widget.album?.artistName ?? '',
                  style: TextStyle(
                    fontFamily: "Proxima Nova",
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                    height:
                        ScreenUtil.getResponsiveHeightOfWidget(30, size.width)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Artist URL :',
                      style: TextStyle(
                        fontFamily: "Proxima Nova",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 2),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _launchURL(widget.album?.artistUrl ?? '');
                        },
                        child: Text(
                          widget.album?.artistUrl ?? '',
                          style: TextStyle(
                            fontFamily: "Proxima Nova",
                            color: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                    height:
                        ScreenUtil.getResponsiveHeightOfWidget(30, size.width)),
                Text(
                  'Other Albums :',
                  style: TextStyle(
                    fontFamily: "Proxima Nova",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                    height:
                        ScreenUtil.getResponsiveHeightOfWidget(10, size.width)),
                ListView.builder(
                    itemBuilder: (context, index) {
                      return _buildOtherCategories(widget.album?.genres[index]);
                    },
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.album?.genres?.length ?? 0),
                SizedBox(
                    height:
                        ScreenUtil.getResponsiveHeightOfWidget(30, size.width)),
                Row(
                  children: <Widget>[
                    Text(
                      'Released :',
                      style: TextStyle(
                        fontFamily: "Proxima Nova",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 2),
                    Text(
                      _convertDateString(widget.album?.releaseDate ?? ''),
                      style: TextStyle(
                        fontFamily: "Proxima Nova",
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                SizedBox(
                    height:
                        ScreenUtil.getResponsiveHeightOfWidget(5, size.width)),
                Text(
                  widget.album?.copyright ?? '',
                  style: TextStyle(
                    fontFamily: "Proxima Nova",
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /*It will convert date string format to another string format*/
  String _convertDateString(String date) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    DateTime dateTime = dateFormat.parse(date);
    DateFormat dateFormatConverted = DateFormat("dd MMM yyyy");
    return dateFormatConverted.format(dateTime);
  }

  /*Used to open url from our app*/
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /*Create UI for other album category*/
  Widget _buildOtherCategories(Genres genres) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Name :',
                style: TextStyle(
                  fontFamily: "Proxima Nova",
                  color: Color(0xff191919),
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              SizedBox(width: 2),
              Expanded(
                child: Text(
                  genres?.name ?? '',
                  style: TextStyle(
                    fontFamily: "Proxima Nova",
                    color: Color(0xff181818).withOpacity(0.7),
                    fontWeight: FontWeight.normal,
                    fontSize: 10,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
              height: ScreenUtil.getResponsiveHeightOfWidget(3, size.width)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'URL :',
                style: TextStyle(
                  fontFamily: "Proxima Nova",
                  color: Color(0xff191919),
                  fontWeight: FontWeight.bold,
                  fontSize: 10,                ),
              ),
              SizedBox(width: 2),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _launchURL(genres?.url ?? '');
                  },
                  child: Text(
                    genres?.url ?? '',
                    style: TextStyle(
                      fontFamily: "Proxima Nova",
                      color: Color(0xff0645AD),
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }
}
