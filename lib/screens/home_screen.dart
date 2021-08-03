import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/blocs/match_bloc.dart';
import 'package:rosterz/blocs/user_bloc.dart';
import 'package:rosterz/drawer.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/models/match_info.dart';
import 'package:rosterz/models/user_info.dart';
import 'package:rosterz/screens/game_screen.dart';
import 'package:rosterz/screens/host_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rosterz/screens/notification_screen.dart';

var gameImg = {
  "PUBG": "https://images-na.ssl-images-amazon.com/images/I/51rkz8wallL.jpg",
  "BGMI":
      "https://cdn.insidesport.co/wp-content/uploads/2021/05/06142549/PUBG-Mobile-Tencent-Ban-2.jpg",
  "FREEFIRE":
      "https://venturebeat.com/wp-content/uploads/2020/05/Garena-Free-Fire.jpg?w=1200&strip=all",
  "COD":
      "https://staticg.sportskeeda.com/editor/2019/09/01cd6-15692379200287-800.jpg",
  "PUBGLITE":
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSW8dS7JtFYfvFEGsv2ES5ZKwPtryV29S8xIUrAQTyiKcNYXAuR7WuP-N9AMaVHrvNA5cc&usqp=CAU"
};

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> gameNo = ["PUBG", "BGMI", "FREEFIRE", "COD", "PUBGLITE"];
  var fcmToken;
  var matchIDs;
  bool isNotification = false;
  UserBloc userBloc = UserBloc();
  UserInfo userInfo = UserInfo();
  MatchBloc notiBloc = MatchBloc();
  MatchInfo notiInfo = MatchInfo();
  Future<void> getuser() async {
    userInfo.actions = "getinfo";
    userInfo.userID = userID;
    userBloc.eventSink.add(userInfo);
  }

  Future<void> saveFcmToken() async {
    var fcm = await FirebaseMessaging.instance.getToken();
    if (fcmToken != fcm) {
      try {
        await dio.post(serverURl + '/updatefcmtoken',
            data: jsonEncode({
              "userID": userID,
              "fcmToken": fcm,
            }));
      } on Error catch (e) {
        print(e);
      }
    }
  }

  void initState() {
    super.initState();
    saveFcmToken();
    getuser();
  }

  @override
  Widget build(BuildContext context) {
    toppad = MediaQuery.of(context).padding.top.ceil();
    bottompad = MediaQuery.of(context).padding.bottom.ceil();
    return SafeArea(
        child: Scaffold(
      drawer: AppDrawer(),
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        child: Container(
            margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(10),
                right: ScreenUtil().setWidth(103),
                left: ScreenUtil().setWidth(103)),
            height: 50.h,
            alignment: Alignment.center,
            //width: 150.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pink, Colors.deepPurple, Colors.lightBlue]),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
            ),
            padding: EdgeInsets.all(2.w),
            child: Container(
              alignment: Alignment.center,
              width: 150.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
                color: Colors.black,
              ),
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
              child: Text(
                "Host Match",
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            )),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => HostScreen()));
        },
      ),
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.network(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_oTrNIdMXgwyLxCYT9EckHlXQxjx-AHopE9kbER-PT01uYMJDHHVrrio6BXjWzh-pBg8&usqp=CAU",
            fit: BoxFit.cover,
            color: Colors.pink,
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Column(
          children: <Widget>[
            StreamBuilder(
                stream: userBloc.userStream,
                builder: (ctx, sss) {
                  if (sss.hasData) {
                    if (sss.data['success']) {
                      matchIDs = sss.data['msz'][0]['matchJoined'] +
                          sss.data['msz'][0]['matchHosted'];
                    }
                  }
                  return SizedBox();
                }),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              width: 360.w,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(30.h),
                ),
                gradient: LinearGradient(
                    colors: [Colors.pink, Colors.deepPurple, Colors.lightBlue]),
                // colors: [Colors.brown, Colors.amber, Colors.yellow]),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Builder(
                      builder: (context) => IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 20.w,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          })),
                  Text(
                    "Register Now!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w300),
                  ),
                  StreamBuilder(
                      stream: notiBloc.matchStream,
                      builder: (ctx, snapshot) {
                        notiInfo.actions = "getnotification";
                        notiInfo.matchIDs = matchIDs;
                        notiBloc.eventSink.add(notiInfo);
                        if (snapshot.hasData) {
                          if (snapshot.data['success']) {
                            if (notificationCount !=
                                snapshot.data['msz'].length) {
                              isNotification = true;
                            }
                          }
                        }
                        return IconButton(
                            icon: Icon(
                              isNotification
                                  ? Icons.notifications_active_rounded
                                  : Icons.notifications_rounded,
                              color: isNotification
                                  ? Colors.amberAccent
                                  : Colors.white,
                              size: isNotification ? 30.w : 20.w,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      NotificationScreen()));
                            });
                      }),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                width: 360.w,
                height: 630.h - toppad, //- bottompad,
                child: GridView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 20.h,
                        crossAxisSpacing: 40.w,
                        childAspectRatio: 1.3,
                        crossAxisCount: 2),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Card(
                            elevation: 2,
                            margin: EdgeInsets.only(
                                top: 10.h, left: 20.w, right: 20.w),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.h))),
                            child: Container(
                              height: 65.h,
                              width: 70.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.h)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          gameImg["${gameNo[index]}"]),
                                      fit: BoxFit.cover)),
                            )),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  GameScreen(gameNo[index])));
                        },
                      );
                    }))
          ],
        )
      ]),
    ));
  }
}
