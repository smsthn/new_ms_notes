


import 'dart:io';
import 'package:image/image.dart';
import 'package:new_new_msnotes/Data/Entities/Note.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:image_picker_modern/image_picker_modern.dart';

import 'package:camera/camera.dart';

class SaveImageHelper{
  File _image;
  final int width;
  Note _note;
  int _noteId;
  String _name;
  SaveImageHelper(this.width,bool fromCamera,[Note note]){
    this._note = note;
    this._name = note.id.toString()+"___"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
    if(fromCamera)_getImageFromCamera();
    else _getImage();
  }
  SaveImageHelper.fromFile(File file,this.width,int noteId){
    _image = file;
    _noteId = noteId;
    this._name = noteId.toString()+"___"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
    _saveImage();
  }
  static Future onlySave()async{

  }
  Future _getImageFromCamera({int trynm})async{
    // List<CameraDescription> cameras;
    // cameras = await availableCameras();
    // CameraController controller = CameraController(cameras[0], ResolutionPreset.medium);
    // await controller.initialize();
    // String path =await _getpath();
    // controller.takePicture(join(path,_note.id.toString()+"___"+ DateTime.now().toString()+".jpg")).then((s){
    //   controller.dispose();
    //   _image = File(join(path,new DateTime.now().microsecondsSinceEpoch.toString()+".jpg"));
    //   if(_image != null &&_image.existsSync())_saveImage(takenPhoto: true);      
    //   });
     if(trynm != null && trynm == 4)return;
    var image ; try {
     image = await ImagePicker.pickImage(source: ImageSource.camera);
    } catch (e) {
      sleep(Duration(milliseconds: 200));
      _getImageFromCamera(trynm: trynm == null?1:trynm + 1);
      return;
    }
    if(image == null || !image.existsSync()){
      print("NO IMAGE WAS FOUND");
      return;
    }
    _image = image;
    _saveImage(takenPhoto: true);
    
  }
  Future _getImage({int trynm}) async {
    if(trynm != null && trynm == 4)return;
    var image ; try {
     image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      sleep(Duration(milliseconds: 200));
      _getImage(trynm: trynm == null?1:trynm + 1);
      return;
    }
    if(image == null || !image.existsSync()){
      print("NO IMAGE WAS FOUND");
      return;
    }
    _image = image;
    _saveImage();
  }
  Future<String> _getpath()async{
    final res = await getApplicationDocumentsDirectory();
    return res.path;
  }
  Future<File> _getFile()async{
    var path = await _getpath();
    return File('$path${Platform.pathSeparator}$_name');
  }
  
  Future _saveImage({bool takenPhoto = false})async{
    final path = await _getpath();
    String imgname = _image.path;
    imgname = imgname.substring(imgname.lastIndexOf(Platform.pathSeparator));
    File file;
    file = await _getFile(); 
    Image i1 = decodeImage(_image.readAsBytesSync());
    Image img = i1.width>this.width - 10? copyResize(i1,width: this.width -11):i1;
    file.writeAsBytesSync(encodeJpg(img));
  }
  
 
}

class ImageHelper{
 static Future<bool> hasImages()async{
    final res = await getApplicationDocumentsDirectory();
     return res.listSync().any((f)=>f.path.contains(".jpg") && f.path.contains("___"));

    // if(res.listSync().any((f)=>File(f.path).existsSync()&& f.path.substring(f.path.lastIndexOf(Platform.pathSeparator)).contains(_note.id)));
  }
  static SaveImageHelper getSaveImageHelper(Note note,int width,{bool isCamera = false})=>SaveImageHelper(width,isCamera,note);


