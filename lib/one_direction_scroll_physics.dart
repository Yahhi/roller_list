import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OneDirectionScrollPhysics extends ScrollPhysics {
  OneDirectionScrollPhysics({ScrollPhysics? parent, this.goesOnlyBottom = true})
      : super(parent: parent);

  final bool goesOnlyBottom;
  bool goesBottom = false;
  bool goesTop = false;

  @override
  OneDirectionScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return OneDirectionScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    goesBottom = offset.sign > 0;
    goesTop = offset.sign < 0;
    return offset;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    // overscroll
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      return value - position.pixels;
    }

    // hit top edge
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      return value - position.minScrollExtent;
    }

    // hit bottom edge
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      return value - position.maxScrollExtent;
    }

    if (goesBottom && goesOnlyBottom) {
      return value - position.pixels;
    }
    if (goesTop && !goesOnlyBottom) {
      return value - position.pixels;
    }
    return 0.0;
  }
}
