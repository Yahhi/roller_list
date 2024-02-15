import 'package:flutter/material.dart';
import 'package:roller_list/roller_list.dart';

class DateSelector extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DateSelectorState();
  }
}

class _DateSelectorState extends State<DateSelector> {
  String selectedMonth = "February";
  int selectedDay = 10;
  final GlobalKey<RollerListState> numberKey = new GlobalKey();
  static const MONTHS = {
    "January": 31,
    "February": 29,
    "March": 31,
    "April": 30,
    "May": 31,
    "June": 30,
    "July": 31,
    "August": 31,
    "September": 30,
    "October": 31,
    "November": 30,
    "December": 31
  };

  final List<Widget> months = MONTHS.keys
      .map((month) => Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              month,
              textScaler: TextScaler.linear(1.3),
              textAlign: TextAlign.center,
            ),
          ))
      .toList();

  int interval = 1;
  late String intervalType;
  static const TEXT_STYLE = TextStyle(fontSize: 24, color: Colors.black);
  static const TEXT_STYLE_UNSELECTED =
      TextStyle(fontSize: 24, color: Colors.grey);
  static const _INTERVAL_OPTIONS = ["Month", "Day", "Week"];

  @override
  void initState() {
    interval = 1;
    intervalType = _INTERVAL_OPTIONS[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            RollerList(
              items: months,
              onSelectedIndexChanged: _changeMonths,
              dividerColor: Colors.red,
              dividerThickness: 2.0,
              initialIndex: 1,
            ),
            SizedBox(
              width: 4.0,
            ),
            RollerList(
              items: _getDaysForMonth(selectedMonth),
              width: 80.0,
              onSelectedIndexChanged: _changeDays,
              dividerColor: Colors.green,
              dividerThickness: 2.0,
              initialIndex: selectedDay,
            )
          ]),
          Text("Selected date is $selectedMonth, $selectedDay"),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Every",
                style: TEXT_STYLE,
              ),
              SizedBox(),
              RollerList(
                height: 60.0,
                width: 60.0,
                key: numberKey,
                builder: intervalType == "Day"
                    ? (context, index) {
                        return Center(
                          child: Text(
                            (index % 99 + 1).toString(),
                            style: interval == (index % 99 + 1)
                                ? TEXT_STYLE
                                : TEXT_STYLE_UNSELECTED,
                          ),
                        );
                      }
                    : (context, index) {
                        return Center(
                          child: Text(
                            (index % 12 + 1).toString(),
                            style: interval == (index % 12 + 1)
                                ? TEXT_STYLE
                                : TEXT_STYLE_UNSELECTED,
                          ),
                        );
                      },
                length: intervalType == "Day" ? 99 : 12,
                enabled: true,
                onSelectedIndexChanged: _setInterval,
                initialIndex: interval - 1,
              ),
              SizedBox(
                width: 8.0,
              ),
              RollerList(
                height: 60.0,
                width: 120.0,
                builder: (context, index) {
                  int actualIndex = index % _INTERVAL_OPTIONS.length;
                  return Center(
                    child: Text(
                      _INTERVAL_OPTIONS[actualIndex],
                      style: intervalType == _INTERVAL_OPTIONS[actualIndex]
                          ? TEXT_STYLE
                          : TEXT_STYLE_UNSELECTED,
                    ),
                  );
                },
                initialIndex: _INTERVAL_OPTIONS.indexOf(intervalType),
                length: _INTERVAL_OPTIONS.length,
                enabled: true,
                onSelectedIndexChanged: _setIntervalType,
              ),
            ],
          ),
          Text("Selected: Every $interval $intervalType")
        ],
      ),
    );
  }

  List<Widget> _getDaysForMonth(String selectedMonth) {
    List<Widget> result = [];
    for (int i = 1; i <= MONTHS[selectedMonth]!; i++) {
      result.add(Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          "$i",
          textScaler: TextScaler.linear(1.3),
          textAlign: TextAlign.center,
        ),
      ));
    }
    return result;
  }

  void _changeMonths(int value) {
    setState(() {
      selectedMonth = MONTHS.keys.toList()[value];
    });
  }

  void _changeDays(int value) {
    setState(() {
      selectedDay = value + 1;
    });
  }

  void _setInterval(int value) {
    setState(() {
      interval = value + 1;
    });
  }

  void _setIntervalType(int value) {
    if (_INTERVAL_OPTIONS[value] == "Day") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        numberKey.currentState!.smoothScrollToIndex(interval - 1);
      });
    } else {
      if (interval > 12) {
        setState(() {
          interval = 12;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          numberKey.currentState!.smoothScrollToIndex(interval - 1);
        });
      }
    }
    setState(() {
      intervalType = _INTERVAL_OPTIONS[value];
    });
  }
}
