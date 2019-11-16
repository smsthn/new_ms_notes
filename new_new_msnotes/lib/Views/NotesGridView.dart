/*
import 'package:flutter/material.dart';
import 'package:ms_notes/CustomViews/Cards/SelectedNoteCardView.dart';
import 'package:ms_notes/CustomViews/Cards/CheckListCardView.dart';
import 'package:ms_notes/CustomViews/Cards/FolderCardView.dart';
import 'package:ms_notes/CustomViews/Cards/NoteCardView.dart';
import 'package:ms_notes/CustomViews/NoteTopView.dart';
import 'package:ms_notes/Data/Entities/Note.dart';
import 'package:ms_notes/Data/NotesRepository.dart';


class NotesGridView extends StatefulWidget {
  final Note rootNote;



  NotesGridView({this.rootNote});

  @override
  State<StatefulWidget> createState()=>NotesGridState(rootNote: rootNote);

}

class NotesGridState
    extends State<NotesGridView> */
/*with WidgetsBindingObserver *//*
 {
  Note rootNote;
  List<Note> notes;


  NotesGridState({this.rootNote});

  NotesRepository _repo;



  @override
  void initState() {
    _repo = NotesRepository();
    super.initState();
  }


  @override
  void dispose() {
    */
/*_repo?.refreshFunc?.removeLast();*//*

    super.dispose();
  }



  Future<List<Note>> getNotes(Note rootNote) async {
    if (rootNote == null) {
      var ns = await _repo.getNotesWhereParent(0);
      setState(() {
        notes = ns;
      });
    } else {
      var ns = await _repo.getNotesWhereParent(rootNote.id);
      setState(() {
        notes = ns;
      });
    }
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getNotes(rootNote),
      builder: (ctx, snapshot) {
        if(snapshot.hasData)
            return GridView.builder(
                itemCount: notes == null  ? 0 : notes.length,

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.shortestSide<600?2:3, crossAxisSpacing: 4, mainAxisSpacing: 4),
                itemBuilder: (BuildContext context, int index) {
                  return _buildOneItem(notes[index]);
                });
          else
            return CircularProgressIndicator();

      },);
  }

  Widget _buildOneItem(Note note) {
    return GestureDetector(
      onTap: () async {
        var res = await Navigator.push(context, MaterialPageRoute(
            builder: (context) =>
                NoteTopView(note: note,
                  refresh: () {} */
/*async{await getNotes(rootNote);return true;}*//*
,)));
        if (res as bool == true) {
          getNotes(rootNote);
          setState(() {

          });
        }
      },
      child: _getCardView(note),
    );
  }

  Widget _getCardView(Note note) {
    switch (note.type) {
    */
/*case NoteType.Category:
        return Container(height: 30,child: CategoryCardView(note),);*//*

      case NoteType.CheckList:
      return CheckListCardView(note);
      case NoteType.Folder:
        return FolderCardView(note);
      default:
        return NoteCardView(note);
    }
  }
}
*/
