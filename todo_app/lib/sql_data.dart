import 'package:sqflite/sqflite.dart' as sql;

class sql_data {
  static Future<void> createTables(sql.Database database)async {
    await database.execute("""Create TABLE data(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
    title TEXT,
    descp TEXT,
    createAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""" );
  }
  static Future<sql.Database> db() async{
    return sql.openDatabase("database_name.db",version: 1,
    onCreate: (sql.Database database, int version) async {
      await createTables(database);
    }
    );

  }
  static Future<int> createData(String title, String? descp) async {
    final db = await sql_data.db();

    final data = {'title': title, 'descp': descp};
    final id = await db.insert('data', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

static Future<List<Map<String,dynamic>>> getAllData() async {
    final db = await sql_data.db();
    return db.query('data',orderBy: 'id');
}
static Future<List<Map<String,dynamic>>> getSingleData(int id) async {
final db = await sql_data.db();
 return db.query('data', where: "id = ?", whereArgs: [id],limit: 1);
}
static Future<int> updateData(int id , String title, String? descp) async {
    final db = await sql_data.db();
    final data = {
      'title' : title,
      'descp' : descp,
      // 'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('data', data, where : "id = ?", whereArgs:[id]);
    return result;
}
static Future<void> deleteData(int id) async{
    final db=await sql_data.db();
    try{
      await db.delete('data', where: "id =?", whereArgs: [id]);
    } catch (e) {}
}
}
