/*
import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:new_ms_notes/Views//Cards/CheckListCardView.dart';
import 'package:new_ms_notes/Views/Cards/FolderCardView.dart';
import 'package:new_ms_notes/Views/Cards/NoteCardView.dart';
import 'package:new_ms_notes/Data/Entities/Note.dart';
import 'package:new_ms_notes/Data/NotesRepository.dart';

class SearchNotesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchNotesState();
}

class SearchNotesState extends State<SearchNotesView> {
  List<String> _titles;
  List<dynamic> _whereArgs;
  List<Note> _notes;
  CancelableOperation _cancelableOperation;
  List<Note> _notesToDisplay;


  @override
  void initState() {
    _titles = ['name', 'content', 'type'];
    _whereArgs = ['', '', -1];
    _notesToDisplay = List();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Container(
        height: 60,
      ),
      Expanded(child: WillPopScope(
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.grey[300],
                  centerTitle: true,
                  title: Text('Search', style: TextStyle(color: Colors.black),),
                  pinned: true,
                ),
                SliverToBoxAdapter(
                    child: Container(child:
                    _buildSearchStuff(), height: 300, color: Colors.grey[400],


                    ))
              ];
            },
            body:
            */
/*GestureDetector(
            onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteTopView()));},
            child:*//*

            */
/* WillPopScope(child:*//*
 Stack(
                children: <Widget>[
                  _notes != null && _notes.isNotEmpty? GridView.builder(
            itemCount:  _notes.length,

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery
                        .of(context)
                        .size
                        .shortestSide < 600 ? 2 : 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4),
                itemBuilder: (BuildContext context, int index) {
                  return _buildOneItem(_notes[index]);
                })
                : CircularProgressIndicator()

        ],
      ) */
/*, onWillPop: _refresh)*//*

      ),

    ))]
    )
    );
  }

  void _getGrid() {
    var w = List<String>();
    var wa = List<dynamic>();
    if ((_whereArgs[0] as String)
        .trim()
        .isNotEmpty) {
      w.add("LOWER(" + _titles[0] + ")");
      wa.add((_whereArgs[0] as String).toLowerCase());
    }
    if ((_whereArgs[1] as String)
        .trim()
        .isNotEmpty) {
      w.add("LOWER(" + _titles[1] + ")");
      wa.add((_whereArgs[1] as String).toLowerCase());
    }
    if ((_whereArgs[2] as int) >= 0) {
      w.add(_titles[2]);
      wa.add(_whereArgs[2]);
    }
    if (w.isEmpty) return;
    getNotes(w, wa);

  }

  Widget _buildMassoudTextField(String title,
      {Function(String str) onChanged, int i = 0}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(child: Text(
          title, style: TextStyle(color: Colors.blue, fontSize: 20),),),
        Expanded(child: TextField(
          onChanged: onChanged,
          controller: TextEditingController(text: _whereArgs[i])..selection = TextSelection.collapsed(offset: (_whereArgs[i] as String).length),
          style: TextStyle(),
          textAlign: TextAlign.center,
          cursorColor: Colors.black,
        ),)
      ],
    );
  }

  Widget _buildSearchStuff() {
    return Column(mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(child: _buildMassoudTextField('Title :', onChanged: (s) {
          _whereArgs[0] = s;
          _getGrid();
        }, i: 0),),
        Expanded(child: _buildMassoudTextField(
            'Content Contains : ', onChanged: (s) {
          _whereArgs[1] = s;
          _getGrid();
        }, i: 1)),
        Expanded(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(child: Text(
              'Type :', style: TextStyle(color: Colors.blue, fontSize: 20),),),
            Expanded(child: DropdownButton(
                items: <String>['Any', 'Note', 'CheckList', 'Folder'].map((s) =>
                    DropdownMenuItem(child: Text(s), value: s,)).toList(),value: _whereArgs[2] == -1?'Any':(_whereArgs[2] == 1?'CheckList':(_whereArgs[2] == 2?"Folder":"Note") ),
                onChanged: (v) {
                  switch (v) {
                    case'Any':
                      _whereArgs[2] = -1;
                      break;
                    case'CheckList':
                      _whereArgs[2] = 1;
                      break;
                    case'Folder':
                      _whereArgs[2] = 2;
                      break;
                    default:
                      _whereArgs[2] = 0;
                      break;
                  }
                  _getGrid();
                }))
          ],
        ),),

      ],
    );
  }

  Widget _buildOneItem(Note note) {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (b) => NoteTopView(note: note,)));
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

  Future getNotes(List<String> cols, List<dynamic> whereArgs) async {
    _cancelableOperation?.cancel();
    _cancelableOperation = CancelableOperation.fromFuture(
        NotesRepository().getNotesWhere(cols, whereArgs));
    _cancelableOperation.value.then((nl) {
      _notes = (nl as List<Note>);
      setState(() {

      });
    });
  }
}*/
