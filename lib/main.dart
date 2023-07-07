// ignore_for_file: must_call_super, non_constant_identifier_names, must_be_immutable, unused_local_variable, avoid_types_as_parameter_names, prefer_is_empty, prefer_const_constructors, use_key_in_widget_constructors

import 'dart:async';
import 'package:ecm_application/Screens/Login/Dashboard.dart';
import 'package:ecm_application/Screens/Login/LoginScreen.dart';
import 'package:ecm_application/Screens/Login/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await SharedPreferences.getInstance();
  runApp(MyApp());
}

late Widget? showFirstScreen;

class MyApp extends StatefulWidget {
  static String? usertype = '';
  static String? username = '';
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getInitialScreen().whenComplete(() => setState(() {
          isFirstLoad = false;
        }));
  }

  bool isFirstLoad = true;

  Future<void> getInitialScreen() async {
    String mobileno = '';
    var userType = '';
    var userName = '';
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      mobileno = preferences.getString('mobileno')!;
      userType = preferences.getString('usertype')!;
      userName = preferences.getString('firstname')!;
    } catch (Exception) {}

    showFirstScreen =
        mobileno.length > 0 ? ProjectsCategoryScreen() : LoginScreen();
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () async {
      String mobileno = '';
      var userType = '';
      var userName = '';
      try {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        mobileno = preferences.getString('mobileno')!;
        userType = preferences.getString('usertype')!;
        userName = preferences.getString('firstname')!;
        setState(() {
          MyApp.usertype = userType;
          MyApp.username = userName;
        });
      } catch (Exception) {}

      showFirstScreen =
          mobileno.length > 0 ? ProjectsCategoryScreen() : LoginScreen();
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // useMaterial3: true,
      ),
      title: 'ecm_application',
      home: isFirstLoad ? SplashScreen() : showFirstScreen,
    );
  }
}
