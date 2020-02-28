// import 'package:swifttrackv2/app/utils/db_helper.dart';
// import 'package:sqflite/sqflite.dart';

// class TemplateDao {
//   static final table = 'template';
//   static final columnId = '_id';
//   static final columnName = 'name';
//   static final columnStatus = 'status';
//   static final createTable = '''
//           CREATE TABLE $table (
//             $columnId INTEGER PRIMARY KEY,
//             $columnName TEXT NOT NULL,
//             $columnStatus INTEGER NULL
//           )
//           ''';
//   Future<Database> get _db async => await DatabaseHelper.instance.database;

//   Future<int> insert(Map<String, dynamic> row) async {
//     Database db = await _db;
//     return await db.insert(table, row);
//   }

//   Future<List> queryAllRows() async {
//     Database db = await _db;
//     final recordSnapshots = await db.rawQuery('SELECT * FROM $table ');
//     return recordSnapshots.map((snapshot) {
//       // final message = Message.fromMap(snapshot);
//       // return message;
//     }).toList();
//   }

//   Future<int> queryRowCount() async {
//     Database db = await _db;
//     return Sqflite.firstIntValue(
//         await db.rawQuery('SELECT COUNT(*) FROM $table'));
//   }

//   Future<int> update(Map<String, dynamic> row) async {
//     Database db = await _db;
//     int id = row[columnId];
//     return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
//   }

//   Future<int> delete(int id) async {
//     Database db = await _db;
//     return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
//   }
// }
