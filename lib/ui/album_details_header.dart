import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:itunesmusicapp/common/screenutil.dart';
import 'package:itunesmusicapp/models/album.dart';

///It will show album details header with animations
class AlbumDetailsHeader extends StatefulWidget {
  final Album album;
  final scrollController;

  AlbumDetailsHeader({
    @required this.scrollController,
    @required this.album,
  });

  @override
  _AlbumDetailsHeaderState createState() => _AlbumDetailsHeaderState();
}

class _AlbumDetailsHeaderState extends State<AlbumDetailsHeader>
    with TickerProviderStateMixin {
  AnimationController _colorAnimationController;
  Animation _colorTween;
  int _transparency = 0;
  Size size;

  @override
  void initState() {
    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    widget.scrollController.addListener(_changeColorOnScroll);
    super.initState();
  }

  bool get _isAppBarExpanded =>
      widget.scrollController.hasClients &&
      widget.scrollController.offset > (200 - kToolbarHeight);

  void _changeColorOnScroll() {
    if (_isAppBarExpanded) {
      if (!_colorAnimationController.isAnimating) {
        _colorAnimationController.forward();
      }
    } else {
      if (!_colorAnimationController.isAnimating) {
        _colorAnimationController.reverse();
      }
    }
  }

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_colorAnimationController);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final double upperBound =
        ScreenUtil.getResponsiveHeightOfWidget(300, size.width) * 0.8;

    return SliverAppBar(
        pinned: true,
        floating: false,
        snap: false,
        centerTitle: true,
        stretch: true,
        title: AnimatedBuilder(
            animation: widget.scrollController,
            builder: (context, snapshot) {
              final double offset = widget.scrollController.offset;
              if (offset >= upperBound) {
                _transparency = 255;
              } else {
                _transparency = 0;
              }
              return Opacity(
                opacity: _transparency / 255,
                child: Text(
                  widget.album?.name ?? "",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: "Proxima Nova",
                  ),
                ),
              );
            }),
        backgroundColor: Colors.white,
        expandedHeight: ScreenUtil.getResponsiveHeightOfWidget(300, size.width),
        leading: _buildBackButton(),
        flexibleSpace: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: Color(0xfff4f4f4),
              statusBarBrightness: Brightness.light,
              systemNavigationBarIconBrightness: Brightness.dark),
          child: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: <Widget>[
                Hero(
                  tag: widget.album.id,
                  child: Image.network(
                    widget?.album?.artworkUrl100 ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(color: Colors.black.withOpacity(0.2)),
              ],
            ),
          ),
        ));
  }

  /*Create back button widget*/
  Widget _buildBackButton() {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => InkWell(
        child: Padding(
          padding: EdgeInsets.only(
              left: ScreenUtil.getResponsiveWidthOfWidget(
                  18, MediaQuery.of(context).size.width)),
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            height: ScreenUtil.getResponsiveHeightOfWidget(
                32, MediaQuery.of(context).size.width),
            width: ScreenUtil.getResponsiveHeightOfWidget(
                32, MediaQuery.of(context).size.width),
            child: Icon(
              Icons.arrow_back_ios,
              size: ScreenUtil.getResponsiveHeightOfWidget(
                  18, MediaQuery.of(context).size.width),
              color: _colorTween.value,
            ),
          ),
        ),
        onTap: () => Navigator.of(context).pop(),
      ),
    );
  }
}
