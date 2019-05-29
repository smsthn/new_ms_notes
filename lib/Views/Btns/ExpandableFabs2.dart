import 'dart:math';

import 'package:flutter/material.dart';
import 'package:new_ms_notes/Data/Entities/Note.dart';
import 'package:new_ms_notes/Data/NotesDb.dart';
import 'package:new_ms_notes/Data/NotesRepository.dart';
import 'package:new_ms_notes/Helpers/ColorHelper.dart';
import 'package:new_ms_notes/Views/SearchNotesView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpandableFab2 extends StatefulWidget {

  final Note note;
  final Function(Note note) refreshPage;
  final Function(Note note) openNoteFunction;
  ExpandableFab2({this.note,this.refreshPage,this.openNoteFunction});
  @override
  State<StatefulWidget> createState() => ExpandableFab2State(note??Note(id: 0),refreshPage: refreshPage);
}

class ExpandableFab2State extends State<ExpandableFab2>
    with SingleTickerProviderStateMixin {
  Note note;
  final Function(Note note) refreshPage;
  ExpandableFab2State(this.note,{this.refreshPage});
  double _dem = 50.0;

  Icon _icon = Icon(Icons.expand_less);
  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      /*onPanStart:(d){open();} ,*/
      /*onVerticalDragStart:(d){c = Colors.green;},*/

      onPanEnd: (d){open();},
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: _dem,
        height: _dem,
        child: Stack(

          children: <Widget>[
            Align(
              child: FloatingActionButton(backgroundColor: getDarkColor(note?.colorIndex??16),foregroundColor: getTextColor(note?.colorIndex??16),
                  elevation: 20, heroTag: "searchBtn",child: Icon(Icons.search,),onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (c)=>SearchNotesView(widget.openNoteFunction)));}),
              alignment: AlignmentDirectional.center,
            ),
            Align(
                child: FloatingActionButton(backgroundColor: getDarkColor(note?.colorIndex??16),foregroundColor: getTextColor(note?.colorIndex??16),
                    elevation: 20,  heroTag: "sortBtn",child: Icon(Icons.sort),onPressed: ()async{
                  var s = await _sortDialog();
                  if((s)!= null){
                    refreshPage(note);
                  }
                  refreshPage(null);
                }),
                alignment: Alignment(0.5, 1)
            ),
            Align(
              child: FloatingActionButton(backgroundColor: getDarkColor(note?.colorIndex??16),foregroundColor: getTextColor(note?.colorIndex??16),
                  elevation: 20, heroTag: "newFolderBtn",child: Icon(Icons.create_new_folder),onPressed: _newFolderDialog),
              alignment: Alignment(-1, -0.5),
            ),
            Align(
              child: FloatingActionButton(backgroundColor: getDarkColor(note?.colorIndex??16),foregroundColor: getTextColor(note?.colorIndex??16),
                elevation: 20, heroTag: "leftExpandBtn",
                child: _icon,
                onPressed: open,
              ),
              alignment: AlignmentDirectional.bottomStart,
            ),
          ],
        ),
      ),
    );
  }

  void open() {
    _icon =_dem == 50.0 ? Icon(Icons.expand_more):Icon(Icons.expand_less);
    setState(() {
      _dem = _dem == 50.0 ? 200.0:50.0;
    });
  }


  Future<Note> _newFolderDialog()async{

    return await showDialog(context: context,
        builder: (bc){
          return SimpleDialog(
            title: Text("Add Folder :"),shape: BeveledRectangleBorder(),
            children: <Widget>[
                Material(
                  child: FolderDialog(note),
                )

            ],
          );
        }
    );
  }

  Future<Note> _sortDialog()async{

    return await showDialog(context: context,
        builder: (bc){
          return SimpleDialog(
            title: Text("Sort :"),shape: BeveledRectangleBorder(),
            children: <Widget>[
              Material(
                child: Container(height: 200,
                  child: Column(
                    children: <Widget>[
                      FlatButton(onPressed: ()async{
                        var s=await SharedPreferences.getInstance();
                        await s.setInt('order', 0);
                        Navigator.of(context).pop(note);
                      }, child: Text("Newest")),
                      FlatButton(onPressed: ()async{
                        var s=await SharedPreferences.getInstance();
                        await s.setInt('order', 1);
                        Navigator.of(context).pop(note);
                      }, child: Text("Oldest")),
                      FlatButton(onPressed: ()async{
                        var s=await SharedPreferences.getInstance();
                        await s.setInt('order', 2);
                        Navigator.of(context).pop(note);
                      }, child: Text("Name")),
                      FlatButton(onPressed: ()async{
                        var s=await SharedPreferences.getInstance();
                        await s.setInt('order', 3);
                        Navigator.of(context).pop(note);
                      }, child: Text("Name Desc")),
                    ],
                  ),
                ),
              )

            ],
          );
        }
    );
  }
  @override
  void dispose() {
    /*if(_folderNote.name.trim().isNotEmpty){
      NotesRepository().addNote(_folderNote);

    }
    _folderNote.name = '';
    _folderNote.colorIndex = 0;*/
    super.dispose();
  }
  /*void changeNoteColor(Color c) {
    _folderNote?.colorIndex = _colors.indexOf(c);
    _folderNote?.modificationDate = DateTime.now();

  }*/


}

