import 'package:flutter/material.dart';
import 'package:new_new_msnotes/Data/Entities/Note.dart';
import 'package:new_new_msnotes/Helpers/ColorHelper.dart';

class NoteCardView extends StatelessWidget {
  final Note _note;

  NoteCardView(this._note);

  @override
  Widget build(BuildContext context) {
    return Padding(key: Key(_note.id.toString()),
      padding: EdgeInsets.all(5.0),
      child: Card(
          elevation: 10,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: getPrimColor(_note.colorIndex),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  _note.modificationDate.toIso8601String().substring(0, 16).replaceAll('T', '    '),overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 10, color: getTextColor(_note.colorIndex)),
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
                        child: Text(_note.name,overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.white)),
                      )),
                ),
                Divider(
                  height: 20,
                ),
                Expanded(child: Hero(
                    tag: "${_note.id}_content",
                    child: Material(
                      color: Colors.transparent,
                      child: Text(_note.content,softWrap: false,maxLines: 7,overflow:  TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14, color: getTextColor(_note.colorIndex))),
                    )
                ),)
              ],
            ),
          )),
    );
  }
}
