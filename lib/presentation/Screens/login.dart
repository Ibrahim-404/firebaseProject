import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course_weal/presentation/Components/CustomTextFormField.dart';
import 'package:firebase_course_weal/presentation/Components/logo_custom.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("homePage", (route) => false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    PasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ListView(
          children: [
            Form(
              key: formKey,
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
                  Text("Email",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  CustomTextFormField(
                      HintText: "Enter your Email",
                      controller: emailController,
                      validator: (value) {
                        if (value == "" || value == null || value.isEmpty) {
                          return "should be not empty";
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
                        if (value == "" || value == null || value.isEmpty) {
                          return "should be not empty";
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
                        onTap: () async {
                          if (emailController.text.isEmpty) {
                            return;
                          } else {
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                      email: emailController.text);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                title: 'check your email',
                                desc: 'please check your email.',
                              ).show();
                            } catch (e) {
                              print("e.message: " + e.toString());
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'email error',
                                desc: 'please check your email.',
                              ).show();
                            }
                          }
                        }),
                  ),
                ],
              ),
            ),
            MaterialButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: PasswordController.text);
                    if (credential.user!.emailVerified) {
                      Navigator.pushReplacementNamed(context, "homePage");
                    } else {
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Email verification',
                        desc: 'Please verify your email.',
                      ).show();
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'user-not-found',
                        desc: 'No user found for that email.',
                      ).show();
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'wrong-password',
                        desc: 'Wrong password provided for that user.',
                      ).show();
                    } else {
                      print(e.code);
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Invalid Credential',
                        desc:
                            'Invalid email or password. Please check your credentials and try again.',
                      ).show();
                    }
                  }
                }
              },
              child: Text("Login", style: TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              color: Colors.orangeAccent,
            ),
            SizedBox(height: 8),
            MaterialButton(
              onPressed: () {
                signInWithGoogle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login with Google ",
                    style: TextStyle(color: Colors.white),
                  ),
                  Image.asset(
                    "assets/images/4.png",
                    height: 20,
                    width: 20,
                  )
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              color: Colors.redAccent,
            ),
            SizedBox(height: 8),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, "register");
              },
              child: Center(
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    TextSpan(
                      text: "Register",
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
