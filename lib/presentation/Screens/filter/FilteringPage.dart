import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
class FilteringPage extends StatefulWidget {
  const FilteringPage({super.key});

  @override
  State<FilteringPage> createState() => _FilteringPageState();
}

class _FilteringPageState extends State<FilteringPage> {
  String userName = "not found";
  String phone = "not found";
  int ageDefault = 23;
  List<QueryDocumentSnapshot> data = [];
  Future<void> getdates() async {
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    QuerySnapshot usreData = await users.get();
    data.addAll(usreData.docs);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdates(); // call getdates
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DocumentReference ahmed =
              FirebaseFirestore.instance.collection("users").doc("1");
          DocumentReference Mahmoud =
              FirebaseFirestore.instance.collection("users").doc("2");
          WriteBatch batch = FirebaseFirestore.instance.batch();
          batch.set(ahmed, {
            "userName": "Ahmed",
            "phone": "123456789",
            "age": 19,
            "money": 600,
          });

          batch.commit();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const FilteringPage();
          }));
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                    child: Text(
                  "Error....😅",
                  style: TextStyle(fontSize: 30),
                ));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              var streamData = snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                        onTap: () {
                          DocumentReference moneyTransaction = FirebaseFirestore
                              .instance
                              .collection("users")
                              .doc(data[index].id);
                          //step 2: run function transaction in fireStore
                          FirebaseFirestore.instance
                              .runTransaction((transaction) async {
                            DocumentSnapshot snapshot =
                                await transaction.get(moneyTransaction);
                            if (snapshot.exists) {
                              var snapshotData = snapshot.data();
                              if (snapshotData is Map<String, dynamic>) {
                                int money = snapshotData["money"] + 100;
                                transaction
                                    .update(moneyTransaction, {"money": money});
                              }
                            }
                          });
                          // .then((value) => Navigator.pushReplacement(context,
                          //             MaterialPageRoute(builder: (context) {
                          //           return const FilteringPage();
                          //         })));
                        },
                        title: Text(
                            "${streamData[index]["userName"] ?? userName}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.black)),
                        subtitle: Text(
                            "age:${streamData[index]["age"] ?? ageDefault}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            )),
                        trailing: Text("${streamData[index]["money"]}\$",
                            style: const TextStyle(fontSize: 20))),
                  );
                },
              );
            }),
      ),
    );
  }
}
