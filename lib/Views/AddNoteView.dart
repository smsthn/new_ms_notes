import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_ms_notes/Data/Entities/Note.dart';
import 'package:new_ms_notes/Data/NotesRepository.dart';
import 'package:new_ms_notes/Helpers/ColorHelper.dart';
import 'package:new_ms_notes/Helpers/ImageHelper.dart';
import 'package:path/path.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class AddNoteView extends StatefulWidget {
  final Note note;
  final int parentId;

  AddNoteView({this.note, this.parentId});

  @override
  State<StatefulWidget> createState() =>
      AddNoteState(note: note, parentId: parentId ?? 0);
}

class AddNoteState extends State<AddNoteView> {
  Note note;
  List<Color> _colors;
  int parentId;
  List<String> checkList;
  List<bool> checkListBools;
  List<FocusNode> _focusNodes;
  AddImageHandler _addImageHandler;
  FocusNode _titleFocusNode;
  FocusNode _contentFocusNode;

  bool isOpenForEdit = false;

  AddNoteState({this.note, this.parentId}) {
    checkList = List();
    checkListBools = List();
    _focusNodes = List();
    if (note != null &&
        note.type == NoteType.CheckList &&
        note.content != null) {
      checkList.clear();
      var ctn = note.content.split("\n");
      ctn.removeWhere((s) => s.trim() == "");
      ctn.add("0");
      _focusNodes = List.generate(ctn.length, (s) => FocusNode());
      checkList.addAll(ctn);
      checkListBools.clear();
      var i = 0;
      checkList.forEach((item) {
        checkListBools.add(item[0] == '1');
        checkList[i] = item.length == 1 ? '' : item.substring(1);
        i++;
      });
    }
  }

  Color _color;

  @override
  void initState() {
    _colors = List();
    for (int i = 0; i < 17; i++) {
      _colors.add(getPrimColor(i));
    }
    _color = getPrimColor(note?.colorIndex ?? 0);
    isOpenForEdit = note != null;
    if (!isOpenForEdit) {
      note = Note(parentId: parentId);
    }
    _titleFocusNode = FocusNode();
    _contentFocusNode = FocusNode();
    super.initState();
  }

