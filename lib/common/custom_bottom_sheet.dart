import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const Duration _kBottomSheetSortDuration = Duration(milliseconds: 200);
const Duration _kBottomSheetLongDuration = Duration(milliseconds: 1000);

const double _kMinFlingVelocity = 700.0;
const double _kCloseProgressThreshold = 0.5;

/// A material design bottom sheet.
///
/// There are two kinds of bottom sheets in material design:
///
///  * _Persistent_. A persistent bottom sheet shows information that
///    supplements the primary content of the app. A persistent bottom sheet
///    remains visible even when the user interacts with other parts of the app.
///    Persistent bottom sheets can be created and displayed with the
///    [ScaffoldState.showBottomSheet] function or by specifying the
///    [Scaffold.bottomSheet] constructor parameter.
///
///  * _Modal_. A modal bottom sheet is an alternative to a menu or a dialog and
///    prevents the user from interacting with the rest of the app. Modal bottom
///    sheets can be created and displayed with the [showCustomModalBottomSheet]
///    function.
///
/// The [CustomBottomSheet] widget itself is rarely used directly. Instead, prefer to
/// create a persistent bottom sheet with [ScaffoldState.showBottomSheet] or
/// [Scaffold.bottomSheet], and a modal bottom sheet with [showCustomModalBottomSheet].
///
/// See also:
///
///  * [showBottomSheet] and [ScaffoldState.showBottomSheet], for showing
///    non-modal "persistent" bottom sheets.
///  * [showCustomModalBottomSheet], which can be used to display a modal bottom
///    sheet.
///  * <https://material.io/design/components/sheets-bottom.html>
class CustomBottomSheet extends StatefulWidget {
  /// Creates a bottom sheet.
  ///
  /// Typically, bottom sheets are created implicitly by
  /// [ScaffoldState.showBottomSheet], for persistent bottom sheets, or by
  /// [showCustomModalBottomSheet], for modal bottom sheets.
  const CustomBottomSheet({
    @required this.onClosing,
    @required this.builder,
    Key key,
    this.animationController,
    this.enableDrag = true,
    this.elevation = 0.0,
  })  : assert(enableDrag != null),
        assert(onClosing != null),
        assert(builder != null),
        assert(elevation != null && elevation >= 0.0),
        super(key: key);

  /// The animation that controls the bottom sheet's position.
  ///
  /// The CustomBottomSheet widget will manipulate the position of this animation, it
  /// is not just a passive observer.
  final AnimationController animationController;

  /// Called when the bottom sheet begins to close.
  ///
  /// A bottom sheet might be prevented from closing (e.g., by user
  /// interaction) even after this callback is called. For this reason, this
  /// callback might be call multiple times for a given bottom sheet.
  final VoidCallback onClosing;

  /// A builder for the contents of the sheet.
  ///
  /// The bottom sheet will wrap the widget produced by this builder in a
  /// [Material] widget.
  final WidgetBuilder builder;

  /// If true, the bottom sheet can dragged up and down and dismissed by swiping
  /// downards.
  ///
  /// Default is true.
  final bool enableDrag;

  /// The z-coordinate at which to place this material relative to its parent.
  ///
  /// This controls the size of the shadow below the material.
  ///
  /// Defaults to 0. The value is non-negative.
  final double elevation;

  @override
  _BottomSheetState createState() => _BottomSheetState();

  /// Creates an animation controller suitable for controlling a [CustomBottomSheet].
  static AnimationController createAnimationController(TickerProvider vsync, {bool isStopAnimation}) {
    return AnimationController(
      duration: isStopAnimation?_kBottomSheetLongDuration:_kBottomSheetSortDuration,
      debugLabel: 'CustomBottomSheet',
      vsync: vsync,
    );
  }
}

class _BottomSheetState extends State<CustomBottomSheet> {
  final GlobalKey _childKey = GlobalKey(debugLabel: 'CustomBottomSheet child');

  double get _childHeight {
    final RenderBox renderBox = _childKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  bool get _dismissUnderway =>
      widget.animationController.status == AnimationStatus.reverse;

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_dismissUnderway) {
      return;
    }
    widget.animationController.value -=
        details.primaryDelta / (_childHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dismissUnderway) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dy > _kMinFlingVelocity) {
      final double flingVelocity =
          -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (widget.animationController.value > 0.0) {
        widget.animationController.fling(velocity: flingVelocity);
      }
      if (flingVelocity < 0.0) {
        widget.onClosing();
      }
    } else if (widget.animationController.value < _kCloseProgressThreshold) {
      if (widget.animationController.value > 0.0) {
        widget.animationController.fling(velocity: -1.0);
      }
      widget.onClosing();
    } else {
      widget.animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget bottomSheet = Material(
      key: _childKey,
      elevation: widget.elevation,
      child: widget.builder(context),
    );
    return !widget.enableDrag
        ? bottomSheet
        : GestureDetector(
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: bottomSheet,
            excludeFromSemantics: true,
          );
  }
}

