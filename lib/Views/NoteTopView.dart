/*
import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:ms_notes/CustomViews/Btns/ExpandableFab.dart';
import 'package:ms_notes/CustomViews/Btns/ExpandableFabs2.dart';
import 'package:ms_notes/CustomViews/Collections/NotesGridView.dart';
import 'package:ms_notes/Data/Entities/Note.dart';
import 'package:ms_notes/Data/NotesRepository.dart';
import 'package:ms_notes/Helpers/ColorHelper.dart';

class NoteTopView extends StatefulWidget {
  final Note note;
  Function _refresh;

  NoteTopView({this.note, Function refresh}) {
    this._refresh = refresh ?? () {};
  }

  @override
  State<StatefulWidget> createState() =>
      NoteTopViewState(note: note, refresh: _refresh);
}

class NoteTopViewState extends State<NoteTopView> {
  Note note;
  Function _refresh;
  List<String> checkList;
  List<bool> checkListBools;
  static BannerAd bannerAd;

  NoteTopViewState({this.note, Function refresh}) {
    this._refresh = refresh ?? () {};
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: BannerAd.testAdUnitId);
    bannerAd =
        BannerAd(adUnitId: BannerAd.testAdUnitId, size: AdSize.smartBanner);
    bannerAd
      ..load()
      ..show(anchorType: AnchorType.top);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            getTransparentColor(note == null ? 0 : note.colorIndex),
        body: Column(
          children: <Widget>[
            Container(
              height: 60,
            ),
            Expanded(
              child: WillPopScope(
                  child: note == null
                      ? Stack(
                          children: <Widget>[
                            NotesGridView(
                              rootNote: note,
                            ),
                            Align(
                              child: ExpandableFab(
                                note: note,
                                refreshPage: (n) {
                                  note = n;
                                  _getCheckList();
                                  setState(() {});
                                },
                              ),
                              alignment: AlignmentDirectional.bottomEnd,
                            ),
                            Align(
                              child: ExpandableFab2(
                                note: note,
                                refreshPage: (n) {
                                  note = n;
                                  _getCheckList();
                                  setState(() {});
                                },
                              ),
                              alignment: AlignmentDirectional.bottomStart,
                            ),
                          ],
                        ) */
/*, onWillPop: _refresh)*//*

                      : NestedScrollView(
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[
                              SliverAppBar(
                                backgroundColor: getDarkColor(
                                    note == null ? 0 : note.colorIndex),
                                centerTitle: true,
                                title: Hero(
                                    tag: "${note.id}_title",
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        note.name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    )),
                                pinned: true,
                              ),
                              SliverToBoxAdapter(
                                  child: note.type != NoteType.Folder
                                      ? Container(
                                          color: note.colorIndex != 16
                                              ? getPrimColor(note == null
                                                  ? 0
                                                  : note.colorIndex)
                                              : getLightColor(16),
                                          child: Hero(
                                            tag: "${note.id}_content",
                                            child: Material(
                                                color: Colors.transparent,
                                                child: note.type ==
                                                        NoteType.CheckList
                                                    ? Wrap(
                                                        direction:
                                                            Axis.horizontal,
                                                        children:
                                                            _getCheckables(
                                                                note.content),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          note.content,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: getTextColor(
                                                                  note.colorIndex)),
                                                        ),
                                                      )),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        )),
                            ];
                          },
                          body: Stack(
                            children: <Widget>[
                              _getGrid(note),
                              Align(
                                child: ExpandableFab(
                                    note: note,
                                    isRoot: false,
                                    refreshPage: (n) {
                                      note = n;
                                      _getCheckList();
                                      setState(() {});
                                    }),
                                alignment: AlignmentDirectional.bottomEnd,
                              ),
                              Align(
                                child: ExpandableFab2(
                                  note: note,
                                  refreshPage: (n) {
                                    note = n;
                                    _getCheckList();
                                    setState(() {});
                                  },
                                ),
                                alignment: AlignmentDirectional.bottomStart,
                              ),
                            ],
                          )),
                  onWillPop: note == null || note.id == 0
                      ? () async {
                          return true;
                        }
                      : () {
                          Navigator.of(context).pop(true);
                        }),
            )
          ],
        ));
  }

  Widget _getGrid(Note note) {
    return NotesGridView(
      rootNote: note,
    );
  }

  void _getCheckList() {
    if (note != null && note.type == NoteType.CheckList) {
      checkList = List();
      checkListBools = List();
      if (note != null &&
          note.type == NoteType.CheckList &&
          note.content != null) {
        checkList.clear();
        var ctn = note.content.split("\n");
        ctn.removeWhere((s) => s.trim() == "");
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
  }

  List<Widget> _getCheckables(String content) {
    _getCheckList();
    List<Widget> wdg = List.generate(checkList.length, (i) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Checkbox(
              activeColor: getTextColor(note?.colorIndex ?? 0),
              onChanged: (b) {
                changeCheck(i, b);
              },
              value: checkListBools[i],
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              checkList[i],
              style: TextStyle(
                  color: getTextColor(note.colorIndex),
                  decoration: checkListBools[i]
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
          ),
        ],
      );
    });
    return wdg;
  }

  void changeCheck(int index, bool value) {
    checkListBools[index] = value;
    setState(() {});
    var str = StringBuffer('');
    for (int i = 0; i < checkList.length; i++) {
      str.write(checkListBools[i] ? '1' : '0');
      str.write(checkList[i]);
      str.write('\n');
    }
    note.content = str.toString();
    NotesRepository().updateNote(note);
  }
}
*/
