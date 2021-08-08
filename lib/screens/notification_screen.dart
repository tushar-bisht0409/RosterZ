import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rosterz/blocs/match_bloc.dart';
import 'package:rosterz/blocs/user_bloc.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/models/match_info.dart';
import 'package:rosterz/models/user_info.dart';
import 'package:rosterz/screens/result_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = '/notification';
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  MatchBloc notiBloc = MatchBloc();
  MatchInfo notiInfo = MatchInfo();
  UserBloc userBloc = UserBloc();
  UserInfo userInfo = UserInfo();
  SharedPreferences prefs;
  bool isLoaded = false;
  var matchIDs;
  int tempCount;
  Future<void> getnoti() async {
    prefs = await SharedPreferences.getInstance();
    userInfo.actions = "getinfo";
    userInfo.userID = userID;
    userBloc.eventSink.add(userInfo);
  }

  @override
  void initState() {
    super.initState();
    getnoti();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: ListView(shrinkWrap: true, children: <Widget>[
              StreamBuilder(
                  stream: userBloc.userStream,
                  builder: (ctx, sss) {
                    if (sss.hasData) {
                      if (sss.data['success']) {
                        if (matchIDs == null) {
                          matchIDs = sss.data['msz'][0]['matchJoined'] +
                              sss.data['msz'][0]['matchHosted'];
                        }
                      }
                    }
                    return SizedBox();
                  }),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 20.h,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    Container(
                        alignment: Alignment.topCenter,
                        //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 15.w),
                        height: 70.h,
                        color: Colors.transparent,
                        child: Icon(
                          Icons.notifications_on_rounded,
                          size: 40.h,
                          color: Colors.white,
                        )),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 20.h,
                          color: Colors.transparent,
                        ),
                        onPressed: () {}),
                  ]),
              StreamBuilder(
                  stream: notiBloc.matchStream,
                  builder: (ctx, snapshot) {
                    notiInfo.actions = "getnotification";
                    notiInfo.matchIDs = matchIDs;
                    notiBloc.eventSink.add(notiInfo);

                    if (snapshot.hasData) {
                      if (snapshot.data['success'] == false) {
                        return Padding(
                            padding: EdgeInsets.only(top: 200.h),
                            child: Center(
                              child: Column(children: <Widget>[
                                Icon(
                                  Icons.notifications_off_rounded,
                                  color: Colors.pink,
                                  size: 100.h,
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    width: 250.w,
                                    child: Text(
                                      'No Notifications',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ))
                              ]),
                            ));
                      }
                      tempCount = snapshot.data['msz'].length;
                      if (notificationCount != snapshot.data['msz'].length) {
                        prefs.setInt(
                            'notificationCount', snapshot.data['msz'].length);
                      }

                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data['msz'].length,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            var ts = DateTime.parse(
                                snapshot.data['msz'][index]['timeStamp']);
                            return GestureDetector(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    // vertical: 10.h,
                                    // horizontal: 20.w
                                    ),
                                color: snapshot.data['msz'].length - 1 - index <
                                        notificationCount
                                    ? Colors.black
                                    : Colors.white12,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 0.5.h,
                                      width: 360.h,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Colors.pink,
                                          Colors.deepPurple,
                                          Colors.lightBlue
                                        ]),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Container(
                                        width: 300.w,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data['msz'][index]
                                                  ['organizer'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Icon(
                                              snapshot.data['msz'].length -
                                                          1 -
                                                          index <
                                                      notificationCount
                                                  ? Icons
                                                      .notifications_none_rounded
                                                  : Icons
                                                      .notifications_active_rounded,
                                              size: 15.h,
                                              color:
                                                  snapshot.data['msz'].length -
                                                              1 -
                                                              index <
                                                          notificationCount
                                                      ? Colors.deepPurple
                                                      : Colors.pink,
                                            )
                                          ],
                                        )),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width: 320.w,
                                        child: RichText(
                                            text: TextSpan(
                                                text:
                                                    "${snapshot.data['msz'][index]['title']}: ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                children: <TextSpan>[
                                              TextSpan(
                                                  text: snapshot.data['msz']
                                                      [index]['body'],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ]))),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Container(
                                        alignment: Alignment.bottomRight,
                                        width: 320.w,
                                        child: Text(
                                            DateFormat('H:mm a, d MMMM')
                                                .format(ts),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600))),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                      height: 1.h,
                                      width: 360.h,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Colors.pink,
                                          Colors.deepPurple,
                                          Colors.lightBlue
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                if (snapshot.data['msz'][index]['title'] ==
                                    "Result") {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ResultScreen(
                                              "show",
                                              "",
                                              snapshot.data['msz'][index]
                                                  ['matchID'])));
                                }
                              },
                            );
                          });
                    }
                    return Padding(
                      padding: EdgeInsets.only(top: 300.h),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  })
            ])));
  }
}
