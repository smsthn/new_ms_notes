import 'dart:collection';
import 'dart:io';

import 'package:async/async.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_new_msnotes/Data/Entities/Note.dart';
import 'package:new_new_msnotes/Data/NotesRepository.dart';
import 'package:new_new_msnotes/Helpers/ColorHelper.dart';
import 'package:new_new_msnotes/Helpers/ImageHelper.dart';
import 'package:new_new_msnotes/Views/AddNoteView.dart';
import 'package:new_new_msnotes/Views/Btns/BtnsClass.dart';
import 'package:new_new_msnotes/Views/Cards/CheckListCardView.dart';
import 'package:new_new_msnotes/Views/Cards/FolderCardView.dart';
import 'package:new_new_msnotes/Views/Cards/NoteCardView.dart';

import 'Btns/ExpandableFabs2.dart';

class Top extends StatefulWidget {
  TopState _stt;

  @override
  State<StatefulWidget> createState() {
    _stt = TopState();
    return _stt;
  }
}

class TopState extends State<Top> {
  Note _rootNote;
  bool _isSelectionMode;
  bool _isMovingMode;
  List<Note> _children;
  List<Note> _selectedNotes;
  List<String> _checkList;
  List<bool> _checkListBools;
  Queue<Note> _prevNotesStack;
  static BannerAd _bannerAd;
  CancelableOperation _cancellableOperation;
  bool _hideBtns;
  GlobalKey _topKey;
  Stack _btns;
  ScrollController _scrollController;

