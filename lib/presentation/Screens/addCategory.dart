import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatelessWidget {
  AddCategory({super.key});
  TextEditingController addController = TextEditingController();
  CollectionReference collection =
      FirebaseFirestore.instance.collection('collection');
  GlobalKey<FormState> fromState = GlobalKey<FormState>();

  Future<void> addCategory() async {
    try {
      DocumentReference response =
          await collection.add({'name': addController.text, 'id':FirebaseAuth.instance.currentUser!.uid});
      print("Added successfully");
    } catch (e) {
      print("Failed to add category: ${e.toString()}");
    }
  }
  @override
  void dispose(){
    // TODO: implement dispose
    // super.dispose();
    addController.dispose();
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
                  controller: addController,
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
                        addCategory();
                        // addUser();
                        Navigator.pushReplacementNamed(context, "homePage");
                      }
                    },
                    child: Text("Add Category")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
