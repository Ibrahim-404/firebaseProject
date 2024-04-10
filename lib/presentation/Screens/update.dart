import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpDateCategory extends StatefulWidget {
  final String DocId;
  final String lastName;
  UpDateCategory({super.key, required this.DocId, required this.lastName});

  @override
  State<UpDateCategory> createState() => _UpDateCategoryState();
}

class _UpDateCategoryState extends State<UpDateCategory> {
  TextEditingController updateController = TextEditingController();

  CollectionReference collection =
      FirebaseFirestore.instance.collection('collection');

  GlobalKey<FormState> fromState = GlobalKey<FormState>();

  // Future<void> addUser() {
  Future<void> updateCategory() async {
    try {
      await collection
          .doc(widget.DocId)
          .update({"name": updateController.text});
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
          .doc(widget.DocId)
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
                        Navigator.pushReplacementNamed(context, "homePage");
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