  static Future<bool> checkNoteHasImages(Note note)async{
    final res = await getApplicationDocumentsDirectory();
     return res.listSync().any((f)=>f.path.substring(f.path.lastIndexOf(Platform.pathSeparator),f.path.lastIndexOf("___")).contains(note.id.toString()));
  }
  static Future<List<File>> getNotePhotos(Note note)async{
     final res = await getApplicationDocumentsDirectory();
     var elems = res.listSync();
     
     if(elems.isNotEmpty)
     return res.listSync().where((f)=>f is File && getOnlyId(f).trim() == note.id.toString()).map((f)=>f as File).toList();
     else return [];
   }
   static String getOnlyId(File f){
     var str = basename(f.path);
     var ind = str.indexOf("___");
     if(ind == -1 || !str.contains(".jpg"))return  "";
     return str.substring(0,ind == -1?str.length : ind);
   }
   static Future fixImageAdded(int noteId)async{
     final res = await getApplicationDocumentsDirectory();
     var ls = await getNotePhotos(Note(id:0));
     if(ls != null && ls.length != 0){
       ls.forEach((f) async=>await _renameFile(f, noteId));
       sleep(Duration(microseconds: 5));
     }
   }
   static Future _renameFile(File f,int noteId) async {
     final res = await getApplicationDocumentsDirectory();
     final path = "${res.path}${Platform.pathSeparator}"+basename(f.path).replaceFirst("0", noteId.toString());
     try{
       
       await f.rename(path);
     } catch(e){
      final newFile = File(path);
      newFile.createSync();
      newFile.writeAsBytesSync(f.readAsBytesSync());
      await f.delete();
      return;
     }
   }
   static Future deleteNotesImages(Note note)async{
     final res = await getApplicationDocumentsDirectory();
     var img = await getNotePhotos(note);
     img.forEach((i)async=>await i.delete());
   }
   static Future deleteWhereNotIds(List<int> ids)async{
     final res = await getApplicationDocumentsDirectory();
     final fls = res.listSync();
     fls.forEach((f)async{if(f is File){var id = getOnlyId(f);if(id != null && id != "" && (id == "0" || !ids.contains(id))){await f.delete();}}});
   }
   
}

class AddImageHandler{
  List<File> _diskImages;
  List<File> images;
  final int width;
  String _name;
  AddImageHandler(this.width){
    _diskImages = List();
  }
  Future<List<File>> fillImages(int noteId,{int resizeWidth})async{
    
    var fls = await ImageHelper.getNotePhotos(Note(id: noteId));
    if (images == null)images = List();if(fls != null){images.addAll(fls);_diskImages.addAll(fls);}
    return resizeWidth != null ? await getResizedImages(resizeWidth): images;
  }
  Future<File> addImage({bool camera = false})async{
    var imgAsFile = await ImagePicker.pickImage(source: camera?ImageSource.camera:ImageSource.gallery,maxWidth: width.toDouble());
    if(imgAsFile == null)return null;
    images.add(imgAsFile);
    return imgAsFile;
  }
  Future  removeImage({int index,File file}) async{
    if(index == null){
      if(file == null)return;
      else index = images.indexOf(file);
    }
    if(index <0 || index >=images.length)return;
    images.removeAt(index);
    if(_diskImages.contains(file)){
      _diskImages.remove(file);
      await file.delete();
    }
  }
  Future saveImages(int noteId)async{
    for(File image in images){
      if(!_diskImages.contains(image))SaveImageHelper.fromFile(image, width,noteId);
    }
  }
  Future<List<File>> getImages({int noteId,int resizeWidth})async{
    if(images == null && (noteId != null && noteId != 0)){
      images = List();
      images = await fillImages(noteId,resizeWidth: resizeWidth);
    } else if (images == null){
      images = List();
    }
      return resizeWidth == null ? images : getResizedImages(resizeWidth);
  }
  Future<List<File>> getResizedImages(int width)async{
    var temp = await getTemporaryDirectory();
    
    return images.map((i)=>File(join(temp.path,basename(i.path)))..writeAsBytesSync(encodeJpg(copyResize(decodeImage(i.readAsBytesSync()), width: ((width/10)-1).toInt())))).toList();
  }
  

}