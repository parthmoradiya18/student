import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student/edit.dart';
import 'package:student/main.dart';

class view extends StatefulWidget {
  const view({Key? key}) : super(key: key);

  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {

  List<Map> l = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    geta();
  }
  geta()
  async {
    String sql = "select * from student";
    l = await Home.database!.rawQuery(sql);
    print(l);
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("view"),),
      body: ListView.builder(itemCount: l.length,itemBuilder: (context, index) {
        String img_path="${Home.dir!.path}/${l[index]['image']}";
        File image=File(img_path);
        return Card(child: ListTile(
          leading: CircleAvatar(backgroundImage: FileImage(image),),
          title: Text("${l[index]['name']}"),
          subtitle: Text("${l[index]['contact']}\n${l[index]['email']}\n${l[index]['states']}"),
            trailing: Wrap(
              children: [
                IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return edit_data(l[index]['id'],l[index]['name'],l[index]['contact'],l[index]['email'],l[index]['states']);
                  },));
                }, icon: Icon(Icons.edit)),
                IconButton(onPressed: () {
                  String sql = "delete from student where id = ${l[index]['id']}";
                  Home.database!.rawDelete(sql);
                  setState(() {

                  });
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return view();
                  },));
                }, icon: Icon(Icons.delete)),
              ],
            )
        ),);
      },),
    );
  }
}
