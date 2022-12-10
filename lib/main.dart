import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/providers/date_provider.dart';
import 'package:flutter_application_1/models/providers/habit_state.dart';
import 'package:flutter_application_1/models/habit_state_dao.dart';
import 'package:flutter_application_1/screens/history_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'screens/tracker_screen.dart';
import 'package:provider/provider.dart';
import 'models/init.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'dart:collection';
import 'util/date_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await checkDb();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitState(DateTime.now())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Future<bool> _init = Init.initialize();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DailyTracker',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/history': (context) => HistoryScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: FutureBuilder(
        future: _init,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TrackerScreen();
          } else {
            return Material(
              child: Center(
                child: LinearProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

Future<void> checkDb() async {
  try {
    print("came here!");
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final databasePath = join(appDir.path, "sembast.db");
    final db = await databaseFactoryIo.openDatabase(databasePath);
    var store = StoreRef.main();

    final StoreRef _habitStateStore =
        stringMapStoreFactory.store("habit_state_store");
    Map<String, int> testMap = HashMap();
    testMap['cig'] = 2;
    testMap['weed'] = 3;

    HabitStateDao habitStateDao = HabitStateDao("yo", testMap);
    var lol = await _habitStateStore
        .record(habitStateDao.date)
        .put(db, habitStateDao.habitCountMap);
    final snapshots = await _habitStateStore.find(db);
    var result = await _habitStateStore.record("lolll").get(db) as Map;
    print(result);
  } catch (err) {
    print('Caught Error $err');
  }
}
