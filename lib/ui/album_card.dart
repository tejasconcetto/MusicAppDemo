import 'package:flutter/material.dart';
import 'package:itunesmusicapp/common/bottom_top_navigation_route_builder.dart';
import 'package:itunesmusicapp/models/album.dart';

import 'album_details_page.dart';

class AlbumCard extends StatelessWidget {
  final Album _album;

  const AlbumCard(this._album);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final double cardWidth = deviceWidth * 0.416;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            BottomTopNavigationRouteBuilder(
                page: AlbumDetailsPage(album: _album),
                settings: RouteSettings()));
      },
      child: Container(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSquareImage(_album, cardWidth),
            SizedBox(height: 10),
            _buildTitleAndArtistName(_album, context)
          ],
        ),
      ),
    );
  }

  /*Build container for display image*/
  _buildSquareImage(Album album, double width) {
    return Container(
        width: width,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              _buildImage(album?.artworkUrl100 ?? ''),
              _buildGradient()
            ],
          ),
        ));
  }

  /* Fetch image from network*/
  _buildImage(String imageUrl) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        child: Hero(
          tag: _album.id,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /* Create gradient for image view*/
  Widget _buildGradient() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            gradient: LinearGradient(
                begin: Alignment(0.5, 0.3484744510135135),
                end: Alignment(0.5, 1),
                colors: [
                  const Color(0x0a000000),
                  const Color(0x26000000),
                  const Color(0x33000000)
                ])));
  }

  /* Create column for display album name with artist name*/
  Widget _buildTitleAndArtistName(Album album, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildTitle(album, context),
        SizedBox(height: 2),
        _buildArtistName(album?.artistName ?? '', context),
      ],
    );
  }

  /* Create text widget for display album name*/
  Widget _buildTitle(Album album, BuildContext context) {
    return Text(album?.name ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: "Proxima Nova",
            fontSize: 15.0));
  }

  /* Create text widget for display artist name*/
  Widget _buildArtistName(String user, BuildContext context) {
    return Flexible(
        child: Text(user,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w400,
                fontFamily: "Proxima Nova",
                fontSize: 12.0)));
  }
}