// PERSISTENT BOTTOM SHEETS

// See scaffold.dart

// MODAL BOTTOM SHEETS

class _ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _ModalBottomSheetLayout(this.progress);

  final double progress;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
        maxHeight: constraints.maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_ModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class _ModalBottomSheet<T> extends StatefulWidget {
  const _ModalBottomSheet(
      {Key key, this.route, this.onClosing, this.enableDrag})
      : super(key: key);

  final _ModalBottomSheetRoute<T> route;
  final Function onClosing;
  final bool enableDrag;

  @override
  _ModalBottomSheetState<T> createState() =>
      _ModalBottomSheetState<T>(onClosing, enableDrag: enableDrag);
}

class _ModalBottomSheetState<T> extends State<_ModalBottomSheet<T>> {
  Function onClosing;

  bool enableDrag;

  _ModalBottomSheetState(this.onClosing, {this.enableDrag});

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    String routeLabel;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        routeLabel = '';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        routeLabel = localizations.dialogLabel;
        break;
    }

    return Theme(
      data: ThemeData(
        canvasColor: Colors.transparent,
      ),
      child: GestureDetector(
          excludeFromSemantics: true,
          child: AnimatedBuilder(
              animation: widget.route.animation,
              builder: (BuildContext context, Widget child) {
                // Disable the initial animation when accessible navigation is on so
                // that the semantics are added to the tree at the correct time.
                final double animationValue = mediaQuery.accessibleNavigation
                    ? 1.0
                    : widget.route.animation.value;
                return Semantics(
                  scopesRoute: true,
                  namesRoute: true,
                  label: routeLabel,
                  explicitChildNodes: true,
                  child: ClipRect(
                    child: CustomSingleChildLayout(
                      delegate: _ModalBottomSheetLayout(animationValue),
                      child: CustomBottomSheet(
                        animationController: widget.route._animationController,
                        onClosing: () {
                          if (onClosing != null) {
                            onClosing();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        enableDrag: enableDrag,
                        builder: widget.route.builder,
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}

class _ModalBottomSheetRoute<T> extends PopupRoute<T> {
  _ModalBottomSheetRoute({
    this.builder,
    this.theme,
    this.barrierLabel,
    this.onClosing,
    this.enableDrag,
    this.isStopAnimations,
    RouteSettings settings,
  }) : super(settings: settings);

  final WidgetBuilder builder;
  final ThemeData theme;
  final Function onClosing;
  final bool enableDrag;
  final bool isStopAnimations;

  @override
  Duration get transitionDuration => isStopAnimations?_kBottomSheetLongDuration :_kBottomSheetSortDuration;

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    return _animationController =
        CustomBottomSheet.createAnimationController(navigator.overlay,isStopAnimation: isStopAnimations);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // By definition, the bottom sheet is aligned to the bottom of the page
    // and isn't exposed to the top padding of the MediaQuery.
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: isStopAnimations?_ModalBottomSheetWithoutAnimation<T>(
        builder: builder,
        onClosing: onClosing,
        enableDrag: enableDrag,
      ):_ModalBottomSheet<T>(
        route: this,
        onClosing: onClosing,
        enableDrag: enableDrag,
      ),
    );
    if (theme != null) {
      bottomSheet = Theme(data: theme, child: bottomSheet);
    }
    return isStopAnimations? FadeTransition(opacity: animation, child: bottomSheet): bottomSheet;
  }
}

/// Shows a modal material design bottom sheet.
///
/// A modal bottom sheet is an alternative to a menu or a dialog and prevents
/// the user from interacting with the rest of the app.
///
/// A closely related widget is a persistent bottom sheet, which shows
/// information that supplements the primary content of the app without
/// preventing the use from interacting with the app. Persistent bottom sheets
/// can be created and displayed with the [showBottomSheet] function or the
/// [ScaffoldState.showBottomSheet] method.
///
/// The `context` argument is used to look up the [Navigator] and [Theme] for
/// the bottom sheet. It is only used when the method is called. Its
/// corresponding widget can be safely removed from the tree before the bottom
/// sheet is closed.
///
/// Returns a `Future` that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the modal bottom sheet was closed.
///
/// See also:
///
///  * [CustomBottomSheet], which is the widget normally returned by the function
///    passed as the `builder` argument to [showCustomModalBottomSheet].
///  * [showBottomSheet] and [ScaffoldState.showBottomSheet], for showing
///    non-modal bottom sheets.
///  * <https://material.io/design/components/sheets-bottom.html#modal-bottom-sheet>
Future<T> showCustomModalBottomSheet<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  @required bool isStopAnimation,
  Function onClosing,
  bool enableDrag,
  bool rootNavigator = false,
}) {
  assert(context != null);
  assert(builder != null);
  assert(debugCheckHasMaterialLocalizations(context));
  return Navigator.of(context,rootNavigator: rootNavigator).push(
      _ModalBottomSheetRoute<T>(
        isStopAnimations: isStopAnimation != null ? isStopAnimation : false,
        builder: builder,
        onClosing: onClosing,
        enableDrag: enableDrag != null ? enableDrag : true,
        theme: Theme.of(context, shadowThemeOnly: true),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
      ));
}

/// Shows a persistent material design bottom sheet in the nearest [Scaffold].
///
/// Returns a controller that can be used to close and otherwise manipulate the
/// bottom sheet.
///
/// To rebuild the bottom sheet (e.g. if it is stateful), call
/// [PersistentBottomSheetController.setState] on the controller returned by
/// this method.
///
/// The new bottom sheet becomes a [LocalHistoryEntry] for the enclosing
/// [ModalRoute] and a back button is added to the appbar of the [Scaffold]
/// that closes the bottom sheet.
///
/// To create a persistent bottom sheet that is not a [LocalHistoryEntry] and
/// does not add a back button to the enclosing Scaffold's appbar, use the
/// [Scaffold.bottomSheet] constructor parameter.
///
/// A persistent bottom sheet shows information that supplements the primary
/// content of the app. A persistent bottom sheet remains visible even when
/// the user interacts with other parts of the app.
///
/// A closely related widget is a modal bottom sheet, which is an alternative
/// to a menu or a dialog and prevents the user from interacting with the rest
/// of the app. Modal bottom sheets can be created and displayed with the
/// [showCustomModalBottomSheet] function.
///
/// The `context` argument is used to look up the [Scaffold] for the bottom
/// sheet. It is only used when the method is called. Its corresponding widget
/// can be safely removed from the tree before the bottom sheet is closed.
///
/// See also:
///
///  * [CustomBottomSheet], which is the widget typically returned by the `builder`.
///  * [showCustomModalBottomSheet], which can be used to display a modal bottom
///    sheet.
///  * [Scaffold.of], for information about how to obtain the [BuildContext].
///  * <https://material.io/design/components/sheets-bottom.html#standard-bottom-sheet>
PersistentBottomSheetController<T> showBottomSheet<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
}) {
  assert(context != null);
  assert(builder != null);
  return Scaffold.of(context).showBottomSheet<T>(builder);
}


class _ModalBottomSheetWithoutAnimation<T> extends StatefulWidget {
  const _ModalBottomSheetWithoutAnimation(
      {Key key, this.onClosing, this.enableDrag,this.builder})
      : super(key: key);


  final Function onClosing;
  final bool enableDrag;
  final WidgetBuilder builder;

  @override
  _ModalBottomSheetState1<T> createState() =>
      _ModalBottomSheetState1<T>(onClosing, enableDrag: enableDrag);
}

class _ModalBottomSheetState1<T> extends State<_ModalBottomSheetWithoutAnimation<T>> with TickerProviderStateMixin{
  Function onClosing;

  bool enableDrag;

  AnimationController _controller;
  Animation<double> curve;

  _ModalBottomSheetState1(this.onClosing, {this.enableDrag});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 0), vsync: this);
    curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final MaterialLocalizations localizations =
    MaterialLocalizations.of(context);
    String routeLabel;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        routeLabel = '';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        routeLabel = localizations.dialogLabel;
        break;
    }

    return Theme(
      data: ThemeData(
        canvasColor: Colors.transparent,
      ),
      child: GestureDetector(
          excludeFromSemantics: true,
          child: AnimatedBuilder(
              animation:curve,
              builder: (BuildContext context, Widget child) {
                // Disable the initial animation when accessible navigation is on so
                // that the semantics are added to the tree at the correct time.
                final double animationValue = mediaQuery.accessibleNavigation
                    ? 1.0
                    : curve.value;
                return Semantics(
                  scopesRoute: true,
                  namesRoute: true,
                  label: routeLabel,
                  explicitChildNodes: true,
                  child: ClipRect(
                    child: CustomSingleChildLayout(
                      delegate: _ModalBottomSheetLayout(animationValue),
                      child: CustomBottomSheet(
                        animationController: _controller,
                        onClosing: () {
                          if (onClosing != null) {
                            onClosing();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        enableDrag: enableDrag,
                        builder:widget.builder,
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}

