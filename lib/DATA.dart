import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Contact.dart';

class DATA extends StatefulWidget {
  const DATA({super.key});

  @override
  State<DATA> createState() => _DATAState();
}

class _DATAState extends State<DATA> {
  List<Contact> contacts = List.empty(growable: true);
  final List<Contact> searchlist=[];
  bool issearching=false;
  int selectedIndex = -1;
  late SharedPreferences sp;

  getSharedPrefrences() async {
    sp = await SharedPreferences.getInstance();
    readFromSp();
  }

  saveIntoSp() {
    //
    List<String> contactListString =
    contacts.map((contact) => jsonEncode(contact.toJson())).toList();
    sp.setStringList('myData', contactListString);
    //
  }

  readFromSp() {
    //
    List<String>? contactListString = sp.getStringList('myData');
    if (contactListString != null) {
      contacts = contactListString
          .map((contact) => Contact.fromJson(jsonDecode(contact)))
          .toList();
    }
    setState(() {});
    //
  }

  @override
  void initState() {
    getSharedPrefrences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(

          centerTitle: true,
          title:issearching?TextField(decoration: InputDecoration(hintText:"Type Name,Email..",
            border: InputBorder.none,
          ),
            onChanged: (value) {
              searchlist.clear();
              for(var i in contacts){
                if(i.name.toLowerCase().contains(value.toLowerCase())||
                    i.name.toLowerCase().contains(value.toLowerCase())){
                  searchlist.add(i);
                }
                setState(() {
                  searchlist;
                });
              }
            },
          ):Text("add Stock",),
          actions: [
            IconButton(onPressed: (){
              setState(() {
                issearching=!issearching;
              });
            }, icon: Icon(issearching?CupertinoIcons.clear_circled_solid:Icons.search)),
          ]
      ),
      body:
      Column(
        children: [
          const SizedBox(height: 10),
          contacts.isEmpty
              ? const Text(
            'No Contact yet..',
            style: TextStyle(fontSize: 22),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) => getRow(index),
            ),
          )
        ],
      ),
    );
  }
  Widget getRow(int index) {
    return Container(
      height: 70,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
          index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
          foregroundColor: Colors.white,
          child: Text(
            contacts[index].name[0],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contacts[index].name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Size:${contacts[index].contact}"),
            Text("Stock:${contacts[index].size}"),
          ],
        ),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    //

                    setState(() {
                      selectedIndex = index;
                    });
                    //
                  },
                  child: const Icon(Icons.edit)),
              SizedBox(width: 10,),
              InkWell(
                  onTap: (() {
                    //
                    setState(() {
                      contacts.removeAt(index);
                    });
                    //
                  }),
                  child: const Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }
}
