import 'package:flutter/material.dart';
import 'package:new_ms_notes/Data/Entities/Note.dart';
import 'package:new_ms_notes/Helpers/ColorHelper.dart';

class CheckListCardView extends StatelessWidget {
  final Note _note;

  CheckListCardView(this._note);

  @override
  Widget build(BuildContext context) {
    var content = StringBuffer("");
    _note.content.split("\n").forEach((s) {
      if (s.isNotEmpty && s[0] == '0') {
        content.writeAll({"-", s.substring(1), "\n"});
      }
    });
    return Padding(
      key: Key(_note.id.toString()),
      padding: EdgeInsets.all(5.0),
      child: Card(
          elevation: 10,
          clipBehavior: Clip.antiAlias,
          shape:
              BeveledRectangleBorder(side: BorderSide(style: BorderStyle.solid,width: 10,
                  color: getDarkColor(_note.colorIndex))),
          color: getDarkColor(_note.colorIndex),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  _note.modificationDate.toIso8601String().substring(0, 15).replaceAll('T', '   '),overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 10, color: Colors.white),
                ),
                Divider(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  color: getDarkColor(_note.colorIndex),
                  child: Hero(
                      tag: "${_note.id}_title",
                      child: Material(
                        color: Colors.transparent,
                        child: Text(_note.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.white)),
                      )),
                ),
                Divider(
                  height: 20,
                ),
                Expanded(
                  child: Hero(
                      tag: "${_note.id}_content",
                      child: Material(
                        color: Colors.white,
                        child: Text(content.toString(),
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black)),
                      )),
                )
              ],
            ),
          )),
    );
  }
}
/*
Text(("-"+_note.content).replaceAll(";", "\n-"), textAlign: TextAlign.start,
style: TextStyle(fontSize: 14)),*/
