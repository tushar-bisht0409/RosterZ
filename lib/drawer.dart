import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/screens/auth_screen.dart';
import 'package:rosterz/screens/feedback_screen.dart';
import 'package:rosterz/screens/matchjoinhost_screen.dart';
import 'package:rosterz/screens/payment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

//ignore: must_be_immutable
class AppDrawer extends StatelessWidget {
//  @override
  EdgeInsets p = EdgeInsets.only(
      top: ScreenUtil().setHeight(10), left: ScreenUtil().setWidth(25));
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Colors.black.withOpacity(0.6)),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  // gradient: LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   //  stops: [0.1, 0.2, 0.8, 1.0],
                  //   colors: <Color>[
                  //     Colors.deepPurple,
                  //     Colors.pink,
                  //   ],
                  //   tileMode: TileMode.mirror,
                  // ),
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
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w400),
                )),
              ),
              ListTile(
                contentPadding: p,
                leading: Icon(
                  Icons.map,
                  size: 30.h,
                  color: Colors.pink[300],
                ),
                title: Text(
                  'Matches Joined',
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
                          builder: (context) => MatchJoinHostScreen("join")));
                },
              ),
              ListTile(
                contentPadding: p,
                leading: Icon(
                  Icons.hourglass_top_rounded,
                  size: 30.h,
                  color: Colors.pink[300],
                ),
                title: Text(
                  'Matches Hosted',
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
                          builder: (context) => MatchJoinHostScreen("host")));
                },
              ),
              ListTile(
                contentPadding: p,
                leading: Icon(
                  Icons.attach_money_rounded,
                  size: 30.h,
                  color: Colors.pink[300],
                ),
                title: Text(
                  'Wallet',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PaymentScreen()));
                },
              ),
              ListTile(
                contentPadding: p,
                leading: Icon(
                  Icons.feedback_rounded,
                  size: 30.h,
                  color: Colors.pink[300],
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
                    color: Colors.pink[300],
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
