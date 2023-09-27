import 'dart:io';
import 'dart:math';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:student/view.dart';

void main()
{
  runApp(MaterialApp(debugShowCheckedModeBanner: false,home: Home(),));
}
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
static  Database ?database;
  static Directory?dir;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ImagePicker picker = ImagePicker();
  XFile? image;
  TextEditingController name=TextEditingController();
  TextEditingController contact=TextEditingController();
  TextEditingController email=TextEditingController();
  bool image_is=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      get_sql();
      permission();
  }
  String states = "surat";

  get_sql()
  async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'parth.db');
    Home.database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE student (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,contact TEXT,email TEXT,states TEXT,image TEXT)');
        });
  }
  permission()
  async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
      print(statuses[Permission.location]);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"),),
      body: SingleChildScrollView(
        child: Column(children: [
          Card(child: TextField(controller: name,)),
          Card(child: TextField(controller: contact,)),
          Card(child: TextField(controller: email,)),
          Text(
            "Select city",
            style: TextStyle(fontSize: 20),
          ),
          DropdownButton(icon: Icon(Icons.arrow_circle_down),value: states,
            items: [
              DropdownMenuItem(child: Text("surat"), value: "surat",),
              DropdownMenuItem(child: Text("vadodara"),value: "vadodara",),
              DropdownMenuItem(child: Text("rajkot"), value: "rajkot",),
              DropdownMenuItem(child: Text("amreli"),value: "amreli",),
              DropdownMenuItem(child: Text("bhavanagar"), value: "bhavangar",),
              DropdownMenuItem(child: Text("bharuch"),value: "bharuch",),
              DropdownMenuItem(child: Text("navsari"), value: "navsari",),
              DropdownMenuItem(child: Text("valsad"),value: "valsad",),
            ], onChanged: (value) {
              setState(() {
                states=value.toString();
              });
            },),
          ElevatedButton(onPressed: () {
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: Text("Add your image"),
                actions: [
                  Row(
                    children: [
                      TextButton(onPressed: () async {

                        image = await picker.pickImage(source: ImageSource.camera);
                        image_is = true;
                        setState(() {

                        });
                      }, child: Text("camera")),
                      TextButton(onPressed: () async {

                        image = await picker.pickImage(source: ImageSource.gallery);
                        image_is = true;
                        setState(() {

                        });

                      }, child: Text("gallery")),

                    ],
                  )
                ],
              );
            },);
          },
              child: Text("image")),
          Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.all(20),
            child: (image_is)?Image.file(fit: BoxFit.fill,File(image!.path)):null,

          ),
          ElevatedButton(onPressed: () async {
            String name1=name.text;
            String contact1=contact.text;
            String email1=email.text;
            String states1=states;
            var path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS)+"/parth";
            print(path);

            Home.dir = Directory(path);

            if(!await Home.dir!.exists())
            {
            Home.dir!.create();
            }

            int r =Random().nextInt(1000);
            String img_name = "${r}.jpg";
            File f = File("${Home.dir!.path}/${img_name}");
            f.writeAsBytes(await image!.readAsBytes());
            String sql="insert into student values(null,'$name1','$contact1','$email1','$states1','$img_name')";
            Home.database!.rawInsert(sql);
          }, child: Text("submit")),
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return view();
            },));
          }, child: Text("view"))
        ],),
      ),
    );
  }
}
