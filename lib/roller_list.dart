library roller_list;

import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:roller_list/one_direction_scroll_physics.dart';

class RollerList extends StatefulWidget {
  final int? initialIndex;
  final double visibilityRadius;
  final ValueChanged<int>? onSelectedIndexChanged;
  final VoidCallback? onScrollStarted;
  final List<Widget>? items;
  final IndexedWidgetBuilder? builder;
  final double? width, height;
  final Color dividerColor;
  final bool enabled;
  final int? length;
  final double dividerThickness;
  final ScrollType scrollType;

  ///You should provide either [items] list or [builder] function and [length]. Priority is
  ///given to builder function. It is better to provide [width] and [height]. If these
  ///parameters are omitted, widget will try to calculate based on the
  ///[initialIndex] item size, but if one parameter is set it would not be
  ///overwritten. [visibilityRadius] means how many widgets are visible on each
  ///side of the selected widget. [key] can be used to set selected item
  ///programmatically via Global key. If [enabled], user can scroll it, otherwise
  ///scrolling can be done only programmatically. [onSelectedIndexChanged] is
  ///called when scrolling is finished.
  ///[builder] function will get index with infinity range, so to get roller
  ///scroll effect it is required to use index % <list length>
  ///[scrollType] is required to fix scroll direction to only bottom direction
  ///or top direction
  const RollerList({
    this.items,
    this.builder,
    this.length,
    this.onSelectedIndexChanged,
    this.initialIndex,
    this.visibilityRadius = 1.0,
    this.width,
    this.height,
    this.dividerColor = Colors.black,
    this.dividerThickness = 1.0,
    this.enabled = true,
    this.scrollType = ScrollType.bothDirections,
    Key? key,
    this.onScrollStarted,
  })  : assert(items != null || (builder != null && length != null)),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RollerListState();
  }
}

class RollerListState extends State<RollerList> {
  final InfiniteScrollController scrollController = InfiniteScrollController();
  ScrollPhysics? _scrollPhysics;
  late int _currentIndex;
  bool _programedJump = false;
  bool _oneTimeAction = false;
  double? _itemHeight;
  double? _itemWidth;
  int get _length => widget.length ?? widget.items!.length;

  @override
  void initState() {
    super.initState();
    if (widget.scrollType == ScrollType.goesOnlyBottom) {
      _scrollPhysics = OneDirectionScrollPhysics(goesOnlyBottom: true);
    } else if (widget.scrollType == ScrollType.goesOnlyTop) {
      _scrollPhysics = OneDirectionScrollPhysics(goesOnlyBottom: false);
    }
    _itemWidth = widget.width;
    _itemHeight = widget.height;
    _currentIndex = widget.initialIndex ?? 0;
    if (_itemHeight == null || _itemWidth == null) {
      WidgetsBinding.instance.addPostFrameCallback(_calculateHeight);
    } else if (widget.initialIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback(_scrollAfterBuild);
    }
  }

  void _calculateHeight(_) {
    setState(() {
      _itemHeight ??= context.size!.height;
      _itemWidth ??= context.size!.width;
    });
    if (widget.initialIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback(_scrollAfterBuild);
    }
  }

  void _scrollAfterBuild(_) {
    scrollController.jumpTo((widget.initialIndex! - 1) * _itemHeight!);
  }

  @override
  Widget build(BuildContext context) {
    if (_itemHeight == null || _itemWidth == null) {
      if (widget.builder == null) {
        return widget.items![selectedIndex];
      } else {
        return widget.builder!(context, _currentIndex);
      }
    } else {
      final Widget list = NotificationListener(
        onNotification: _onNotification,
        child: SizedBox(
          height: _itemHeight! * (1 + widget.visibilityRadius * 2) + 2,
          width: _itemWidth,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: InfiniteListView.builder(
                  physics: _scrollPhysics,
                  controller: scrollController,
                  itemExtent: _itemHeight,
                  itemBuilder: widget.builder ??
                      (BuildContext context, int index) {
                        int inListIndex = index % widget.items!.length;
                        return widget.items![inListIndex];
                      },
                ),
              ),
              Positioned(
                bottom: widget.visibilityRadius * _itemHeight!,
                left: 0,
                right: 0,
                child: Container(
                  height: widget.dividerThickness,
                  width: _itemWidth,
                  color: widget.dividerColor,
                ),
              ),
              Positioned(
                top: widget.visibilityRadius * _itemHeight!,
                left: 0,
                right: 0,
                child: Container(
                  height: widget.dividerThickness,
                  width: _itemWidth,
                  color: widget.dividerColor,
                ),
              ),
            ],
          ),
        ),
      );
      if (widget.enabled) {
        return list;
      } else {
        return AbsorbPointer(
          child: list,
        );
      }
    }
  }

  int get selectedIndex => _currentIndex % _length;

  bool _onNotification(Notification notification) {
    if (notification is ScrollEndNotification) {
      _oneTimeAction = false;
      if (_programedJump) {
        _programedJump = false;
        return true;
      } else {
        setState(() {
          _currentIndex = _findSelectedItem(notification.metrics.pixels);
        });
        if (widget.onSelectedIndexChanged != null) {
          widget.onSelectedIndexChanged!(selectedIndex);
        }
        double offsetDifference = scrollController.offset % _itemHeight!;
        if (offsetDifference.abs() > 1.0) {
          _programedJump = true;
          double jumpLength =
              (_currentIndex - widget.visibilityRadius) * _itemHeight!;
          WidgetsBinding.instance
              .addPostFrameCallback((duration) => smoothScrollTo(jumpLength));
        }
        return true;
      }
    } else if (notification is ScrollUpdateNotification) {
      if (!_programedJump &&
          !_oneTimeAction &&
          widget.onScrollStarted != null) {
        _oneTimeAction = true;
        widget.onScrollStarted!();
      }
    }
    return false;
  }

  ///scroll to [scrollLength] position in dp. Animation parameters [curve] and
  ///[duration] can be provided.
  void smoothScrollTo(double scrollLength,
      {Curve curve = Curves.easeIn,
      Duration duration = const Duration(milliseconds: 150)}) {
    scrollController.animateTo(
      scrollLength,
      curve: curve,
      duration: duration,
    );
  }

  ///scroll to item [index]. [index] can be outside of [items] values. So it
  ///can animate multiple rotations of the wheel. Animation parameters [curve] and
  //  ///[duration] can be provided.
  void smoothScrollToIndex(int index,
      {Curve curve = Curves.easeIn,
      Duration duration = const Duration(milliseconds: 150)}) {
    scrollController.animateTo(
      _getOffsetForSelection(index),
      curve: curve,
      duration: duration,
    );
  }

  double _getOffsetForSelection(int index) {
    return (index - widget.visibilityRadius) * _itemHeight!;
  }

  int _findSelectedItem(double offset) {
    int indexOffset =
        (offset + widget.visibilityRadius * _itemHeight!) ~/ _itemHeight!;
    int borderMovement = (offset +
            widget.visibilityRadius * _itemHeight! -
            indexOffset * _itemHeight!) ~/
        (_itemHeight! / 2);
    indexOffset += borderMovement;
    return indexOffset;
  }
}

enum ScrollType { goesOnlyBottom, goesOnlyTop, bothDirections }
