import 'package:flutter/material.dart';

///This is used to provide screen transition bottom to top animations
class BottomTopNavigationRouteBuilder extends PageRouteBuilder {
  final Widget page;
  final RouteSettings settings;

  BottomTopNavigationRouteBuilder({this.page, this.settings})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          settings: settings,
          opaque: false,
          transitionDuration: Duration(milliseconds: 200),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
                reverseCurve: Curves.ease.flipped,
              ),
            ),
            child: child,
          ),
        );
}
