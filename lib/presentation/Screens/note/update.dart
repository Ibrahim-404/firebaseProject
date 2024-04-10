import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course_weal/presentation/Screens/home.dart';
import 'package:flutter/material.dart';

class UpDateNoteCategory extends StatefulWidget {
  final String NoteDocId;
  final String docId;
  final String lastName;
  UpDateNoteCategory(
      {super.key,
      required this.NoteDocId,
      required this.lastName,
      required this.docId});
  @override
  State<UpDateNoteCategory> createState() => _UpDateNoteCategoryState();
}

class _UpDateNoteCategoryState extends State<UpDateNoteCategory> {
  TextEditingController updateController = TextEditingController();
  CollectionReference collection =
      FirebaseFirestore.instance.collection('collection');
  GlobalKey<FormState> fromState = GlobalKey<FormState>();

  // Future<void> addUser() {
  Future<void> updateCategory() async {
    try {
      await collection
          .doc(widget.docId).collection("note").doc(widget.NoteDocId)
          .update({"note": updateController.text});
      print("update successfully");
    } catch (e) {
      print("Failed to add category: ${e.toString()}");
    }
  }

  Future<void> UpdateWithSet() async {
    try {
      //Setoption merge : true likely update no change in fields but only field Between the brackets.
      //Setoption merge : false all fields change
      await collection
          .doc(widget.NoteDocId)
          .set({"name": updateController.text}, SetOptions(merge: true));
      print("update successfully");
    } catch (e) {
      print("Failed to add category: ${e.toString()}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateController.text = widget.lastName;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    updateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
      ),
      body: Container(
        child: Form(
          key: fromState,
          child: Column(
            children: [
              Container(
                height: 30,
              ),
              SizedBox(
                width: 350,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter Category name";
                    }
                  },
                  controller: updateController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: "enter Category name",
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      if (fromState.currentState!.validate()) {
                        updateCategory();
                        // addUser();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return Home();
                        }));
                      }
                    },
                    child: Text("update Category")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
