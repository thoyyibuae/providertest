


import 'package:firebase_user_login/app_home/home.dart';
import 'package:firebase_user_login/screensetprovider/screensetprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loginScreen/login.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    //Provider to set the main.dart
    return MultiProvider( providers: [
      ChangeNotifierProvider<ScreenSetProvider>(
        create: (_) => ScreenSetProvider(),
      ),//using screen exit

    ],

      child: AppWithTheme(),

    );
  }
}

class AppWithTheme extends StatelessWidget {
  // const AppWithTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/logout": (_) => new LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),


    );
  }
}
