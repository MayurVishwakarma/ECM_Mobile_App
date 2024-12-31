// ignore_for_file: deprecated_member_use

import 'package:ecm_application/Screens/Login/AdminScreen.dart';
import 'package:ecm_application/Screens/Login/ChangePassword.dart';
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
  String userType = 'Engineer';

  @override
  void initState() {
    super.initState();
    _getUserType();
  }

  Future<void> _getUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userType = preferences.getString('usertype') ?? 'Engineer';
    });
  }

  void _navigateTo(BuildContext context, Widget screen,
      {bool clearStack = false}) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => screen),
      (route) => !clearStack,
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blueGrey, Colors.blue],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/SeLogo.png'),
          ),
          const SizedBox(height: 10),
          Text(
            MyApp.username ?? 'Guest',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String iconPath, Widget screen,
      {bool clearStack = true}) {
    return ListTile(
      leading: ImageIcon(AssetImage(iconPath)),
      title: Text(title, textScaleFactor: 1),
      onTap: () => _navigateTo(context, screen, clearStack: clearStack),
    );
  }

  Widget _buildAppInfo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: Text(
            "Erection, Commission & Maintenance",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 3.0, 0.0, 0.0),
          child: Text('ECM Mobile Application', style: TextStyle(fontSize: 14)),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 3.0, 0.0, 10.0),
          child: Text('App Version-v2.7', style: TextStyle(fontSize: 10)),
        ),
      ],
    );
  }

  Future<void> _logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    _navigateTo(context, LoginScreen(), clearStack: true);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildAppInfo(),
          _buildListTile(
              'Home', 'assets/images/home.png', ProjectsCategoryScreen()),
          if (userType != 'Engineer_Client' && userType != 'Cli')
            _buildListTile('Attendance', 'assets/images/attendance.png',
                const AttendanceScreen(),
                clearStack: false),
          _buildListTile('Change Password', 'assets/images/password.png',
              const ChangePasswordScreen(),
              clearStack: false),
          if (userType.toLowerCase().contains('admin') ||
              userType.toLowerCase().contains('manager'))
            _buildListTile('Admin Panel', 'assets/images/add-friend.png',
                const AdminScreen(),
                clearStack: false),
          ListTile(
            leading: const ImageIcon(AssetImage("assets/images/log-out.png")),
            title: const Text('Logout', textScaleFactor: 1),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
