import 'dart:ffi';

import 'package:firebase_course_weal/BusinessLogic/icrease_number_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Increment extends StatefulWidget {
  const Increment({super.key});

  @override
  State<Increment> createState() => _IncrementState();
}

class _IncrementState extends State<Increment> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<IcreaseNumberCubit>().icreaseNumber();
    // context.read<IcreaseNumberCubit>().decrementNumber();
  }

  int value = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IcreaseNumberCubit, IcreaseNumberState>(
        builder: (context, state) {
      int value = 0;
      if (state is icreaseNumberCounterState) {
        value = state.x;
      } else if (state is decrementNumberState) {
        value = state.d;
      } else if (state is resetCounterState) {
        value = state.v;
      }
      return Scaffold(
          drawer: Drawer(
              child: Container(
            margin: EdgeInsets.all(16),
            child: ListView(
                shrinkWrap: true,
                // scrollDirection: Axis.vertical,
                children: [
                  Row(children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.fill,
                        )),
                    Expanded(
                      child: ListTile(
                        title: const Text(
                          "Flutter Cubit",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: const Text(
                          "remember cubit",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w400),
                        ),
                      ),
                    )
                  ]),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  ListTile(
                    title: Text("Home"),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text("Business"),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text("school"),
                    onTap: () {},
                  ),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                          child: TextButton(
                              onPressed: () {}, child: Text("Logout"))),
                    ),
                  )
                ]),
          )),
          appBar: AppBar(
            title: const Text(
              "Flutter Cubit",
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  context.read<IcreaseNumberCubit>().icreaseNumber();
                },
                child: const Icon(Icons.add),
              ),
             const SizedBox(height: 5),
              FloatingActionButton(
                onPressed: () {
                  context.read<IcreaseNumberCubit>().resetCounter();
                },
                child: const Icon(Icons.exposure_zero),
              ),
              const SizedBox(height: 5),
              FloatingActionButton(
                onPressed: () {
                  context.read<IcreaseNumberCubit>().decrementNumber();
                },
                child: const Icon(Icons.remove),
              ),
            ],
          ),
          body: Container(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Center(
                    child: Text(
                  "${value}",
                  style: TextStyle(fontSize: 50),
                ))
              ],
            ),
          ));
    });
  }
}
