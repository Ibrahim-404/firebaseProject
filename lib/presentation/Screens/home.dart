import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course_weal/presentation/Screens/filter/FilteringPage.dart';
import 'package:firebase_course_weal/presentation/Screens/note/view.dart';
import 'package:firebase_course_weal/presentation/Screens/update.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<QueryDocumentSnapshot> data = [];
  Future<void> getData() async {
    QuerySnapshot querySnapsho = await FirebaseFirestore.instance
        .collection("collection")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapsho.docs);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "addCategory");
          },
          //    Icon(Icons.add),
          child: const Icon(Icons.add)),
      appBar: AppBar(
        title: const Text("Home page"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, "login", (route) => false);
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: GridView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            return InkWell(
              onLongPress: () {},
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return NoteView(NotdocId: data[index].id);
                }));
              },
              child: Card(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/pngimg.com - folder_PNG8772.png",
                      width: 100,
                      height: 100,
                    ),
                    Text(
                      "${data[index]["name"]}",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
