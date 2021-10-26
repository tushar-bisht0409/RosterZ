//import 'package:admob_flutter/admob_flutter.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/screens/alltournament_screen.dart';
import 'package:rosterz/screens/auth_screen.dart';
// import 'package:rosterz/screens/banner_screen.dart';
// import 'package:rosterz/screens/bannerinter_screen.dart';
import 'package:rosterz/screens/feedback_screen.dart';
import 'package:rosterz/screens/home_screen.dart';
import 'package:rosterz/screens/host_profile_screen.dart';
import 'package:rosterz/screens/mytournaments_screen.dart';
import 'package:rosterz/screens/notification_screen.dart';
import 'package:rosterz/screens/profile_screen.dart';
import 'package:rosterz/screens/teamsandresults_screen.dart';
import 'package:rosterz/screens/splash_screen.dart';
import 'package:rosterz/screens/stats_screen.dart';
import 'package:rosterz/screens/team_screen.dart';
import 'package:rosterz/screens/tournamentscreen.dart';
import 'package:rosterz/screens/tournamentteam_screen.dart';
//import 'package:tap_joy_plugin/tap_joy_plugin.dart';

String serverURl = "https://rosterz.herokuapp.com";
var dio = Dio();
String token = "";
String fcmToken = "";
String userID;
var teamID;
int toppad = 0;
int bottompad = 0;
int notificationCount = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Admob.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return ScreenUtilInit(
        designSize: Size(360, 690),
        // allowFontScaling: false,1
        builder: () => FutureBuilder(builder: (context, appSnapshot) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: Colors.lightBlue,
                  ),
                  home: SplashScreen(),
                  routes: {
                    AuthScreen.routeName: (context) => AuthScreen(),
                    HomeScreen.routeName: (context) => HomeScreen(),
                    NotificationScreen.routeName: (context) =>
                        NotificationScreen(),
                    SplashScreen.routeName: (context) => SplashScreen(),
                    FeedBackScreen.routeName: (context) => FeedBackScreen(),
                    ProfileScreen.routeName: (context) => ProfileScreen(""),
                    HostProfileScreen.routeName: (context) =>
                        HostProfileScreen(""),
                    StatsScreen.routeName: (context) => StatsScreen(),
                    TournamentScreen.routeName: (context) =>
                        TournamentScreen('', ''),
                    AllTournamentScreen.routeName: (context) =>
                        AllTournamentScreen(''),
                    TeamScreen.routeName: (context) => TeamScreen(),
                    MyTournamentScreen.routeName: (context) =>
                        MyTournamentScreen(),
                    TournamentTeamScreen.routeName: (context) =>
                        TournamentTeamScreen('', '', '', '', '')
                  });
            }));
  }
}