class OneFab extends State<ExpandableFab2>{
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(heroTag: "searchBtn",onPressed: (){_testAddManyNotes();/*Navigator.push(context, MaterialPageRoute(builder: (c)=>SearchNotesView()));*/},
      child: Icon(Icons.search),

    );
  }
  void clearNotes(){
    NotesDb().getDb().then((d)=>d.delete("Note"));
  }
  void _testAddManyNotes(){
    for(int i = 1;i <= 40;i++){
      NotesRepository().addNote(Note(id: 1000+i,parentId: 101,name: "note$i",content:Random().nextInt(100)%2 == 0 ? "content${(i * 10)}":longStr,type: Random().nextInt(100)%2 == 0 ?NoteType.Note:NoteType.CheckList,colorIndex: Random().nextInt(17)));
      int ss = 0;
      /*for(int s = 0;s<10;s++){
        *//*var nn =(ss*10)+i;*//*
        await NotesRepository().addNote(Note(id: (i * 10)+s,parentId: i,name: "note${(i * 10)+s}",content:Random().nextInt(100)%2 == 0 ? "content${(i * 10)+s}":longStr,type: Random().nextInt(100)%2 == 0 ?NoteType.Note:NoteType.CheckList,colorIndex: Random().nextInt(17)));
        for(int f = 0;f<10;f++){
          await NotesRepository().addNote(Note(id: (((i * 10)+s)*10)+f,parentId: (i * 10)+s,name: "note${(((i * 10)+s)*10)+f}",content:Random().nextInt(100)%2 == 0 ? "content${(((i * 10)+s)*10)+f}":longStr,type: Random().nextInt(100)%2 == 0 ?NoteType.Note:NoteType.CheckList,colorIndex: Random().nextInt(17)));
        }
      }*/
    }
  }

  String longStr = "For simple searches, there is a search box at the top of every page. Type what you are looking for in the box. Partial matches will appear in a dropdown list. Select any page in the list to go to that page. Or, select the magnifying glass  button, or press ↵ Enter, to go to a full search result. For advanced searches, see Help:Searching.\n"
      "For simple searches, there is a search box at the top of every page. Type what you are looking for in the box. Partial matches will appear in a dropdown list. Select any page in the list to go to that page. Or, select the magnifying glass  button, or press ↵ Enter, to go to a full search result. For advanced searches, see Help:Searching.\n"
      "For simple searches, there is a search box at the top of every page. Type what you are looking for in the box. Partial matches will appear in a dropdown list. Select any page in the list to go to that page. Or, select the magnifying glass  button, or press ↵ Enter, to go to a full search result. For advanced searches, see Help:Searching.\n"
      "For simple searches, there is a search box at the top of every page. Type what you are looking for in the box. Partial matches will appear in a dropdown list. Select any page in the list to go to that page. Or, select the magnifying glass  button, or press ↵ Enter, to go to a full search result. For advanced searches, see Help:Searching.\n";
}

class FolderDialog extends StatefulWidget{
  Note note;
  bool isEdit;
  FolderDialog(this.note,{this.isEdit = false});
  @override
  State<StatefulWidget> createState()=>FolderDialogState(note,isEdit: isEdit);

}

class FolderDialogState extends State<FolderDialog>{
  Note note;
  bool isEdit;
  FolderDialogState(this.note,{this.isEdit});
  Note _folderNote;
  List<Color> _colors;
  Color _color;
  @override
  void initState() {
    _folderNote = isEdit?note: Note(parentId: note.id,colorIndex: 0,type: NoteType.Folder);
    _colors = List();
    for (int i = 0; i < 17; i++) {
      _colors.add(getDarkColor(i));
    }
    _color = getDarkColor(_folderNote?.colorIndex ?? 0);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.symmetric(horizontal: 15),padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: _color,borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: <Widget>[
          Wrap(direction: Axis.horizontal,
            children: _colors
                .map((c) => GestureDetector(
                onTap: () {
                  _color = c;
                  _folderNote.colorIndex = _colors.indexOf(c);
                  setState(() {});
                },
                child: Container(
                  margin: EdgeInsets.only(right: 4, bottom: 1),
                  width: 40,
                  height: 40,
                  decoration:
                  BoxDecoration(color: c, shape: BoxShape.circle),
                  child: Text(""),
                )))
                .toList(),
          ),

          Text("Name:",style: TextStyle(color: Colors.white),),
          TextField(style: TextStyle(color: Colors.white,fontSize: 20),textAlign: TextAlign.center,
            onChanged: (s){_folderNote.name = s;},
            maxLines: 1,
            controller: TextEditingController(text: _folderNote.name)
              ..selection = TextSelection.collapsed(offset: _folderNote.name.length),
            maxLength: 50,
            autofocus: true,
          ),
          Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(child: Text(isEdit?"Apply":"Add"),onPressed: ()async{
                if(_folderNote.name.trim().isNotEmpty){
                  isEdit?await NotesRepository().updateNote(_folderNote): await NotesRepository().addNote(_folderNote);

                }

                Navigator.of(context).pop(isEdit?_folderNote:null);
              },),
              RaisedButton(child: Text("Cancel"),onPressed: (){


                _folderNote.name = '';
                _folderNote.colorIndex = 0;

                Navigator.of(context).pop(isEdit?_folderNote:null);
              },)
            ],)
        ],
      ),
    );
  }

}
