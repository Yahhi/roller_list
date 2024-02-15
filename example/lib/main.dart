import 'package:example_roller_list/slot_machine.dart';
import 'package:example_roller_list/time_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'date_selector.dart';

void main() {
  if (kIsWeb) {
    runApp(new MyApp());
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) async {
      runApp(new MyApp());
    });
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RollerList Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedItem = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RollerList"),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            decoration: BoxDecoration(
              color: Colors.white10,
              border: Border.all(
                  width: 1.0,
                  style: BorderStyle.solid,
                  color: Colors.redAccent),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedItem,
                items: <DropdownMenuItem<int>>[
                  new DropdownMenuItem(
                    child: new Text(
                      'CLOCK',
                      textAlign: TextAlign.right,
                    ),
                    value: 0,
                  ),
                  new DropdownMenuItem(
                    child: new Text(
                      'DATES',
                      textAlign: TextAlign.right,
                    ),
                    value: 1,
                  ),
                  new DropdownMenuItem(
                    child: new Text(
                      'SLOT MACHINE',
                    ),
                    value: 2,
                  ),
                ],
                onChanged: (int? value) {
                  if (value != null) {
                    setState(() => selectedItem = value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
            child: selectedItem == 0
                ? TimeSelector()
                : selectedItem == 1
                    ? DateSelector()
                    : SlotMachine()),
      ),
    );
  }
}
