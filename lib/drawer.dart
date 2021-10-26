import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/screens/auth_screen.dart';
import 'package:rosterz/screens/feedback_screen.dart';
import 'package:rosterz/screens/mytournaments_screen.dart';
import 'package:rosterz/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

//ignore: must_be_immutable
class AppDrawer extends StatelessWidget {
//  @override
  EdgeInsets p = EdgeInsets.only(
      top: ScreenUtil().setHeight(10), left: ScreenUtil().setWidth(25));
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.black),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  //  color: Colors.deepPurpleAccent,
                  gradient: LinearGradient(
                    //  begin: Alignment.topLeft,
                    //    end: Alignment.bottomRight,
                    //  stops: [0.1, 0.2, 0.8, 1.0],
                    colors: <Color>[
                      Colors.lightGreenAccent,
                      Colors.lightBlueAccent,
                    ],
                    //   tileMode: TileMode.mirror,
                  ),
                  //   color: Colors.orange[500],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(ScreenUtil().setWidth(50)),
                    bottomRight: Radius.circular(ScreenUtil().setWidth(50)),
                  ),
                ),
                child: Center(
                    child: Text(
                  'RosterZ',
                  style: TextStyle(
                      color: Colors.green[900],
                      fontSize: 28,
                      fontWeight: FontWeight.w300),
                )),
              ),
              ListTile(
                contentPadding: p,
                leading: Icon(
                  Icons.account_circle_rounded,
                  size: 30.h,
                  color: Colors.lightBlueAccent,
                ),
                title: Text(
                  'My Profile',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(userID)));
                },
              ),
              ListTile(
                contentPadding: p,
                leading: Icon(
                  Icons.map,
                  size: 30.h,
                  color: Colors.lightGreenAccent,
                ),
                title: Text(
                  'My Tournaments',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyTournamentScreen()));
                },
              ),
              // ListTile(
              //   contentPadding: p,
              //   leading: Icon(
              //     Icons.map,
              //     size: 30.h,
              //     color: Colors.lightGreenAccent,
              //   ),
              //   title: Text(
              //     'Matches Joined',
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 12.sp,
              //         fontWeight: FontWeight.w600),
              //   ),
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => MatchJoinHostScreen("join")));
              //   },
              // ),
              // ListTile(
              //   contentPadding: p,
              //   leading: FaIcon(
              //     FontAwesomeIcons.wallet,
              //     size: 30.h,
              //     color: Colors.brown,
              //   ),
              //   title: Text(
              //     'Wallet',
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 12.sp,
              //         fontWeight: FontWeight.w600),
              //   ),
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => PaymentScreen()));
              //   },
              // ),
              // ListTile(
              //   contentPadding: p,
              //   leading: FaIcon(
              //     FontAwesomeIcons.chessKing,
              //     size: 30.h,
              //     color: Colors.amber,
              //   ),
              //   title: Text(
              //     'Membership',
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 12.sp,
              //         fontWeight: FontWeight.w600),
              //   ),
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => SubscriptionScreen()));
              //   },
              // ),
              ListTile(
                contentPadding: p,
                leading: Icon(
                  Icons.feedback_rounded,
                  size: 30.h,
                  color: Colors.white,
                ),
                title: Text(
                  'Feedback',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeedBackScreen()));
                },
              ),
              ListTile(
                  contentPadding: p,
                  leading: Icon(
                    Icons.logout,
                    size: 30.h,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('userID');
                    await prefs.remove('fcmToken');
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AuthScreen()));
                  }),
            ],
          ),
        ));
  }
}
