import 'package:to_do_app/Helper.dart';
import 'package:to_do_app/todo.dart';

class TodoDao{
  Future<List<ToDo>> tumNesneler() async{
    var db = await Helper.veritabaniErisim();

    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * from todo ORDER BY id DESC");
    return List.generate(maps.length, (i){
      var satir = maps[i];
      print("veriler gönderildi");
      return ToDo(id: satir["id"], todoText: satir["todoText"], isDone: satir["isDone"]);
      return ToDo(id: satir["id"],todoText: satir["todoText"],isDone: satir["isDone"]);
    });
  }
  Future<void> nesneEkle(String todoText,int isDone) async{
    var db = await Helper.veritabaniErisim();
    var bilgiler = Map<String,dynamic>();
    bilgiler["todoText"] = todoText;
    bilgiler["isDone"] = isDone;
    await db.insert("todo", bilgiler);
  }
  Future<void> nesneSil(int id) async{
    var db = await Helper.veritabaniErisim();
    await db.delete("todo",where: "id = ?",whereArgs: [id]);
  }
  Future<List<ToDo>> nesneArama(String aramakelimesi) async {
    var db = await Helper.veritabaniErisim();
    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM todo WHERE todoText like '%$aramakelimesi%'");
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return ToDo(id: satir["id"], todoText: satir["todoText"],isDone: satir["isDone"]);
    });
  }
  Future<void> nesneGuncelle(int id,int isDone,String todoText)async{
    var db = await Helper.veritabaniErisim();
    var bilgiler = Map<String,dynamic>();
    bilgiler["id"] = id;
    bilgiler["todoText"] = todoText;
    bilgiler["isDone"] = isDone;
    await db.update("todo",bilgiler,where: "id = ?",whereArgs: [id]);
  }
}