  Widget _getTop(Widget top, Widget body) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(child: top),
          ];
        },
        body: body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*appBar: AppBar(backgroundColor: Colors.green,title: Text("sasa"),),*/
        body: Column(children: <Widget>[
      Container(
        height: 60,
      ),
      Expanded(
        child: WillPopScope(
            child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding:
                    EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 5),
                color: _color,
                child: _getTop(
                    Column(
                      children: <Widget>[
                        _chooseTypeWidget(),
                        Divider(),
                        _additionsWidget(),
                        Divider(),
                        _chooseColorWidget(),
                        Divider(),
                        _photosWidget(),
                        //Title

                        //Content
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        _titleWidget(),
                        _contentWidget(),
                      ],
                    ))),
            onWillPop: () async {
              // if(!isOpenForEdit)
              if (isOpenForEdit ||
                  note.name.isNotEmpty ||
                  note.content.isNotEmpty
                  ) {
                print("WILL SAVE");
                if (note.type == NoteType.CheckList) {
                  note.content = '';
                  var i = 0;
                  checkList.forEach((s) {
                    if (s.trim().isNotEmpty) {
                      note.content +=
                          (checkListBools[i++] ? "1" : "0") + s + "\n";
                    }
                  });
                }
                if (isOpenForEdit) {
                  print("EDITING");
                  NotesRepository().updateNote(note);
                  Navigator.of(context).pop(note);
                  _addImageHandler.saveImages(note.id);
                  return false;
                } else {
                  print("ADDING");
                  var nt = await NotesRepository().addNote(note);
                  _addImageHandler.saveImages(nt.id);
                  return true;
                }
              } else {
                print("WONT SAVE");
                if(_addImageHandler?.images?.isNotEmpty??false)
                  return await _showWillDiscardDialog();
                else
                  return true;
              }
            }),
      )
    ]));
  }
  Future<bool> _showWillDiscardDialog()async{
    bool exit = true;
   return await showDialog(
     context: this.context,
     builder: (ctx){
       return SimpleDialog(title: Text("No Title Given"),
       children: <Widget>[
         Text("You need to give a title to keep the images or you can discard note with images"),
         Row(children: <Widget>[
           RaisedButton(onPressed: (){Navigator.pop(this.context,true);},child: Text("Discard"),),
           RaisedButton(onPressed: (){Navigator.pop(this.context,false);},child: Text("Back to give Title"),),
         ],)
       ],
       );
     }
   );
   
  }
  Widget _photosWidget() {
    if (_addImageHandler == null)
      _addImageHandler =
          new AddImageHandler(MediaQuery.of(this.context).size.width.toInt());
    return FutureBuilder(
      future: _addImageHandler.getImages(noteId: note?.id ?? 0),
      builder: (c, snap) {
        if (snap.hasData && (snap.data as List<File>).isNotEmpty) {
          return Container(
            width: MediaQuery.of(c).size.width,
            height: MediaQuery.of(c).size.height / 4,
            child: ListView(
              children: (snap.data as List<File>)
                  .map((f) => GestureDetector(
                        onTap: () {
                          Navigator.of(c).push(MaterialPageRoute(
                              builder: (c) => _previewImageWidget(f)));
                        },
                        child: Container(
                          padding: EdgeInsets.all(1),
                          child: Image.file(f),
                        ),
                      ))
                  .toList(),
              scrollDirection: Axis.horizontal,
            ),
          );
        } else {
          return SizedBox(
            height: 0,
            width: 0,
          );
        }
      },
    );
  }

  Widget _previewImageWidget(File f) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            child: Text("Delete"),
            onPressed: (){_deletePhoto(file: f);},
          ),
          FlatButton(
            child: Text("Save To Gallery"),
            onPressed: () {
              _savePhoto(f);
            },
          ),
        ],
      ),
      body: Image.file(_addImageHandler.images
          .firstWhere((i) => basename(i.path) == basename(f.path))),
    );
  }

  void _deletePhoto({int index, File file})async {
    if (file != null) {
      await _addImageHandler.removeImage(file: file);
    } else if (index != null) {
      await _addImageHandler.removeImage(index: index);
    }
    Navigator.of(this.context).pop(true);
    setState(() {});
  }

  void _savePhoto(File imgFile) async {
    final result = await ImageGallerySaver.save(imgFile.readAsBytesSync());
    if (result as bool) {
      Scaffold.of(this.context).showSnackBar(SnackBar(
        content: Text("Photo added successfully"),
      ));
    } else {
      Scaffold.of(this.context).showSnackBar(SnackBar(
        content: Text("Photo added successfully"),
      ));
    }
  }

  Widget _contentWidget() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _focusNodes.isNotEmpty
              ? FocusScope.of(this.context).requestFocus(_focusNodes.last)
              : {};
        },
        child: _buildNoteContent(note.type),
      ),
    );
  }


  Widget _buildNoteContent(NoteType type) {
    switch (type) {
      case NoteType.CheckList:
        return _getRows(checkList, checkListBools);

      default:
        return Hero(
          tag: "${note.id}_content",
          child: EditableText(
            maxLines: null,
            onChanged: (s) {
              note?.content = s;
              note?.modificationDate = DateTime.now();
            },
            controller: TextEditingController(text: note?.content ?? ""),
            focusNode: _contentFocusNode,
            style:
                TextStyle(color: getTextColor(note.colorIndex), fontSize: 24),
            cursorColor: Colors.black,
            // backgroundCursorColor: Colors.black,
          ),
        );
    }
  }
  Widget _getRows(List<String> st, List<bool> bols) {
    return ListView(
      children: getChildren(
              st) ,
    );
  }

  List<Widget> getChildren(List<String> st) {
    var lst = List<Widget>();
    for (int i = 0; i < st.length; i++) {
      lst.add(Padding(
        key: Key(i.toString() + 'AddEditViewCheckableList'),
        padding: EdgeInsets.only(top: 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Checkbox(
                  value: checkListBools[i],
                  checkColor: getTextColor(note.colorIndex),
                  activeColor: getTextColor(note.colorIndex),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (b) {
                    checkListBools[i] = b;
                    setState(() {});
                  }),
            ),
            Expanded(
              child: TextField(
                maxLines: null,
                textAlign: TextAlign.start,
                onChanged: (s) {
                  if (s.contains('\n')) {
                    if (i != checkList.length - 1) {
                      checkList.insert(i + 1, "");
                      checkListBools.insert(i + 1, false);
                      var f = FocusNode();
                      _focusNodes.insert(i + 1, f);

                      setState(() {
                        FocusScope.of(this.context)
                            .requestFocus(_focusNodes[i + 1]);
                      });
                      return false;
                    }
                  } else {
                    checkList[i] = s;
                    note?.modificationDate = DateTime.now();
                    if (i == checkList.length - 1) {
                      if (s.trim() != "") {
                        checkList.add('');
                        checkListBools.add(false);
                        _focusNodes.add(FocusNode());
                        setState(() {});
                      }
                    }
                    if (i == checkList.length - 2) {
                      if (s.trim() == '') {
                        if (checkList.last.trim() == '') {
                          checkList.removeLast();
                          checkListBools.removeLast();
                          _focusNodes.removeLast().dispose();
                          setState(() {});
                        }
                      }
                    }
                    checkList[i] = s;
                    note?.modificationDate = DateTime.now();
                  }
                },
                controller: TextEditingController(text: checkList[i] ?? "")
                  ..selection =
                      TextSelection.collapsed(offset: checkList[i].length),
                focusNode: _focusNodes[i],
                style: TextStyle(
                    color: getTextColor(note.colorIndex),
                    fontSize: 24,
                    decoration: checkListBools[i]
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
                cursorColor: Colors.black,
                /*backgroundCursorColor: Colors.transparent,*/
                onSubmitted: (s) {
                  if (i != checkList.length - 1) {
                    checkList.insert(i + 1, "");
                    checkListBools.insert(i + 1, false);
                    var f = FocusNode();
                    _focusNodes.insert(i + 1, f);

                    setState(() {
                      FocusScope.of(this.context)
                          .requestFocus(_focusNodes[i + 1]);
                    });
                    return false;
                  }
                },
              ),
            ),
            i != checkList.length - 1
                ? FlatButton.icon(
                    onPressed: () {
                      checkList.removeAt(i);
                      checkListBools.removeAt(i);
                      _focusNodes.removeAt(i);
                      setState(() {});
                    },
                    icon: Icon(Icons.delete_forever),
                    label: Text(""))
                : SizedBox(
                    height: 0,
                  )
          ],
        ),
      ));
    }
    return lst;
  }

  Widget _titleWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      color: getDarkColor(note?.colorIndex ?? 0) ?? Colors.black,
      child: Hero(
        tag: "${note.id}_title",
        child: EditableText(
            controller: TextEditingController(text: note?.name ?? "")
              ..selection = TextSelection.collapsed(offset: note.name.length),
            focusNode: _titleFocusNode,
            onChanged: (s) {
              note?.name = s;
              note?.modificationDate = DateTime.now();
            },
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 42),
            cursorColor: Colors.black,
            // backgroundCursorColor: Colors.black
            ),
      ),
    );
  }

  Widget _chooseColorWidget() {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ListView(
        children: _colors
            .map((c) => GestureDetector(
                onTap: () {
                  changeNoteColor(c);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 7, bottom: 1),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                  child: Text(""),
                )))
            .toList(),
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _chooseTypeWidget() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text("Type:"),
          ),
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ChoiceChip(
                  label: Text("Note"),
                  backgroundColor: Colors.white,
                  selected: note.type == NoteType.Note,
                  onSelected: (b) {
                    if (b) _switchType(NoteType.Note);
                  },
                ),
                ChoiceChip(
                    label: Text("Check List"),
                    backgroundColor: Colors.white,
                    selected: note.type == NoteType.CheckList,
                    onSelected: (b) {
                      if (b) _switchType(NoteType.CheckList);
                    }),
              ],
            ),
          ),
          Align(
              alignment: AlignmentDirectional.centerEnd,
              child: PopupMenuButton(
                itemBuilder: (c) => _buildMenuItems(),
              ))
        ],
      ),
    );
  }

  Widget _additionsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FloatingActionButton(
          heroTag: "FknBtn",
          child: Icon(Icons.image),
          onPressed: _addImage,
        ),
        FloatingActionButton(
          heroTag: "FknBtn2",
          child: Icon(Icons.camera_alt),
          onPressed: _takePhoto,
        ),
      ],
    );
  }

  void _addImage() async {
    await _addImageHandler.addImage(camera: false);
    setState(() {});
  }

  void _takePhoto() async {
    await _addImageHandler.addImage(camera: true);
    setState(() {});
  }

  List<PopupMenuEntry<dynamic>> _buildMenuItems() {
    return [
      PopupMenuItem(
        child: FlatButton(
          child: Text("Discard"),
          onPressed: () {},
        ),
      ),
    ];
  }
  // PopupMenuEntry<dynamic> _buildOneItem(){

  // }

  @override
  void dispose() {
    _focusNodes
      ..forEach((f) => f.dispose())
      ..clear();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  void changeNoteType(NoteType newType) {}

  void changeNoteColor(Color c) {
    note?.colorIndex = _colors.indexOf(c);
    note?.modificationDate = DateTime.now();
    setState(() {
      _color = c;
    });
  }

  

  void _switchType(NoteType type) {
    if (note.type == type) return;
    if (type == NoteType.CheckList) {
      checkList.clear();
      checkListBools.clear();
      checkList.addAll(
          (note.content ?? "").split("\n").where((s) => s.trim().isNotEmpty));
      checkList.add('');
      checkListBools = List.generate(checkList.length, (s) => false);
      _focusNodes
        ..forEach((s) => s.dispose())
        ..clear()
        ..addAll(List.generate(checkList.length, (s) => FocusNode()));
      note.type = type;
      setState(() {});
    } else {
      note.content = '';
      checkList
          .forEach((s) => s.trim().isNotEmpty ? note.content += s + "\n" : "");
      checkList.clear();
      checkListBools.clear();
      note.type = type;
      setState(() {});
    }
  }

  

  /*Widget _getCheckListTile(int index){
    return CheckboxListTile(value: checkListBools[index], onChanged:(n) {
      checkListBools[index] = n;
    },title: Text(checkList[index]),isThreeLine: true,
    );
  }*/
}
