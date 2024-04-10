import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course_weal/presentation/Screens/home.dart';
import 'package:firebase_course_weal/presentation/Screens/note/addNote.dart';
import 'package:firebase_course_weal/presentation/Screens/note/update.dart';
import 'package:firebase_course_weal/presentation/Screens/update.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NoteView extends StatefulWidget {
  final String NotdocId;
  NoteView({super.key, required this.NotdocId});
  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  List<QueryDocumentSnapshot> data = [];
  Future<void> getData() async {
    QuerySnapshot querySnapsho = await FirebaseFirestore.instance
        .collection("collection")
        .doc(widget.NotdocId)
        .collection("note")
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
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return AddNoteCategory(
                docId: widget.NotdocId,
              );
            },
          ));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Note page"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, "login", (route) => false);
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: GridView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return InkWell(
              onLongPress: () {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: 'del document',
                    desc:
                        'if you want to delete this document click on ok else cancel.',
                    btnCancelText: "update document",
                    btnOkText: "delete document",
                    btnCancelOnPress: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return UpDateNoteCategory(
                            NoteDocId: data[index].id,
                            docId: widget.NotdocId,
                            lastName: data[index]["note"],
                          );
                        },
                      ));
                    },
                    btnOkOnPress: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection("collection")
                            .doc(widget.NotdocId)
                            .collection("note")
                            .doc(data[index].id)
                            .delete();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return Home();
                        }));
                      } catch (e) {
                        print("Failed to delete note : " + e.toString());
                      }
                    }).show();
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
                      "${data[index]["note"]}",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
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
