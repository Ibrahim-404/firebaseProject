import 'package:flutter/material.dart';

class LogoCustom extends StatelessWidget {
  const LogoCustom({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 70,
        backgroundColor: Colors.grey[200],
        child: Image.asset(
          "assets/images/logo.png",
          width: 70,
          height: 70,
        ),
      ),
    );
  }
}