  TopState() {
    _rootNote = Note(id: 0);
    _isSelectionMode = false;
    _isMovingMode = false;
    _children = List();
    _selectedNotes = List();
    _checkList = List();
    _checkListBools = List();
    _prevNotesStack = Queue();
  }
  @override
  void initState() {
    // FirebaseAdMob.instance.initialize(appId: BannerAd.testAdUnitId);
    // _bannerAd =
    //     BannerAd(adUnitId: BannerAd.testAdUnitId, size: AdSize.smartBanner);
    // _bannerAd
    //   ..load()
    //   ..show(anchorType: AnchorType.top);
    _hideBtns = false;
    getNotes();
    _topKey = GlobalKey();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _hideBtns = false;
      });
    } else if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _hideBtns = false;
      });
    } else {
      if (!_hideBtns) {
        setState(() {
          _hideBtns = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: _rootNote == null || _rootNote.id == 0
            ? Stack(
                children: <Widget>[
                  Container(
                    color: getTransparentColor(_rootNote?.colorIndex ?? 16),
                  ),
                  _getGrid(_children),
                  _getBtns()
                ],
              )
            : Stack(
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _hideBtns = false;
                      setState(() {});
                    },
                    child: _getTop(),
                  ),
                  if (!_hideBtns || !_longEnough()) _getBtns()
                ],
              ),
        onWillPop: _prevNotesStack.isEmpty ? () async => true : notePopFunc);
  }

  bool _longEnough() {
    var le = ((_topKey?.currentContext?.findRenderObject() as RenderBox)
                ?.size
                ?.height ??
            0) >=
        (MediaQuery.of(this.context).size.height - 60);
    return le;
  }

  Future<bool> notePopFunc() {
    _rootNote = _prevNotesStack.removeLast();
    _getBtns();
    setState(() {});
    getNotes();
  }

  Widget _getTop() {
    int top = 0;
    var nsc = NestedScrollView(
        key: _topKey,
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor:
                  getDarkColor(_rootNote == null ? 0 : _rootNote.colorIndex),
              centerTitle: true,
              title: Hero(
                  tag: "${_rootNote.id}_title",
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      _rootNote.name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )),
              pinned: true,
            ),
            SliverToBoxAdapter(
                child: _rootNote.type != NoteType.Folder
                    ? Container(
                        color: _rootNote.colorIndex != 16
                            ? getPrimColor(
                                _rootNote == null ? 0 : _rootNote.colorIndex)
                            : getLightColor(16),
                        child: Column(
                          children: <Widget>[
                            FutureBuilder(
                              future: ImageHelper.getNotePhotos(_rootNote),
                              builder: (c, snap) {
                                if (snap.hasData &&
                                    snap.data is List<File> &&
                                    (snap.data as List<File>).length != 0) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height -
                                        (MediaQuery.of(context).size.height /
                                            10),
                                    child: _getPics(snap.data as List<File>),
                                  );
                                } else {
                                  return SizedBox(
                                    height: 0,
                                    width: 0,
                                  );
                                }
                              },
                            ),
                            Hero(
                              tag: "${_rootNote.id}_content",
                              child: Material(
                                  color: Colors.transparent,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.deferToChild,
                                    onDoubleTap: () async {
                                      var s = _rootNote.type == NoteType.Folder
                                          ? await _editFolderDialog()
                                          : await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (c) => AddNoteView(
                                                        note: _rootNote,
                                                      )));
                                      setState(() {});
                                      ;
                                    },
                                    child: _rootNote.type == NoteType.CheckList
                                        ? Wrap(
                                            direction: Axis.horizontal,
                                            children: _getCheckables(
                                                _rootNote.content),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              _rootNote.content,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: getTextColor(
                                                      _rootNote.colorIndex)),
                                            ),
                                          ),
                                  )),
                            )
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ))
          ];
        },
        body: Stack(
          children: <Widget>[
            Container(
              color: getTransparentColor(_rootNote?.colorIndex ?? 16),
            ),
            _getGrid(_children)
          ],
        ));

    return nsc;
  }

  Future<Note> _editFolderDialog() async {
    return await showDialog(
        context: this.context,
        builder: (bc) {
          return SimpleDialog(
            title: Text("Edit Folder:"),
            shape: BeveledRectangleBorder(),
            children: <Widget>[
              Material(
                child: FolderDialog(
                  _rootNote,
                  isEdit: true,
                ),
              )
            ],
          );
        });
  }

  Widget _getBtns() {
    return _isMovingMode
        ? Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Container(
                height: 100,
                child: Row(
                  children: <Widget>[
                    Btns().getmoveBtns(_moveFunc, _cancelMoving, false, null),
                    _getSelectedListView()
                  ],
                )))
        : _isSelectionMode
            ? Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Container(
                  height: 150,
                  child: Row(
                    children: <Widget>[
                      Btns().getmoveBtns(
                          _startMovingFunc, _cancelSelection, true, _deleteAll),
                      _getSelectedListView()
                    ],
                  ),
                ))
            : Btns().getExpandables(
                _rootNote, _refreshFunc, notePopFunc, tapNoteBtn);
  }

  void _refreshFunc(Note note) {
    if (note == null) {
      getNotes();
      return;
    }
    tapNoteBtn(note);
  }

  void _startMovingFunc() {
    _isMovingMode = true;
    _isSelectionMode = false;
    setState(() {});
  }

  void _cancelSelection() {
    _children.addAll(_selectedNotes);
    _selectedNotes.clear();
    _isMovingMode = false;
    _isSelectionMode = false;
    setState(() {});
  }

  void _moveFunc() async {
    await NotesRepository()
        .changeParents(_selectedNotes.map((n) => n.id).toList(), _rootNote.id);
    _selectedNotes.clear();
    _isMovingMode = false;
    _isSelectionMode = false;
    getNotes();
  }

  void _cancelMoving() {
    _selectedNotes.clear();
    _isMovingMode = false;
    _isSelectionMode = false;
    setState(() {});
  }

  Widget _getGrid(List<Note> notes) {
    return GridView.builder(
        itemCount: notes == null ? 0 : notes.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).size.shortestSide < 600 ? 2 : 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4),
        itemBuilder: (BuildContext context, int index) {
          return _buildOneItem(notes[index]);
        });
  }

  Widget _buildOneItem(Note note) {
    return GestureDetector(
      onTap: () {
        if (_isSelectionMode) {
          _selectedNotes.add(note);
          _children.remove(note);
          setState(() {});
          return;
        }
        tapNoteBtn(note);
      },
      onLongPress: () {
        _selectedNotes.add(note);
        _children.remove(note);
        _isSelectionMode = true;
        setState(() {});
      },
      onLongPressUp: () {
        if (_children.contains(note)) _children.remove(note);
      },
      child: _getCardView(note),
    );
  }

  void tapNoteBtn(Note note) {
    if (note == _rootNote) return;
    if (!_prevNotesStack.contains(note)) {
      _prevNotesStack.addLast(_rootNote.clone());
    }
    _rootNote = note;
    _getBtns();

    getNotes();
  }

  Widget _getCardView(Note note) {
    switch (note.type) {
      /*case NoteType.Category:
        return Container(height: 30,child: CategoryCardView(note),);*/
      case NoteType.CheckList:
        return CheckListCardView(note);
      case NoteType.Folder:
        return FolderCardView(note);
      default:
        return NoteCardView(note);
    }
  }

  Widget _getSelectedListView() {
    return _selectedNotes.isEmpty
        ? SizedBox(
            height: 0,
            width: 0,
          )
        : Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:
                  _selectedNotes.map((n) => _buildOneSelectedNote(n)).toList(),
            ),
          );
  }

  Widget _buildOneSelectedNote(Note note) {
    return GestureDetector(
      onTap: () {
        _children.add(note);
        _selectedNotes.remove(note);
        if (_isSelectionMode) _isSelectionMode = _selectedNotes.isNotEmpty;
        if (_isMovingMode) _isMovingMode = _selectedNotes.isNotEmpty;
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 25),
        child: Container(
          color: getPrimColor(note.colorIndex),
          constraints: BoxConstraints.tightFor(height: 40),
          width: 100,
          height: 40,
          child: Text(
            note.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(color: getTextColor(note.colorIndex)),
          ),
        ),
      ),
    );
  }

  List<Widget> _getCheckables(String content) {
    _getCheckList();
    List<Widget> wdg = List.generate(_checkList.length, (i) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Checkbox(
              activeColor: getTextColor(_rootNote?.colorIndex ?? 0),
              onChanged: (b) {
                changeCheck(i, b);
              },
              value: _checkListBools[i],
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              _checkList[i],
              style: TextStyle(
                  color: getTextColor(_rootNote.colorIndex),
                  decoration: _checkListBools[i]
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
          ),
        ],
      );
    });
    return wdg;
  }

  void _getCheckList() {
    if (_rootNote != null && _rootNote.type == NoteType.CheckList) {
      _checkList = List();
      _checkListBools = List();
      if (_rootNote != null &&
          _rootNote.type == NoteType.CheckList &&
          _rootNote.content != null) {
        _checkList.clear();
        var ctn = _rootNote.content.split("\n");
        ctn.removeWhere((s) => s.trim() == "");
        _checkList.addAll(ctn);
        _checkListBools.clear();
        var i = 0;
        _checkList.forEach((item) {
          _checkListBools.add(item[0] == '1');
          _checkList[i] = item.length == 1 ? '' : item.substring(1);
          i++;
        });
      }
    }
  }

  void changeCheck(int index, bool value) {
    _checkListBools[index] = value;
    setState(() {});
    var str = StringBuffer('');
    for (int i = 0; i < _checkList.length; i++) {
      str.write(_checkListBools[i] ? '1' : '0');
      str.write(_checkList[i]);
      str.write('\n');
    }
    _rootNote.content = str.toString();
    NotesRepository().updateNote(_rootNote);
  }

  Future getNotes() {
    _cancellableOperation?.cancel();
    _cancellableOperation = CancelableOperation.fromFuture(
        NotesRepository().getNotesWhereParent(_rootNote?.id ?? 0));
    _cancellableOperation.value.then((nl) {
      _children = nl as List<Note>;
      if (_selectedNotes.isNotEmpty)
        _children.removeWhere((n) => _selectedNotes.contains(n));
      setState(() {});
    });
  }

  void _deleteAll() {
    showDialog(
        context: context,
        builder: (bc) {
          return AlertDialog(
            title: Text("Delete Confirmation"),
            content: Text("Are you sure you want to delete this note ?"),
            actions: <Widget>[
              RaisedButton(
                child: Text(
                  "Delete!",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  for (var note in _selectedNotes) {
                    await NotesRepository().changeParentThenRemoveNotes(note);
                  }
                  _selectedNotes.clear();
                  Navigator.pop(context);
                  _isSelectionMode = false;
                  _isMovingMode = false;
                  getNotes();
                },
              ),
              RaisedButton(
                child: Text(
                  "Delete note with children!!",
                  style: TextStyle(color: Colors.red[900]),
                ),
                onPressed: () async {
                  for (var note in _selectedNotes) {
                    await NotesRepository().removeNote(note);
                  }
                  _selectedNotes.clear();
                  _isSelectionMode = false;
                  _isMovingMode = false;
                  Navigator.pop(context);

                  getNotes();
                },
              ),
              RaisedButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Widget _getPics(List<File> images) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images.map((f) {
        return Image.file(f);
      }).toList(),
    );
  }
}
