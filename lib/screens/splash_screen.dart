import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/screens/auth_screen.dart';
import 'package:rosterz/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isData = false;

  savedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        userID = prefs.getString('userID');
        fcmToken = prefs.getString('fcmToken');
        notificationCount = prefs.getInt('notificationCount');
        if (notificationCount == null) {
          notificationCount = 0;
        }
        isData = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    savedData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return isData
        ? userID == null
            ? AuthScreen()
            : HomeScreen()
        : SafeArea(
            child: Scaffold(
            backgroundColor: Colors.black,
            body: StreamBuilder(
              builder: (ctx, snapShot) {
                return Container(
                  margin: EdgeInsets.only(
                      top: 345.h - 200.w, left: 30.w, right: 30.w),
                  height: 300.w,
                  width: 300.w,
                  child: Image.asset(
                    'assets/images/Logo.png',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ));
  }
}
