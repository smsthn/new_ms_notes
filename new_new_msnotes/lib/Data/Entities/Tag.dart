



class Tag{
  int id;
  String name;

  Tag({this.id = 0,this.name = ""});

  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "name":name
    };
  }
  Tag.fromMap(Map<String,dynamic> map):this(id:map["id"],name:map["name"]);

  Tag fromMap(Map<String,dynamic> map){return new Tag(id:map["id"],name:map["name"]);}
}