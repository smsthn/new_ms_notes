import 'package:flutter/material.dart';
import 'package:new_new_msnotes/Data/Entities/Note.dart';
import 'package:new_new_msnotes/Helpers/ColorHelper.dart';

class SelectedNoteCardView extends StatelessWidget {
  final Note _note;

  SelectedNoteCardView(this._note);

  @override
  Widget build(BuildContext context) {
    return Container(constraints: BoxConstraints(maxHeight: 10),
      decoration: BoxDecoration(color: getPrimColor(_note.colorIndex)),
      child: Flex(
          direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(25),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: getTransparentColor(_note.colorIndex)),
            child: Center(
                child: Text(
                  _note.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
          ),
        ],
      )
    );
  }
}
