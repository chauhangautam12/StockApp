
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/DATA.dart';


import 'Contact.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController SizeController = TextEditingController();
  TextEditingController contactController = TextEditingController();
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
      appBar: AppBar(

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  hintText: 'Brand Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contactController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: const InputDecoration(
                  hintText: 'Stock',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ))),
            ),
            TextField(
              controller: SizeController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: const InputDecoration(
                  hintText: 'Size',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ))),
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      String name = nameController.text.trim();
                      String size = SizeController.text.trim();
                      String contact = contactController.text.trim();
                      if (name.isNotEmpty && contact.isNotEmpty&&size.isNotEmpty) {
                        setState(() {
                          nameController.text = '';
                          SizeController.text = '';
                          contactController.text = '';
                          contacts.add(Contact(name: name, contact: contact,size: size));
                        });
                      }
                       saveIntoSp();
                    },
                    child: const Text('Save')),
                ElevatedButton(
                    onPressed: () {
                      //
                      String name = nameController.text.trim();
                      String size = SizeController.text.trim();
                      String contact = contactController.text.trim();
                      if (name.isNotEmpty && contact.isNotEmpty) {
                        setState(() {
                          nameController.text = '';
                          contactController.text = '';
                          SizeController.text = '';
                          contacts[selectedIndex].name = name;
                          contacts[selectedIndex].contact = contact;
                          contacts[selectedIndex].size = size;
                          selectedIndex = 0;
                        });
                      }
                      saveIntoSp();
                    },
                    child: const Text('Update')),
              ],
            ),
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
            Text("Stock:${contacts[index].contact}"),
            Text("Size:${contacts[index].size}"),
          ],
        ),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    //
                    nameController.text = contacts[index].name;
                    SizeController.text = contacts[index].size;
                    contactController.text = contacts[index].contact;
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