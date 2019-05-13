import 'package:flutter/material.dart';
import 'package:new_ms_notes/Views//AddNoteView.dart';
import 'package:new_ms_notes/Views//Btns/ExpandableFabs2.dart';
import 'package:new_ms_notes/Data/Entities/Note.dart';
import 'package:new_ms_notes/Data/NotesRepository.dart';
import 'package:new_ms_notes/Helpers/ColorHelper.dart';

class ExpandableFab extends StatefulWidget {
  bool isRoot;
  final Note note;
  final Function(Note note) refreshPage;
  final Function deleteGoBack;
    ExpandableFab({this.note,this.refreshPage,this.deleteGoBack}){
      isRoot = this.note == null || this.note.id == 0;
    }
  @override
  State<StatefulWidget> createState() => isRoot? OneFab(): ExpandableFabState(note,refreshPage);
}

class ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  Note note;
  ExpandableFabState(this.note,this.refreshPage);
  double _dem = 200.0;
  final Function(Note note) refreshPage;
  Icon _icon = Icon(Icons.expand_more);



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
                  elevation: 20,heroTag: "addBtn",child: Icon(Icons.add,),onPressed: ()async{
                var s = await Navigator.push(context, MaterialPageRoute(builder: (c)=>AddNoteView(parentId: note.id,)));
                if((s as Note)!=null){

                  refreshPage(s);
                } else {
                  refreshPage(null);
                }
              }),
              alignment: AlignmentDirectional.center,
            ),
            Align(
              child: FloatingActionButton(backgroundColor: getDarkColor(note?.colorIndex??16),foregroundColor: getTextColor(note?.colorIndex??16),
                  elevation: 20, heroTag: "editBtn",child: Icon(Icons.edit),onPressed: ()async{
                var s = note.type == NoteType.Folder? await _editFolderDialog() :await Navigator.push(context, MaterialPageRoute(builder: (c)=>AddNoteView(note: note,)));
                if((s as Note)!=null){

                  refreshPage(s);
                } else {
                  refreshPage(note);
                }
              }),
              alignment: Alignment(-0.5, 1)
            ),
            Align(
              child: FloatingActionButton(backgroundColor: getDarkColor(note?.colorIndex??16),foregroundColor: getTextColor(note?.colorIndex??16),
                elevation: 20,  heroTag: "deleteBtn",child: Icon(Icons.delete),onPressed: _delete),
              alignment: Alignment(1, -0.5),
            ),
            Align(
              child: FloatingActionButton(backgroundColor: getDarkColor(note?.colorIndex??16),foregroundColor: getTextColor(note?.colorIndex??16),
                elevation: 20,heroTag: "rightExpandBtn",
                child: _icon,
                onPressed: open,
              ),
              alignment: AlignmentDirectional.bottomEnd,
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
  void _delete(){
    showDialog(context: context,
    builder: (bc){
      return AlertDialog(
        title: Text("Delete Confirmation"),
        content: Text("Are you sure you want to delete this note ?"),
        actions: <Widget>[
          RaisedButton(
          child: Text("Delete!",style: TextStyle(color: Colors.red),),
            onPressed: () async{
            await NotesRepository().changeParentThenRemoveNotes(note);
            Navigator.pop(context);
            widget.deleteGoBack();
            
            },
      ),
          RaisedButton(child: Text("Delete note with children!!",style: TextStyle(color: Colors.red[900]),),
            onPressed: ()async{
               await NotesRepository().removeNote(note);
              Navigator.pop(context);
              widget.deleteGoBack();
             
            },
          ),
          RaisedButton(child: Text("Cancel"),onPressed: (){Navigator.pop(context);},)
        ],
      );
    }
    );
  }
  Future<Note> _editFolderDialog()async{

    return await showDialog(context: context,
        builder: (bc){
          return SimpleDialog(
            title: Text("Edit Folder:"),shape: BeveledRectangleBorder(),
            children: <Widget>[
              Material(
                child: FolderDialog(note,isEdit: true,),
              )

            ],
          );
        }
    );
  }

}

class OneFab extends State<ExpandableFab>{
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(backgroundColor: getDarkColor(16),foregroundColor: getTextColor(16),heroTag: "AloneAddBtn",
      elevation: 20,onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (c)=>AddNoteView(parentId: null,)));},
      child: Icon(Icons.add),

    );
  }

}

