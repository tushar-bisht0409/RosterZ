import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/screens/auth_screen.dart';
import 'package:rosterz/screens/allmatch_screen.dart';
import 'package:rosterz/screens/game_screen.dart';
import 'package:rosterz/screens/home_screen.dart';
import 'package:rosterz/screens/host_screen.dart';
import 'package:rosterz/screens/match_screen.dart';
import 'package:rosterz/screens/notification_screen.dart';
import 'package:rosterz/screens/result_screen.dart';
import 'package:rosterz/screens/search_screen.dart';
import 'package:rosterz/screens/splash_screen.dart';

String serverURl = "https://rosterz.herokuapp.com";
var dio = Dio();
String token = "";
String fcmToken = "";
String userID;
int toppad = 0;
int bottompad = 0;
int notificationCount = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 690),
        // allowFontScaling: false,
        builder: () => FutureBuilder(builder: (context, appSnapshot) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: Colors.deepPurple,
                  ),
                  home: SplashScreen(),
                  routes: {
                    AuthScreen.routeName: (context) => AuthScreen(),
                    HomeScreen.routeName: (context) => HomeScreen(),
                    GameScreen.routeName: (context) => GameScreen(""),
                    AllMatchScreen.routeName: (context) =>
                        AllMatchScreen("", "", "", "", ""),
                    MatchScreen.routeName: (context) =>
                        MatchScreen("", false, ""),
                    HostScreen.routeName: (context) => HostScreen(),
                    ResultScreen.routeName: (context) =>
                        ResultScreen("", "", ""),
                    NotificationScreen.routeName: (context) =>
                        NotificationScreen(),
                    SplashScreen.routeName: (context) => SplashScreen(),
                    SearchScreen.routeName: (context) => SearchScreen(),
                  });
            }));
  }
}