



import 'package:flutter/material.dart';
import 'package:new_new_msnotes/Data/Entities/Note.dart';
import 'package:new_new_msnotes/Data/NotesRepository.dart';
import 'package:new_new_msnotes/Views/Btns/ExpandableFab.dart';
import 'package:new_new_msnotes/Views/Btns/ExpandableFabs2.dart';

class Btns{

  Widget getExpandables(Note note,Function(Note note) refreshFunction,Function deleteGoBack,Function(Note note) openNoteFunction){
    return Stack(key: UniqueKey(),
      children: <Widget>[
        Align(alignment: AlignmentDirectional.bottomStart,child: ExpandableFab2(note: note,refreshPage: refreshFunction,openNoteFunction: openNoteFunction,),),
        Align(alignment: AlignmentDirectional.bottomEnd,child: ExpandableFab(note: note,refreshPage: refreshFunction,deleteGoBack:deleteGoBack ,),)
      ],
    );
  }
  Widget getmoveBtns(Function moveFunc,Function cancelFunc,bool isSelectionMode,Function deleteFunc){
    return Stack(
      children: <Widget>[
        Align(alignment: AlignmentDirectional.bottomCenter,child: Column(children: <Widget>[
          RaisedButton(onPressed: moveFunc,child: Text(isSelectionMode?"Move":"Move Here"),),
          isSelectionMode?RaisedButton(onPressed: deleteFunc,child: Text("delete"),):SizedBox(height: 0,width: 0,),
          RaisedButton(onPressed: cancelFunc,child: Text("Cancel"),)
        ],),)
      ],
    );
  }
  

}