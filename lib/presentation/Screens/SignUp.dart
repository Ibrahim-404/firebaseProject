import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course_weal/presentation/Components/CustomTextFormField.dart';
import 'package:firebase_course_weal/presentation/Components/logo_custom.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  GlobalKey<FormState> fromkey = GlobalKey<FormState>();
  SignUp({super.key});
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    PasswordController.dispose();
    userNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ListView(
          children: [
            Form(
              key: fromkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                  ),
                  LogoCustom(),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Login to containue using the app",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                        color: Colors.grey[600]),
                  ),
                  Container(
                    height: 23,
                  ),
                  Text("user name",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  CustomTextFormField(
                      HintText: "Enter your user name",
                      controller: userNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please enter your user name";
                        }
                      }),
                  Container(
                    height: 23,
                  ),
                  Text("Email",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  CustomTextFormField(
                      HintText: "Enter your Email",
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please enter your email";
                        }
                      }),
                  Text("Password",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  CustomTextFormField(
                      HintText: "Enter your password",
                      controller: PasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please enter your password";
                        }
                      }),
                  SizedBox(height: 8),
                  Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        child: Text(
                          "Forgot Password?",
                          style:
                              TextStyle(fontSize: 16, color: Colors.deepOrange),
                        ),
                        onTap: () {}),
                  ),
                ],
              ),
            ),
            MaterialButton(
              onPressed: () async {
                if (fromkey.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: PasswordController.text,
                    );
                    print("Validation succeeded. go to home page");
                    Navigator.pushReplacementNamed(context, "login");
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    print(e);
                  }
                } else {
                  print("Validation failed. Please check your form.");
                }
              },
              child: Text("SingUp", style: TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              color: Colors.orangeAccent,
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, "login");
              },
              child: Center(
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: "Have an account? ",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    TextSpan(
                      text: "Login",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    )
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
