import 'dart:math';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDb {
  Database db;
  var _dbName = "notes.db";

  NotesDb(){
    getDb();
  }

  Future<Database> getDb() async {
    if (db != null) if (db.isOpen) return db;
    var path = await getDatabasesPath();
    var dbpath = join(path, _dbName);
    db = await openDatabase(dbpath, version: 1, onCreate: (db, i) async {
      await db.execute("CREATE TABLE Note("
          "id INTEGER PRIMARY KEY,"
          "name VARCHAR,"
          "parent_id INTEGER,"
          "type INTEGER,"
          "color_index INTEGER,"
          "creation_date INTEGER,"
          "modification_date INTEGER,"
          "content VARCHAR"
          ",FOREIGN KEY(parent_id) REFERENCES Note(id) ON DELETE CASCADE"
          ")");
      await db.execute("CREATE TABLE Tag("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name VARCHAR"
          ")");
      await db.execute("CREATE TABLE Tag_Note_Rel("
          "tag_id INTEGER,"
          "note_id INTEGER,"
          "FOREIGN KEY (tag_id) REFERENCES Tag(id),"
          "FOREIGN KEY (note_id) REFERENCES Note(id),"
          "UNIQUE(tag_id,note_id)"
          ")");
      await db.execute("INSERT INTO Note(id,parent_id,name,content,creation_date,modification_date,color_index,type)"
          " VALUES(0,NULL,'Root',"
          "'root',${DateTime.now().millisecondsSinceEpoch},"
          "${DateTime.now().millisecondsSinceEpoch},0,0)");
      /*await db.execute("CREATE TRIGGER IF NOT EXISTS rec_del AFTER DELETE ON Note "
          "BEGIN "
          "DELETE FROM Note WHERE parent_id != NULL AND parent_id == old.id; "
          "END;");*/
      await db.execute("INSERT INTO Note(parent_id,name,content,creation_date,modification_date,color_index,type)"
          " VALUES(0,'name2',"
          "'content',${DateTime.now().millisecondsSinceEpoch},"
          "${DateTime.now().millisecondsSinceEpoch},${Random().nextInt(15)},${Random().nextInt(1)})");
      await db.execute("INSERT INTO Note(parent_id,name,content,creation_date,modification_date,color_index,type)"
          " VALUES(0,'name3',"
          "'content',${DateTime.now().millisecondsSinceEpoch},"
          "${DateTime.now().millisecondsSinceEpoch},${Random().nextInt(15)},${Random().nextInt(1)})");
      await db.execute("INSERT INTO Note(parent_id,name,content,creation_date,modification_date,color_index,type)"
          " VALUES(0,'name4',"
          "'$longText$longText$longText$longText$longText$longText$longText$longText',${DateTime.now().millisecondsSinceEpoch},"
          "${DateTime.now().millisecondsSinceEpoch},${Random().nextInt(15)},${Random().nextInt(1)})");
    }
    /*,onOpen:(db) async {
      for(int i = 0;i < 5; i ++){
        var nt = Random().nextInt(100);
        await db.execute("INSERT INTO Note(id,parent_id,name,content,creation_date,modification_date,color_index,type)"
            " VALUES($nt,$nt,'name4',"
            "'content',${DateTime.now().millisecondsSinceEpoch},"
            "${DateTime.now().millisecondsSinceEpoch},${Random().nextInt(15)},${Random().nextInt(2)})");
      }
        }*/
    );

    return db;
  }
  Future closeDb()=> db.close();

  
}



String longText = "KSDJADkj DJSJK DJsjKDJ KJ :ASKJDL AKDJKLJDKSKDL:DKJSAD KJAD JDJSAIJ IADSD:S :AD ASDNMDK A:SDKJ "
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was"
    "\n dasasadasdasdasdasdsadasdasdasdasdasf af af dsfwa fwe fawe fa fe was";


