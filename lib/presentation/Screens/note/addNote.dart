import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course_weal/presentation/Screens/home.dart';
import 'package:firebase_course_weal/presentation/Screens/note/view.dart';
import 'package:flutter/material.dart';

class AddNoteCategory extends StatelessWidget {
  AddNoteCategory({super.key, required this.docId});
  String docId;
  TextEditingController NoteFeild = TextEditingController();
  GlobalKey<FormState> fromState = GlobalKey<FormState>();
  Future<void> addNote() async {
    CollectionReference note = FirebaseFirestore.instance
        .collection('collection')
        .doc(this.docId)
        .collection("note");
    try {
        DocumentReference response = await note.add({
          'note': NoteFeild.text,
        });
        print("Added successfully");

    } catch (e) {
      print("Failed to add note: ${e.toString()}");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // super.dispose();
    NoteFeild.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add your Note"),
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
                      return "please enter your note";
                    }
                  },
                  controller: NoteFeild,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: "enter note ",
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
                        addNote();
                        Navigator.pushReplacement(context,MaterialPageRoute(builder:(context){
                          return Home();
                        }));
                      }
                    },
                    child: Text("Add note")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
