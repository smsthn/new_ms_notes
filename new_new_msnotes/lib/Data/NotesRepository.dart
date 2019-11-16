


import 'package:new_new_msnotes/Data/Entities/Note.dart';
import 'package:new_new_msnotes/Data/Entities/Tag.dart';
import 'package:new_new_msnotes/Data/NotesDb.dart';
import 'package:new_new_msnotes/Helpers/ImageHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class NotesRepository{
  NotesDb _notesDb;
  List<Function> refreshFunc = List();
  final List<Note> selectedNotes= List();

  static NotesRepository _noteRep;
  
  NotesRepository._intern(){
    _notesDb = NotesDb();
  }
  factory NotesRepository(){
    if(_noteRep == null)
      _noteRep = NotesRepository._intern();
    return _noteRep;
  }
  
  
  ///Note Stuff
  Future<Note> addNote(Note note)async{
    var db = await _notesDb.getDb();
    note.id = await db.insert("Note", note.toMap());
  /*  await db.execute("INSERT INTO Note (parent_id,name,type,color_index,creation_date,modification_date,content)VALUES(?,?,?,?,?,?,?);",[note.parentId,note.name??"",noteTypeToInt(note.type??0),note.colorIndex??0,note.creationDate.millisecondsSinceEpoch,note.modificationDate.millisecondsSinceEpoch,note.content??""]);
    var mp = await db.rawQuery('SELECT last_insert_rowid();');
    note.id = mp[0].values.first;*/
    if(refreshFunc.isNotEmpty)refreshFunc.last();
    return note;
  }
  Future removeNote(Note note)async{
    var db = await _notesDb.getDb();
    await db.delete("Note",where:"id = ?",whereArgs:[note.id]);
    var ids = await _getNoteIds(db);
    ImageHelper.deleteWhereNotIds(ids);
    if(refreshFunc.isNotEmpty)refreshFunc.last();
  }
  Future _getNoteIds(Database db)async{
    return await db.query("Note",columns: ["id"],);
  }
  Future changeParents(List<int> ids,int parentId) async{
    var db = await _notesDb.getDb();
    await db.update("Note",{"parent_id":parentId},where: "id IN(${ids.map((i)=>"?").toList().join(",")})",whereArgs: ids);

  }
  Future changeParentThenRemoveNotes(Note note)async{
    var db = await _notesDb.getDb();
    ImageHelper.deleteNotesImages(note);
    await db.transaction((t)async{
      await t.update("Note",{"parent_id":note.parentId},where: "parent_id = ?",whereArgs: [note.id]);
      await t.delete("Note",where:"id = ?",whereArgs:[note.id]);
    });
    if(refreshFunc.isNotEmpty)refreshFunc.last();
  }
  Future<Note> updateNote(Note note)async{
    if(note.id == 0)return null;
    var db = await _notesDb.getDb();
    await db.update("Note", note.toMap(update: true),where: "id = ?",whereArgs: [note.id]);
    if(refreshFunc.isNotEmpty)refreshFunc.last();
    return note;
  }

  Future<List<Note>> getNotesWhereParent(int parentId)async{
    var s = await SharedPreferences.getInstance();
    var orderInt = s.getInt('order');
    orderInt?? await getNotesWhereParentOrderDateDesc(parentId);
    switch (orderInt ??0){
      case 1:
        return await getNotesWhereParentOrderDateAsc(parentId);
      case 2:
        return await getNotesWhereParentOrderNameAsc(parentId);
      case 3:
        return await getNotesWhereParentOrderNameDesc(parentId);
      default:
        return await getNotesWhereParentOrderDateDesc(parentId);
    }
  }

  Future<List<Note>> getNotesWhereParentOrderDateDesc(int parentId)async{
    var db = await _notesDb.getDb();
    var maps =  await db.query("Note",where: "parent_id = ? AND parent_id != id",whereArgs: [parentId],orderBy: "type DESC,modification_date DESC");
    return maps.map((m)=>new Note.fromMap(m)).toList();
  }
  /*Future<List<Note>> getNotesWhereNoParent()async{
    var db = await _notesDb.getDb();
    var maps =  await db.query("Note",where: "parent_id = id",orderBy: "type DESC,modification_date DESC");
    return maps.map((m)=>new Note.fromMap(m)).toList();
  }*/
  Future<List<Note>> getNotesWhereParentOrderDateAsc(int parentId)async{
    var db = await _notesDb.getDb();
    var maps =  await db.query("Note",where: "parent_id = ? AND parent_id != id",whereArgs: [parentId],orderBy: "type DESC,modification_date");
    return maps.map((m)=>new Note.fromMap(m)).toList();
  }

  Future<List<Note>> getNotesWhereParentOrderNameAsc(int parentId)async{
    var db = await _notesDb.getDb();
    var maps =  await db.query("Note",where: "parent_id = ? AND parent_id != id",whereArgs: [parentId],orderBy: "type DESC,name");
    return maps.map((m)=>new Note.fromMap(m)).toList();
  }

  Future<List<Note>> getNotesWhereParentOrderNameDesc(int parentId)async{
    var db = await _notesDb.getDb();
    var maps =  await db.query("Note",where: "parent_id = ? AND parent_id != id",whereArgs: [parentId],orderBy: "type DESC,name DESC");
    return maps.map((m)=>new Note.fromMap(m)).toList();
  }


  Future<List<Note>> getNotesWhere(List<String> columns,List<dynamic> whereArgs)async{
    if(columns == null ||columns.isEmpty||whereArgs == null ||whereArgs.isEmpty || columns.length != whereArgs.length){
      return null;
    }
    var db = await _notesDb.getDb();
    var wheres = StringBuffer('');
    for(int i = 0; i < columns.length;i++){
      wheres.write(i==0?' ':' And ');
      wheres.write(columns[i]);
      wheres.write(' ');
      wheres.write((whereArgs[i] is String)?' Like ? ':' = ? ');
      if(whereArgs[i] is String)whereArgs[i]='%'+whereArgs[i]+'%';
    }

    var maps =  await db.query("Note",where: wheres.toString(),whereArgs: whereArgs);
    return maps.map((m)=>new Note.fromMap(m)).toList();
  }


  ///Tags Stuff
  
  Future<Tag> addTag(Tag tag)async{
    var db = await _notesDb.getDb();
    tag.id = await db.insert("Tag", tag.toMap());
    return tag;
  }
  Future removeTag(Tag tag)async{
    var db = await _notesDb.getDb();
    await db.delete("Tag",where:"id = ?",whereArgs:[tag.id]);
  }
  Future<Tag> updateTag(Tag tag)async{
    var db = await _notesDb.getDb();
    await db.update("Tag", tag.toMap());
    return tag;
  }
  Future<List<Tag>> getAllTags()async{
    var db = await _notesDb.getDb();
    var maps =  await db.query("Tag");
    return maps.map((m)=>new Tag.fromMap(m)).toList();
  }

  ///Tag_Note_Rel Stuff
  Future addTagNoteRel(int tagId,int noteId)async{
    var db = await _notesDb.getDb();
    await db.insert("Tag_Note_Rel", {"tag_id":tagId,"note_id":noteId});
  }
  Future removeTagNoteRelWhereTagid(int tagId)async{
    var db = await _notesDb.getDb();
    await db.delete("Tag_Note_Rel",where:"tag_id = ?",whereArgs:[tagId]);
  }
  Future removeTagNoteRelWhereNoteid(int noteId)async{
    var db = await _notesDb.getDb();
    await db.delete("Tag_Note_Rel",where:"note_id = ?",whereArgs:[noteId]);
  }
  Future<List<Tag>> getTagsWhereNote(int noteId)async{
    var db = await _notesDb.getDb();
    var ids = await db.query("Tag_Note_Rel",where: "note_id",whereArgs: [noteId]);
    var maps =  await db.query("Tag",where:"id IN (${ids.map((s)=>s["tag_id"]).join(",")})");
    return maps.map((m)=>new Tag.fromMap(m)).toList();
  }
  Future<List<Note>> getNotesWhereTag(int tagId)async{
    var db = await _notesDb.getDb();
    var ids = await db.query("Tag_Note_Rel",where: "tag_id",whereArgs: [tagId]);
    var maps =  await db.query("Tag",where:"id IN (${ids.map((s)=>s["note_id"]).join(",")})");
    return maps.map((m)=>new Note.fromMap(m)).toList();
  }
}