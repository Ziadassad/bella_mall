import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';




class DBHelper{

  DBHelper._privateConstructor();
  static final DBHelper dbInstance = DBHelper._privateConstructor();

  static Database database;

  Future<Database> get db async{
    if (null != database) {
      return database;
    }
    database = await initDb();
    return database;
  }

  initDb() async {
    io.Directory document = await getApplicationDocumentsDirectory();
    String path = join(document.path , "Tourism.db");
    var db  = await openDatabase(path , version: 1 , onCreate: OnCreate);
    return db;
  }

  OnCreate(Database db , int version) async {

    String sqlMember = "CREATE TABLE Member (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT , email TEXT , password TEXT)";

    String sqlHotel = "CREATE TABLE Hotel (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT , address TEXT , image TEXT )";

    await db.execute(sqlHotel);
    await db.execute(sqlMember);
  }

//  Future<DBTourism> insertHotel(DBTourism dbTourism) async{
//    var dbClient = await db;
//    dbTourism.id = await dbClient.insert("Hotel", dbTourism.toMap());
//    return dbTourism;
//  }
//  Future<DBTourism> insertResturant(DBTourism dbTourism) async{
//    var dbClient = await db;
//    dbTourism.id = await dbClient.insert("Restuarant", dbTourism.toMap());
//    return dbTourism;
//  }
//  Future<DBTourism> insertTourism(DBTourism dbTourism) async{
//    var dbClient = await db;
//    dbTourism.id = await dbClient.insert("Tourism", dbTourism.toMap());
//    return dbTourism;
//  }
//  Future<DBTourism> insertShop(DBTourism dbTourism) async{
//    var dbClient = await db;
//    dbTourism.id = await dbClient.insert("Shop", dbTourism.toMap());
//    return dbTourism;
//  }
//
//  Future<Member> insertMember(Member member) async{
//    var dbClient = await db;
//    member.id = await dbClient.insert("Member", member.toMap());
//    return member;
//  }
//
//  Future<List<Member>> getMember() async{
//    var dbClient = await db;
//    List<Map> maps = await dbClient.query("Member" , columns: ["id", "name" , "email", "password"]);
//    List<Member> member = [];
//
//    if(maps.length > 0){
//      for(int i= 0 ;i < maps.length ; i++){
//        member.add(Member.fromMap(maps[i]));
//      }
//    }
//    return member;
//  }
//
//  Future<List<DBTourism>> getData(String table) async {
//    var dbClient = await db;
//    List<Map> maps = await dbClient.query(table, columns: ["id", "name" , "address" , "image" , "late" , "lang"]);
//    List<DBTourism> dbTourism = [];
//    if (maps.length > 0) {
//      for (int i = 0; i < maps.length; i++) {
//        dbTourism.add(DBTourism.fromMap(maps[i]));
//      }
//    }
//    return dbTourism;
//  }

  Future<int> update(Map<String, dynamic> row , String table) async {
    Database db = await dbInstance.db;
    int id = row["id"];
    print(id);
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id , String table) async{
    Database db = await dbInstance.db;
    return await db.delete(table , where: 'id = ?' , whereArgs: [id]);
  }

  Future<bool> deleteDb() async {
    bool databaseDeleted = false;

    try {
      io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "Tourism.db");
      await deleteDatabase(path).whenComplete(() {
        databaseDeleted = true;
      }).catchError((onError) {
        databaseDeleted = false;
      });
    } on DatabaseException catch (error) {
      print(error);
    } catch (error) {
      print(error);
    }

    return databaseDeleted;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}






