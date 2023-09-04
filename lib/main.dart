import 'package:flutter/material.dart';
import 'package:to_do_app/todo.dart';
import 'package:to_do_app/todoDao.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool sorgu=false;
  String kelime="";
  bool aramasorgu(String kelime){
    if(kelime.isEmpty){
      return false;
    }else{
      return true;
    }
  }
  String arama_kelimesi ="";

  Future<List<ToDo>> nesnelerigetir() async {
    var liste = await TodoDao().tumNesneler();
    return liste;
  }

  Future<void> ekle(String todoText) async {
    await TodoDao().nesneEkle(todoText, 0);
  }

  Future<void> sil(int id) async {
    await TodoDao().nesneSil(id);
  }

  Future<List<ToDo>> arama(String aranan) async {
    var liste = await TodoDao().nesneArama(aranan);
    return liste;
  }

  Future<void> guncelle(id,isDone,todoText) async{
    if(isDone==1)
      isDone=0;
    else
      isDone=1;
    await TodoDao().nesneGuncelle(id,isDone,todoText);
  }
  bool aramavarmi(String kelime){
    if(kelime.isEmpty){
      return false;
    }else
      return true;
  }




  bool todoDondur(ToDo todo) {
    if (todo.isDone == 1) {
      return true;
    } else {
      return false;
    }
  }

  final kontroltodo = TextEditingController();
  final kelimee = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade200,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Icon(
                Icons.menu,
                color: Colors.black,
                size: 30,
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  "To Do List",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Image.asset(
                "images/icon.png",
                width: 40,
                height: 40,
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: kelimee,
                        onChanged: (value) {
                          setState(() {
                            kelime=value;
                            sorgu=aramasorgu(kelime);

                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 20,
                            ),
                            prefixIconConstraints: BoxConstraints(
                              maxHeight: 20,
                              minWidth: 20,
                            ),
                            border: InputBorder.none,
                            hintText: " Search",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),

                  Expanded(
                    child: FutureBuilder<List<ToDo>>(

                      future: sorgu? arama(kelime):nesnelerigetir(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var todolist = snapshot.data;
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: todolist?.length,
                            itemBuilder: (context, indeks) {
                              var todo = todolist?[indeks];
                              return Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  onTap: () {
                                    setState(() {
                                      guncelle(todo.id, todo.isDone, todo.todoText);
                                    });

                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  tileColor: Colors.white,
                                  leading: Icon(
                                    todoDondur(todo!)
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: Colors.deepPurple,
                                  ),
                                  title: Text(
                                    todo.todoText,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      decoration: todoDondur(todo)
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  trailing: Container(
                                    padding: EdgeInsets.all(0),
                                    margin: EdgeInsets.symmetric(vertical: 12),
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          sil(todo.id);
                                          kelimee.clear();
                                          kelime="";
                                        });

                                      },
                                      icon: Icon(Icons.delete),
                                      iconSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Text("yok");
                        }
                      },
                    ),
                  )

                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      margin: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: kontroltodo,
                        decoration: InputDecoration(
                          hintText: "Add new to do item",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20, right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          ekle(kontroltodo.text);
                          kontroltodo.clear();
                        });

                      },
                      child: Text(
                        "+",
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        minimumSize: Size(60, 60),
                        elevation: 10,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
