import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/screens/allmatch_screen.dart';

class GameScreen extends StatefulWidget {
  static const routeName = '/game';
  var gameName;
  GameScreen(this.gameName);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _controller = new TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
        ),
        ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
              width: 360.w,
              height: 75.h,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: 20.w,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  GestureDetector(
                      child: Container(
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(200),
                          height: 50.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.pink,
                              Colors.deepPurple,
                              Colors.lightBlue
                            ]),
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(30)),
                          ),
                          padding: EdgeInsets.all(2.w),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(30)),
                                color: Colors.black,
                              ),
                              child: Center(
                                  child: TextField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.deepPurple[300],
                                    size: 20.w,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.w),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.w),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.w),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.w),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.w),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.w),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 20.w),
                                  hintText: "MatchID",

                                  // fillColor: Colors.transparent[100],
                                  focusColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                                enabled: false,
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.white,
                              )))),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Container(
                                color: Colors.deepPurple[900],
                                margin: EdgeInsets.only(
                                    bottom: 220.h, left: 30.w, right: 30.w),
                                padding: EdgeInsets.only(
                                    top: 20.h,
                                    bottom: 20.h,
                                    left: 20.w,
                                    right: 20.w),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    Text('Search By :-',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w400)),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width: ScreenUtil().setWidth(200),
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil().setWidth(30)),
                                        ),
                                        padding: EdgeInsets.all(2.w),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil()
                                                          .setWidth(30)),
                                              color: Colors.black,
                                            ),
                                            child: Center(
                                                child: TextField(
                                              controller: _controller,
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.search,
                                                  color: Colors.white,
                                                  size: 20.w,
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.w),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.w),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.w),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.w),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.w),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.w),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.only(left: 20.w),
                                                hintText: "Type Here",

                                                // fillColor: Colors.transparent[100],
                                                focusColor: Colors.white,
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[400]),
                                              ),
                                              style: TextStyle(
                                                  color: Colors.white),
                                              keyboardType: TextInputType.text,
                                              cursorColor: Colors.white,
                                            )))),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    Container(
                                      width: 280.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          GestureDetector(
                                            child: Column(children: <Widget>[
                                              Icon(
                                                Icons.text_format_rounded,
                                                color: Colors.lightGreen,
                                              ),
                                              Text('MatchID',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ]),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          AllMatchScreen(
                                                              widget.gameName,
                                                              "",
                                                              "matchID",
                                                              _controller.text,
                                                              "")));
                                            },
                                          ),
                                          GestureDetector(
                                            child: Column(children: <Widget>[
                                              Icon(
                                                Icons.person,
                                                color: Colors.lightBlue,
                                              ),
                                              Text('Organizer',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ]),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          AllMatchScreen(
                                                              widget.gameName,
                                                              "",
                                                              "organizer",
                                                              "",
                                                              _controller
                                                                  .text)));
                                            },
                                          ),
                                          GestureDetector(
                                            child: Column(children: <Widget>[
                                              Icon(
                                                Icons.gamepad_rounded,
                                                color: Colors.pink,
                                              ),
                                              Text('Game',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ]),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          AllMatchScreen(
                                                              _controller.text,
                                                              "",
                                                              "game",
                                                              "",
                                                              "")));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                  ],
                                ),
                              );
                            });
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.payment_rounded,
                        color: Colors.transparent,
                        size: 20.w,
                      ),
                      onPressed: () {})
                ],
              ),
            ),
            Center(
                child: Text(
              widget.gameName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600),
            )),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              width: double.infinity,
              height: 620.h - toppad - 30.sp, //- bottompad,
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.pink,
                          Colors.deepPurple,
                          Colors.lightBlue
                        ]),
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(20)),
                      ),
                      padding: EdgeInsets.all(2.w),
                      child: Container(
                          width: ScreenUtil().setWidth(320),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(20)),
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 20.w),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Daily Matches",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "\nDescription : ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "Join/Host the macthes here.\n",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(14),
                                            fontWeight: FontWeight.w600,
                                          )),
                                      TextSpan(
                                          text:
                                              "No reward is given by the app for these matches.",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(14),
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ]),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AllMatchScreen(widget.gameName,
                                                    "daily", "game", "", "")));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 25.h),
                                    decoration: BoxDecoration(
                                        color: Colors.pink,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.h))),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 20.w),
                                    child: Text(
                                      "Let's Go",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ))
                            ],
                          ))),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.pink,
                          Colors.deepPurple,
                          Colors.lightBlue
                        ]),
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(20)),
                      ),
                      padding: EdgeInsets.all(2.w),
                      child: Container(
                          width: ScreenUtil().setWidth(320),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(20)),
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 20.w),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Reward Matches",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "\nDescription : ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "Join/Host the macthes here.\n",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(14),
                                            fontWeight: FontWeight.w600,
                                          )),
                                      TextSpan(
                                          text:
                                              "Reward is given by the app for these matches.",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(14),
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ]),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AllMatchScreen(widget.gameName,
                                                    "reward", "game", "", "")));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 25.h),
                                    decoration: BoxDecoration(
                                        color: Colors.pink,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.h))),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 20.w),
                                    child: Text(
                                      "Let's Go",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ))
                            ],
                          ))),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.pink,
                          Colors.deepPurple,
                          Colors.lightBlue
                        ]),
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(20)),
                      ),
                      padding: EdgeInsets.all(2.w),
                      child: Container(
                          width: ScreenUtil().setWidth(320),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(20)),
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 20.w),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Tournaments",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              Icon(
                                Icons.lock,
                                size: 40.h,
                                color: Colors.deepPurple[300],
                              )
                            ],
                          )))
                ],
              ),
            )
          ],
        )
      ]),
    ));
  }
}
