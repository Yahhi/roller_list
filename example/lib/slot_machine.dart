import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:roller_list/roller_list.dart';

class SlotMachine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SlotMachineState();
  }
}

class _SlotMachineState extends State<SlotMachine> {
  static const _ROTATION_TIME_STEP = Duration(milliseconds: 300);
  final List<Widget> slots = _getSlots();
  final List<String> slotNames = [
    "grape",
    "apple",
    "banana",
    "tree",
    "carrot",
    "lemon",
    "pineapple",
    "seven",
    "orange",
    "watermelon",
  ];
  int? first, second, third, fourth;
  final leftRoller = new GlobalKey<RollerListState>();
  final leftCenterRoller = new GlobalKey<RollerListState>();
  final rightCenterRoller = new GlobalKey<RollerListState>();
  final rightRoller = new GlobalKey<RollerListState>();
  Timer? rotator;
  Random _random = new Random();
  int? randomRotationTimeInSeconds;
  DateTime? startRotation;

  @override
  void initState() {
    first = 0;
    second = 0;
    third = 0;
    fourth = 0;
    super.initState();
  }

  @override
  void dispose() {
    rotator?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Slot Machine',
          textScaler: TextScaler.linear(1.5),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 16.0,
        ),
        Container(
          width: 300,
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: _startRotating,
                child: Image.asset('assets/images/slot-machine.jpg'),
              ),
              Positioned(
                left: 94,
                right: 94,
                bottom: 90,
                child: Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: RollerList(
                          items: slots,
                          enabled: false,
                          key: leftRoller,
                          onSelectedIndexChanged: (value) {
                            setState(() {
                              first = value - 1;
                            });
                          },
                        ),
                      ),
                      VerticalDivider(
                        width: 2,
                        color: Colors.black,
                      ),
                      Expanded(
                        flex: 1,
                        child: RollerList(
                          items: slots,
                          key: leftCenterRoller,
                          onSelectedIndexChanged: (value) {
                            setState(() {
                              second = value - 1;
                            });
                          },
                          onScrollStarted: _startRotating,
                        ),
                      ),
                      VerticalDivider(
                        width: 2,
                        color: Colors.black,
                      ),
                      Expanded(
                        flex: 1,
                        child: RollerList(
                          enabled: false,
                          items: slots,
                          key: rightCenterRoller,
                          onSelectedIndexChanged: (value) {
                            setState(() {
                              third = value - 1;
                            });
                          },
                        ),
                      ),
                      VerticalDivider(
                        width: 2,
                        color: Colors.black,
                      ),
                      Expanded(
                        flex: 1,
                        child: RollerList(
                          enabled: false,
                          items: slots,
                          key: rightRoller,
                          onSelectedIndexChanged: (value) {
                            setState(() {
                              fourth = value - 1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        if (slotNames.length < third!)
          Text(
              "Result: ${slotNames[first!]}-${slotNames[second!]}-${slotNames[third!]}"),
        if (slotNames.length < third!)
          (first == second && first == third) ? Text("WIN!!!") : Container(),
      ],
    );
  }

  void _startRotating() {
    randomRotationTimeInSeconds = _random.nextInt(7);
    startRotation = DateTime.now();
    rotator = Timer.periodic(_ROTATION_TIME_STEP, _rotateRoller);
  }

  void _rotateRoller(_) {
    if (DateTime.now().difference(startRotation!).inSeconds >
        randomRotationTimeInSeconds!) {
      _finishRotating();
    } else if (DateTime.now().difference(startRotation!).inSeconds >
        randomRotationTimeInSeconds! - 3) {
      final leftRotationTarget = _random.nextInt(3 * slots.length);
      final rightRotationTarget = _random.nextInt(3 * slots.length);
      final centerLeftRotationTarget = _random.nextInt(3 * slots.length);
      final centerRightRotationTarget = _random.nextInt(3 * slots.length);
      leftRoller.currentState?.smoothScrollToIndex(leftRotationTarget,
          duration: _ROTATION_TIME_STEP, curve: Curves.decelerate);
      rightRoller.currentState?.smoothScrollToIndex(rightRotationTarget,
          duration: _ROTATION_TIME_STEP, curve: Curves.decelerate);
      leftCenterRoller.currentState?.smoothScrollToIndex(
          centerLeftRotationTarget,
          duration: _ROTATION_TIME_STEP,
          curve: Curves.decelerate);
      rightCenterRoller.currentState?.smoothScrollToIndex(
          centerRightRotationTarget,
          duration: _ROTATION_TIME_STEP,
          curve: Curves.decelerate);
    } else {
      final leftRotationTarget = _random.nextInt(3 * slots.length);
      final rightRotationTarget = _random.nextInt(3 * slots.length);
      final centerLeftRotationTarget = _random.nextInt(3 * slots.length);
      final centerRightRotationTarget = _random.nextInt(3 * slots.length);
      leftRoller.currentState?.smoothScrollToIndex(leftRotationTarget,
          duration: _ROTATION_TIME_STEP, curve: Curves.linear);
      rightRoller.currentState?.smoothScrollToIndex(rightRotationTarget,
          duration: _ROTATION_TIME_STEP, curve: Curves.linear);
      leftCenterRoller.currentState?.smoothScrollToIndex(
          centerLeftRotationTarget,
          duration: _ROTATION_TIME_STEP,
          curve: Curves.linear);
      rightCenterRoller.currentState?.smoothScrollToIndex(
          centerRightRotationTarget,
          duration: _ROTATION_TIME_STEP,
          curve: Curves.linear);
    }
  }

  void _finishRotating() {
    rotator?.cancel();
    rotator = null;
  }

  static List<Widget> _getSlots() {
    List<Widget> result = [];
    for (int i = 0; i <= 9; i++) {
      result.add(Container(
        padding: EdgeInsets.all(4.0),
        color: Colors.white,
        child: Image.asset(
          "assets/images/$i.png",
          width: double.infinity,
          height: double.infinity,
        ),
      ));
    }
    return result;
  }
}
