import 'package:flutter/material.dart';
import 'package:roller_list/roller_list.dart';

class TimeSelector extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimeSelectorState();
  }
}

class _TimeSelectorState extends State<TimeSelector> {
  static const TIME_ITEM_WIDTH = 80.0;
  late TimeOfDay time;

  @override
  void initState() {
    DateTime now = DateTime.now();
    time = new TimeOfDay(hour: now.hour, minute: now.minute);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            'Clock inspiration',
            textScaler: TextScaler.linear(1.5),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            RollerList(
              length: 24,
              builder: (BuildContext context, int index) {
                int hour = index % 24;
                return Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    hour.toString().padLeft(2, '0'),
                    textScaler: TextScaler.linear(1.3),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: hour == time.hour
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                );
              },
              width: TIME_ITEM_WIDTH,
              onSelectedIndexChanged: _changeHours,
              initialIndex: time.hour,
            ),
            SizedBox(
              width: 4.0,
            ),
            RollerList(
              length: 60,
              builder: (BuildContext context, int index) {
                int minute = index % 60;
                return Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    minute.toString().padLeft(2, '0'),
                    textScaler: TextScaler.linear(1.3),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: minute == time.minute
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                );
              },
              width: TIME_ITEM_WIDTH,
              onSelectedIndexChanged: _changeMinutes,
              initialIndex: time.minute,
            )
          ]),
          Text("Selected time is ${time.format(context)}"),
        ],
      ),
    );
  }

  void _changeHours(int value) {
    setState(() {
      time = new TimeOfDay(hour: value, minute: time.minute);
    });
  }

  void _changeMinutes(int value) {
    setState(() {
      time = new TimeOfDay(hour: time.hour, minute: value);
    });
  }
}
