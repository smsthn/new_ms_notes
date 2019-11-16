import 'package:flutter/material.dart';
import 'package:new_new_msnotes/Data/Entities/Note.dart';
import 'package:new_new_msnotes/Helpers/ColorHelper.dart';

class FolderCardView extends StatelessWidget {
  final Note _note;

  FolderCardView(this._note);

  @override
  Widget build(BuildContext context) {
    return Padding(key: Key(_note.id.toString()),
      padding: EdgeInsets.all(5.0),
      child: Stack(
        children: <Widget>[

           Container(
             decoration: BoxDecoration(
                 color: getDarkColor(_note.colorIndex),
               borderRadius: BorderRadius.circular(50)
             ),
              
             child: Image.asset('assets/folder_icon.png',
               fit: BoxFit.contain,
               alignment: AlignmentDirectional.center,
             ),
            ),

           Padding(padding: EdgeInsets.all(20),
             child: Center(
               child: Text(_note.name,style: TextStyle(fontSize: 24,color: Colors.white),),
             ),
           )

        ],
      ),
    );
  }
}
