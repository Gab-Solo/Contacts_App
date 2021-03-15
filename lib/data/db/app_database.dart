import 'dart:async';

import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';

class AppDatabase {
  // The only available instance of this AppDatabase class
  // is stored in this private field
  static final AppDatabase _singleton = AppDatabase._();

  // This instance get-only property is the only way for the other classes to access
  // the single AppDatabase object.
  static AppDatabase get instance => _singleton;

  // Completer is used for transforming synchronous code into asynchronus code.
  Completer<Database> _dbOpenCompleter;

  // A private constructor.
  // If a class specifies its own constructor, it immediately loses the default one.
  // This means that by providing a private constructor, we can create new instances
  // inly from within this AppDatabase class itself.
  AppDatabase._();

  Future<Database> get database async {
    // if completer is null, database is not yet opened.
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // Calling _openDatabase will also complete the completer with database instance
      _openDatabase();
    }
    // If the database is already opened, return immediately.
    // Otherwise, wait until complete() is called on the Completer in _openDatabase()
    return _dbOpenCompleter.future;
  }

  Future _openDatabase() async {
    // Get a platform-specific directory where persistent app data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();
    // Path with the form: /platorm-specific-directory/contacts.db
    final dbPath = join(appDocumentDir.path, 'contacts.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    _dbOpenCompleter.complete(database);
  }
}
