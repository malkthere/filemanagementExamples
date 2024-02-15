// يجب حفظ هذا الملف لإنشاء اي قاعدة بيانات

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class SqlDb {
  // this is made to not make init again and again
  static Database? _db;
  Future<Database?> get db async{
    if (_db ==null){
      _db = await initalDb();
      return _db;
    }else{
      return _db;
    }
  }
  // here we init the database and creat the tables
  initalDb() async{
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'mazdb.db');
    Database mydb = await openDatabase(path, onCreate: _onCreate, version:6, onUpgrade:_onUpgrade);
    return mydb;

  }
  _onUpgrade(Database db, int oldversion, int newversion)async{

    List<Map<String, dynamic>> department2 = [
      {
        'DeptID': '1',
        'DeptName': 'تقنية المعلومات'
      },
      {
        'DeptID': '2',
        'DeptName': 'أمن المعلومات'
      },
      {
        'DeptID': '3',
        'DeptName': 'علوم الحاسوب'
      },
    ];
    for (var dept in department2) {
      await db.insert('department2', dept);
    }
    await db.query('department2');
    print("onUpgrae =========================");
  }
  _onCreate(Database db, int version) async{
    await db.execute('''
        CREATE TABLE "std_info" (
	        "StdID"	INTEGER,
	        "StdName"	TEXT,
        	"DeptID"	INTEGER,
        	"level"	INTEGER
           )
        ''');
    await db.execute('''
        CREATE TABLE "department" (
	        "DeptID"	INTEGER,
	        "DeptName"	TEXT
           )
        ''');
    List<Map<String, dynamic>> departments = [
      {
        'DeptID': '1',
        'DeptName': 'تقنية المعلومات'
      },
      {
        'DeptID': '2',
        'DeptName': 'أمن المعلومات'
      },
      {
        'DeptID': '1',
        'DeptName': 'علوم الحاسوب'
      },
    ];
    for (var dept in departments) {
      await db.insert('department', dept);
    }
    await db.query('department');
    print("======onCreat database and tables ================");
  }


// SELECT
  readData(String sql) async{
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;

  }
// INSERT
  insertData(String sql) async{
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }
// UPDATE
  updateData(String sql) async{
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }
// DELETE
  deleteData(String sql) async{
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }
 /* importstdlist(List<String> s2) async{
    Database? mydb = await db;
    List<Map<String, dynamic>>  insertion= [
      {
        'StdID': s2[2].toString(),
        'DeptID': '1',
        'DeptName': s2[1].toString()
      },
    ];
    for (var dept in insertion) {
      int response=await db.insert('std_info', dept);
      return response;
    }
   // await db.query('std_info');

  }*/
}