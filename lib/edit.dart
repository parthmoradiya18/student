import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student/main.dart';
import 'package:student/view.dart';

class edit_data extends StatefulWidget {
  int id;
  String name;
  String contact;
  String email;
  String states1;
  edit_data(this.id,this.name,this.contact,this.email,this.states1);

  @override
  State<edit_data> createState() => _edit_dataState();
}

class _edit_dataState extends State<edit_data> {

  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3=TextEditingController();

  ImagePicker picker = ImagePicker();
  XFile? image;
  bool t = false;
  String states = "surat";

  @override
  void initState() {
    // TODO: implement initState
    t1.text = widget.name;
    t2.text = widget.contact;
    t3.text =widget.email;
    states=widget.states1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("add data", style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: TextField(
                  controller: t1,
                  decoration: const InputDecoration(
                      labelText: "Enter Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: TextField(
                  controller: t2,
                  decoration: const InputDecoration(
                      labelText: "Enter Contact",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: TextField(
                  controller: t3,
                  decoration: const InputDecoration(
                      labelText: "Enter Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: Text("choose your image"),
                    actions: [
                      Row(
                        children: [
                          TextButton(onPressed: () async {
                            Navigator.pop(context);
                            image = await picker.pickImage(source: ImageSource.gallery);
                            t = true;
                            setState(() {

                            });

                          }, child: Text("gallery")),
                          TextButton(onPressed: () async {
                            Navigator.pop(context);
                            image = await picker.pickImage(source: ImageSource.camera);
                            t = true;
                            setState(() {

                            });
                          }, child: Text("camera")),
                        ],
                      )
                    ],
                  );
                },);
              },
                  child: Text("choose your image")),
              Container(
                height: 100,
                width: 100,
                child: (t)
                    ? Image.file(File(image!.path))
                    : Icon(Icons.account_circle_rounded),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () async{
                        String name = t1.text;
                        String contact = t2.text;
                        String email=t3.text;
                        String states1 =states;
                        int r =Random().nextInt(100000);
                        String img_name = "${r}.jpg";
                        File f = File("${Home.dir!.path}/${img_name}");
                        f.writeAsBytes(await image!.readAsBytes());
                        String sql = "update student set name = '$name',contact = '$contact',email = '$email',states = '$states1',image = '$img_name' where id = '${widget.id}'";
                        Home.database!.rawUpdate(sql);
                        print(sql);
                        setState(() {});
                      }, style: const ButtonStyle(shape: MaterialStatePropertyAll(StadiumBorder(side: BorderSide(color: Colors.orange, width: 3, style: BorderStyle.solid))), backgroundColor: MaterialStatePropertyAll(Colors.black)),
                      child: const Text("update")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return view();
                        },));
                      },

                      child: Text("view")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}