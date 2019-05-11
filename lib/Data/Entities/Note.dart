import 'dart:math';

class Note {
  int id;
  int parentId;
  String name;
  NoteType type;
  int colorIndex;
  DateTime creationDate;
  DateTime modificationDate;
  String content;
  
  
  Note({this.id = 0,this.parentId = 0,this.name = "",this.type = NoteType.Note,this.colorIndex = 0,this.creationDate,this.modificationDate,this.content = ""}){
    if(creationDate == null){
      creationDate = DateTime.now();
    }
    if(modificationDate == null){
      modificationDate = DateTime.now();
    }
  }

  Map<String,dynamic> toMap({bool update = false}){
    var res = {

      "name":name,
      "type":noteTypeToInt(type??0),
      "color_index":colorIndex??0,
      "creation_date":creationDate.millisecondsSinceEpoch,
      "modification_date":modificationDate.millisecondsSinceEpoch,
      "content":content,
      "parent_id":parentId??0
    };
    if(update){
      res.addAll({"id":id});
    }
    return res;
  }
  Note.fromMap(Map<String,dynamic> json):this(
    id:json["id"],
    parentId:json["parent_id"],
    name:json["name"],
    type:intToNoteType(json["type"]),
    colorIndex:json["color_index"],
    creationDate:DateTime.fromMillisecondsSinceEpoch(json["creation_date"]),
    modificationDate:DateTime.fromMillisecondsSinceEpoch(json["modification_date"]),
    content:json["content"],
  );
  clone()=>new Note(id: id,colorIndex: colorIndex,content: content,creationDate: creationDate,modificationDate: modificationDate,name: name,parentId: parentId,type: type);

}

enum NoteType { Note, CheckList,Folder }

NoteType intToNoteType(int type) {
  switch (type) {
    /*case 1:
      return NoteType.Category;*/
    case 1:
      return NoteType.CheckList;
    case 2:
      return NoteType.Folder;
    default:
      return NoteType.Note;
  }
}

int noteTypeToInt(NoteType type) {
  switch (type) {
    /*case NoteType.Category:
      return 1;*/
    case NoteType.CheckList:
      return 1;
    case NoteType.Folder:
      return 2;
    default:
      return 0;
  }
}



enum NoteColor {
  White,
}

NoteColor intToNoteColor(int color) {
  switch (color) {
    default:
      return NoteColor.White;
  }
}

int noteColorToInt(NoteColor color) {
  switch (color) {
    default:
      return 0;
  }
}
