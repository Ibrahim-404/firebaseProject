import 'package:firebase_course_weal/BusinessLogic/icrease_number_cubit.dart';
import 'package:firebase_course_weal/presentation/Screens/SignUp.dart';
import 'package:firebase_course_weal/presentation/Screens/addCategory.dart';
import 'package:firebase_course_weal/presentation/Screens/filter/FilteringPage.dart';
import 'package:firebase_course_weal/presentation/Screens/home.dart';
import 'package:firebase_course_weal/presentation/Screens/image%20picker/Image_picker.dart';
import 'package:firebase_course_weal/presentation/Screens/login.dart';
import 'package:firebase_course_weal/remember%20cubit/increment.dart';
// import 'package:firebase_course_weal/presentation/Screens/update.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:(context)=>IcreaseNumberCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.orangeAccent),
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              actionsIconTheme: IconThemeData(color: Colors.orangeAccent),
            )),
        home: Increment(),
        // (FirebaseAuth.instance.currentUser == null &&
        //         FirebaseAuth.instance.currentUser!.emailVerified)
        //     ? Login()
        //     : Home(),
        routes: {
          "register": (context) => SignUp(),
          "login": (context) => Login(),
          "homePage": (context) => Home(),
          "addCategory": (context) => AddCategory(),
          // "update": (context) =>UpDateCategory(),
        },
      ),
    );
  }
}
