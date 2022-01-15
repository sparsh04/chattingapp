import 'package:chattingapp/helperfunctions/authenticate.dart';
import 'package:chattingapp/services/auth.dart';
import 'package:chattingapp/views/home.dart';
import 'package:chattingapp/views/signin.dart';
import 'package:chattingapp/views/tabs_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool showIgnIn = true;

  // void toggleView() {
  //   setState(() {
  //     showIgnIn = !showIgnIn;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: AuthMedthods().getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            if (snapshot.hasData) {
              return const TabsScreen();
            } else {
              return const Authenticate();
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
