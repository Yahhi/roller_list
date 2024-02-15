[![Codemagic build status](https://api.codemagic.io/apps/5e2a1ba1cc644b00105fe31d/5e2a1ba1cc644b00105fe31c/status_badge.svg)](https://codemagic.io/apps/5e2a1ba1cc644b00105fe31d/5e2a1ba1cc644b00105fe31c/latest_build)

# roller_list package
This widget is a list of values distributed in a circle. The main rules of the list are: a user could scroll it in one direction endlessly, list values are limited and repeated in the same order over and over again.
Possible usage scheme:
-time selection
-piano notes selection
-choice of any limited number of items, where it is not important what should go first and what should go last.

## Example
You can check Flutter for web build [here](https://opensource.0x.team/roller-list/demo/index.html#/)
Or see how it looks like on iphone:
![](iphone_screen.gif)

## How to use
In the dependencies: section of your pubspec.yaml, add the following line:
```dart
roller_list: <latest version>
```

Then import this class:
```dart
import 'package:roller_list/roller_list.dart';
```

And add your list like this (with only programmatical scroll):
```dart
RollerList(
 items: slots,
 enabled: false,
 key: leftRoller,
)
```

Or like this (with enabled scroll):
```dart
RollerList(
  items: months,
  onSelectedIndexChanged: _changeMonths,
  initialIndex: 1,
)
```
where months is a list of widgets:
```dart
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
          textScaleFactor: 1.3,
          textAlign: TextAlign.center,
        ),
      ))
  .toList();
```
and _changeMonths will show the selection result somewhere in the widget tree:
```dart
void _changeMonths(int value) {
    setState(() {
      selectedMonth = MONTHS.keys.toList()[value];
    });
}
```