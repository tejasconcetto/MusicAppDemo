import 'package:flutter/material.dart';
import 'package:itunesmusicapp/common/screenutil.dart';

class AlbumCardLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    double cardWidth = deviceWidth * 0.416;
    double aspectRatio = 1 / 1;

    return Container(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
              aspectRatio: aspectRatio,
              child: Container(
                width: cardWidth,
                decoration: BoxDecoration(
                  color: Color(0xff918F8F).withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              )),
          SizedBox(
              height: ScreenUtil.getResponsiveWidthOfWidget(
                  10, MediaQuery.of(context).size.width)),
          Container(
              width: cardWidth * 0.75,
              height: ScreenUtil.getResponsiveWidthOfWidget(
                  11, MediaQuery.of(context).size.width),
              decoration: BoxDecoration(
                color: Color(0xff918F8F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              )),
          SizedBox(
              height: ScreenUtil.getResponsiveWidthOfWidget(
                  4, MediaQuery.of(context).size.width)),
          Container(
              width: cardWidth * 0.5,
              height: ScreenUtil.getResponsiveWidthOfWidget(
                  9, MediaQuery.of(context).size.width),
              decoration: BoxDecoration(
                color: Color(0xff918F8F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ))
        ],
      ),
    );
  }
}
