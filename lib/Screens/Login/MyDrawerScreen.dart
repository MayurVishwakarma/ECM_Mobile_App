// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, use_build_context_synchronously, use_key_in_widget_constructors, unused_import
// import 'package:ecm_application/Screens/Login/Attendance.dart';
import 'package:ecm_application/Screens/Login/Dashboard.dart';
import 'package:ecm_application/Screens/Login/LoginScreen.dart';
import 'package:ecm_application/Screens/Login/UserAttendance.dart';
import 'package:ecm_application/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawerScreen extends StatefulWidget {
  @override
  State<MyDrawerScreen> createState() => _MyDrawerScreenState();
}

class _MyDrawerScreenState extends State<MyDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: <Color>[Colors.blueGrey, Colors.blue])),
              child: Center(
                child: Column(
                  children: [
                    Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(150.0)),
                        child: Image.asset(
                          'assets/images/SeLogo.png',
                          height: 120,
                          width: 120,
                        )),
                    Text(
                      MyApp.username.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              )),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                child: Text("Erection, Commission & Maintenance",
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 3.0, 0.0, 0.0),
                child: Text(
                  'ECM Mobile Application',
                  textScaleFactor: 1,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 3.0, 0.0, 10.0),
                child: Text('App Version-v0.6',
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    )),
              ),
            ],
          ),
          //Process Monitoring

          ListTile(
            leading: ImageIcon(
              AssetImage("assets/images/home.png"),
            ),
            title: Text(
              'Home',
              textScaleFactor: 1,
            ),
            onTap: (() {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => ProjectsCategoryScreen()),
                (Route<dynamic> route) => false,
              );
            }),
          ),

          //System Monitoring
          if (MyApp.usertype != 'Engineer_Client' || MyApp.usertype != 'Cli') //
            ListTile(
              leading: ImageIcon(
                AssetImage("assets/images/attendance.png"),
                //  color: Color(0xFF3A5A98),
              ),
              title: Text(
                'Attendence',
                textScaleFactor: 1,
              ),
              onTap: (() {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AttendanceScreen()),
                  (Route<dynamic> route) => true,
                );
              }),
            ),

          //Change Password
          ListTile(
            leading: ImageIcon(
              AssetImage("assets/images/password.png"),
              //  color: Color(0xFF3A5A98),
            ),
            title: Text(
              'CHANGE PASSWORD',
              textScaleFactor: 1,
            ),
            onTap: (() {
              // Navigator.popAndPushNamed(context, '/thirdScreen');
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(builder: (context) => FauxLoginPage()),
              //   (Route<dynamic> route) => false,
              // );
            }),
          ),

          //Logout
          ListTile(
              leading: ImageIcon(
                AssetImage("assets/images/log-out.png"),
                //  color: Color(0xFF3A5A98),
              ),
              title: Text(
                'LOGOUT',
                textScaleFactor: 1,
              ),
              // trailing: Icon(
              //   Icons.arrow_right_sharp,
              //   color: Colors.green,
              //   size: 20,
              // ),
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              }),
        ],
      ),
    );
  }
}
