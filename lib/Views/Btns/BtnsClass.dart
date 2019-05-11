



import 'package:flutter/material.dart';
import 'package:new_ms_notes/Data/Entities/Note.dart';
import 'package:new_ms_notes/Views/Btns/ExpandableFab.dart';
import 'package:new_ms_notes/Views/Btns/ExpandableFabs2.dart';

class Btns{

  Widget getExpandables(Note note,Function(Note note) refreshFunction){
    return Stack(key: UniqueKey(),
      children: <Widget>[
        Align(alignment: AlignmentDirectional.bottomStart,child: ExpandableFab2(note: note,refreshPage: refreshFunction),),
        Align(alignment: AlignmentDirectional.bottomEnd,child: ExpandableFab(note: note,refreshPage: refreshFunction),)
      ],
    );
  }
  Widget getmoveBtns(Function moveFunc,Function cancelFunc,bool isSelectionMode){
    return Stack(
      children: <Widget>[
        Align(alignment: AlignmentDirectional.bottomCenter,child: Row(children: <Widget>[
          RaisedButton(onPressed: moveFunc,child: Text(isSelectionMode?"Move":"Move Here"),),
          RaisedButton(onPressed: cancelFunc,child: Text("Cancel"),)
        ],),)
      ],
    );
  }

}