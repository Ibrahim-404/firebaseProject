import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePic extends StatefulWidget {
  ImagePic({super.key});

  @override
  State<ImagePic> createState() => _ImagePicState();
}

class _ImagePicState extends State<ImagePic> {
  File? file;
  String? url;

  getData() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    // final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    file = File(image!.path);
    if (file != null) {
      var pictureName = basename(image.path);
      var refStorage = FirebaseStorage.instance.ref(pictureName);
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
      print(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
      ),
      body: Container(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () async {
                await getData();
              },
              child: const Text("Pick Image"),
            ),
            if (url != null) Image.network(url!)
          ],
        ),
      ),
    );
  }
}
