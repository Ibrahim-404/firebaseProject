import 'package:flutter/material.dart';

class CustomTextFormField  extends StatelessWidget {
 final String HintText;
 final TextEditingController controller;
 final String? Function(String?) validator;
   CustomTextFormField ({super.key, required this.HintText, required this.controller, required this.validator});
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
    validator:this.validator,
      controller:this.controller ,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        hintText: this.HintText,
        hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.grey)),
      ),
    );
  }
}
