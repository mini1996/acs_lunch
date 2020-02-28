import 'dart:io';

import 'package:acs_lunch/utils/logger.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:swifttrackv2/app/data/data_access_objects/group_dao.dart';
// import 'package:swifttrackv2/app/data/data_access_objects/invitations_dao.dart';
// import 'package:swifttrackv2/app/data/data_access_objects/message_dao.dart';
// import 'package:swifttrackv2/app/data/data_access_objects/participants_dao.dart';
// import 'package:swifttrackv2/app/data/data_access_objects/periodicals_dao.dart';
// import 'package:swifttrackv2/app/data/data_access_objects/trust_group_dao.dart';
// import 'package:swifttrackv2/app/data/data_access_objects/trust_members_dao.dart';
// import 'package:swifttrackv2/app/data/data_access_objects/users_dao.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;
  final log = getLogger('Synchronisation helper');
  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> get deleteDb async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _onDeleteDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    Directory documentsDirectory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print(path);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onDeleteDatabase() async {
    Directory documentsDirectory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await deleteDatabase(path);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    // await db.execute(BookingsDao.createTable);
  }
}
