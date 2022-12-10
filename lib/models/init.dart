import 'package:flutter_application_1/repositories/habit_state_repository.dart';
import 'package:flutter_application_1/repositories/sembast_habit_sate_repository.dart';
import 'package:flutter_application_1/services/habit_state_service.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class Init {
  static Future<bool> initialize() async {
    await _initSembast();
    _registerRepositories();
    _registerServices();
    print("Initializing Repository Done!!");
    return true;
  }

  static _registerRepositories() {
    print("registering!!");
    GetIt.I.registerLazySingleton<HabitStateRepository>(
        () => SembastHabitStateRepository());
  }

  static _registerServices() {
    GetIt.I.registerLazySingleton<HabitStateService>(() => HabitStateService());
  }

  static Future _initSembast() async {
    print("Came here!!");
    final appDir = await getApplicationDocumentsDirectory();
    print("yo yo");
    await appDir.create(recursive: true);
    final databasePath = join(appDir.path, "sembast.db");
    print("database path" + databasePath);
    final database = await databaseFactoryIo.openDatabase(databasePath);
    GetIt.I.registerSingleton<Database>(database);
  }
}
