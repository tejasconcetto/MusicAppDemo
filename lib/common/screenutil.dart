import 'package:flutter/material.dart';

///this utility class is used to return responsive height and width according to screen size
class ScreenUtil {
  static final ScreenUtil instance = ScreenUtil();

  static ScreenUtil getInstance() {
    return instance;
  }

  double getAspectHeight(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.width / percentage;
  }

  /// It will use to get the height of widget.
  /// height of widget will be different base on device size.
  static double getResponsiveHeightOfWidget(int height, double screenWidth) {
    return screenWidth * height / 375.0;
  }

  /// It will use to get the width of widget.
  /// width of widget will be different base on device size.
  static double getResponsiveWidthOfWidget(int width, double screenWidth) {
    return screenWidth * width / 375.0;
  }

  /// It will use to get the Pixel based on screen size.
  static double getHorizontalPixel(Size size, double value) {
    return (value * size.width) / 375;
  }
}