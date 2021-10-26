import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rosterz/blocs/tournament_bloc.dart';
import 'package:rosterz/blocs/user_bloc.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/models/tournament_info.dart';
import 'package:rosterz/models/user_info.dart';

class TeamScreen extends StatefulWidget {
  static const routeName = '/team';
  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  var yourGame;
  UserBloc userBloc = UserBloc();
  UserInfo userInfo = UserInfo();
  TournamentBloc getTeamBloc = TournamentBloc();
  TournamentInfo getTeamInfo = TournamentInfo();
  TournamentBloc teamBloc = TournamentBloc();
  TournamentInfo teamInfo = TournamentInfo();
  TournamentBloc teamNameBloc = TournamentBloc();
  TournamentInfo teamNameInfo = TournamentInfo();
  TextEditingController tidCon = TextEditingController();
  TextEditingController tName = TextEditingController();
  TextEditingController pName = TextEditingController();
  TextEditingController jName = TextEditingController();
  var teamData;
  var curTeamID;
  int teamInd;
  var uName;
  var myTeamName;
  bool isExit = false;
  var isTeamName = "join";
  bool gotTeam = false;
  bool teamExe = false;
  bool exitMode = false;
  bool isButtonLoad = false;
  bool isToRefresh = false;
  var exitID;

  void _showDialog(String nam, String rID, String tN, String tmID) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.w),
        ),
        title: Text(
          rID == userID ? "Exit!" : 'Remove!',
          style: TextStyle(
              color: Colors.redAccent,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900),
        ),
        content: Text(
          rID == userID
              ? "Are you sure to exit from the team?"
              : "Are you sure to remove $nam from the team?",
          style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 16.sp,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              rID == userID ? "Exit" : 'Remove',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 16.sp,
              ),
            ),
            onPressed: () async {
              if (mounted) {
                setState(() {
                  exitID = rID;
                  teamInfo.type = "remove";
                  teamInfo.userID = rID;
                  teamInfo.game = yourGame;
                  teamInfo.teamName = tN;
                  teamInfo.player = nam;
                  teamInfo.teamID = tmID;
                  // curTeamID = null;
                  isExit = false;
                  // teamInd = null;
                  if (rID != userID) {
                    gotTeam = false;
                  } else {
                    exitMode = true;
                    isButtonLoad = false;
                  }
                  teamBloc.eventSink.add(teamInfo);
                  Navigator.of(context).pop();
                });
              }
            },
          )
        ],
      ),
    );
  }

  checkTeamGame() {
    if (mounted) {
      setState(() {
        if (teamInd == null) {
          var tindex =
              teamData.indexWhere((element) => element["game"] == yourGame);
          if (tindex == -1) {
            teamInd = null;
          } else {
            teamInd = tindex;
          }
        }
        gotTeam = false;
      });
    }
  }

  refresMyTeam() {
    if (isToRefresh == false) {
      if (mounted) {
        setState(() {
          isToRefresh = true;
          teamInd = null;
          isExit = false;
          gotTeam = false;
          exitMode = false;
        });
        checkTeamGame();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    userInfo.actions = "getinfo";
    userInfo.userID = userID;
    teamInfo.actions = "teamactions";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: StreamBuilder(
                stream: userBloc.userStream,
                builder: (ctx, snapshot) {
                  userBloc.eventSink.add(userInfo);

                  if (snapshot.hasData) {
                    if (snapshot.data["success"]) {
                      teamData = snapshot.data["msz"][0]["teams"];
                      if (teamInd == null && exitMode == false) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          checkTeamGame();
                        });
                      }
                      if (exitID == userID) {
                        if (exitID == userID) {
                          var tt = teamData.indexWhere(
                              (element) => element["game"] == yourGame);
                          if (tt != -1) {
                            teamData.removeAt(tt);
                          }
                        }
                        gotTeam = false;
                        teamInd = null;
                        exitID = null;
                      }

                      return ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          StreamBuilder(
                              stream: teamBloc.tournamentStream,
                              builder: (ctx, sst) {
                                if (sst.hasData) {
                                  if (sst.data["success"]) {
                                    if (exitID == userID) {
                                      var tt = teamData.indexWhere((element) =>
                                          element["game"] == yourGame);
                                      if (tt != -1) {
                                        teamData.removeAt(tt);
                                      }
                                      teamInd = null;
                                      isExit = false;

                                      userBloc.eventSink.add(userInfo);
                                    }
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      refresMyTeam();
                                    });
                                  }
                                }
                                return Container();
                              }),
                          StreamBuilder(
                              stream: teamNameBloc.tournamentStream,
                              builder: (ctx, ssteam) {
                                if (ssteam.hasData) {
                                  if (ssteam.data["success"]) {
                                    if (isTeamName == "gTeam") {
                                      isTeamName = "got";
                                      print(ssteam.data);
                                      if (isTeamName == "got") {
                                        isTeamName = "joined";
                                        teamInfo.type = "join";
                                        teamInfo.userID = userID;
                                        teamInfo.game = yourGame;
                                        teamInfo.teamName =
                                            ssteam.data["msz"][0]["teamName"];
                                        teamInfo.player = jName.text;
                                        teamInfo.teamID = tidCon.text;
                                        if (ssteam.data["msz"][0]["game"] ==
                                            yourGame) {
                                          print(ssteam.data);

                                          teamBloc.eventSink.add(teamInfo);
                                          isToRefresh = false;
                                        } else {
                                          if (isTeamName == "gTeam") {
                                            isTeamName = "joined";
                                            isButtonLoad = false;
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      duration:
                                                          Duration(seconds: 2),
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      content: Text(
                                                        "No Team Exist.",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )));
                                            });
                                          }
                                        }
                                      }
                                    }
                                  } else {
                                    if (isTeamName == "gTeam") {
                                      isTeamName = "joined";
                                      isButtonLoad = false;
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                duration: Duration(seconds: 2),
                                                backgroundColor:
                                                    Colors.redAccent,
                                                content: Text(
                                                  "No Team Exist.",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )));
                                      });
                                    }
                                  }
                                }

                                return Container();
                              }),
                          Container(
                            alignment: Alignment.topCenter,
                            //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                            padding: EdgeInsets.symmetric(
                                vertical: 20.h, horizontal: 15.w),
                            width: 360.w,
                            height: 70.h,
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
                                Container(
                                    width: 200.w,
                                    height: 50.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(30)),
                                    ),
                                    child: Text(
                                      "My Teams",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w600),
                                    )),
                                IconButton(
                                    icon: Icon(
                                      Icons.filter_alt_rounded,
                                      color: Colors.transparent,
                                      size: 20.w,
                                    ),
                                    onPressed: () {})
                              ],
                            ),
                          ),
                          Container(
                              width: 280.w,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  top: 10.h,
                                  bottom: 10.h,
                                  left: 40.w,
                                  right: 40.w),
                              child: Text(
                                "Select A Game",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w300),
                              )),
                          Container(
                              width: 280.w,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  top: 10.h,
                                  bottom: 10.h,
                                  left: 40.w,
                                  right: 40.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: ScreenUtil().setWidth(90),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Colors.lightBlue,
                                                Colors.blue,
                                                Colors.blue[700]
                                              ]),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil()
                                                          .setWidth(30)),
                                            ),
                                            padding: yourGame == "BGMI"
                                                ? EdgeInsets.zero
                                                : EdgeInsets.all(2.w),
                                            child: Container(
                                              alignment: Alignment.center,
                                              //  width: ScreenUtil().setWidth(200),

                                              decoration: BoxDecoration(
                                                color: yourGame == "BGMI"
                                                    ? Colors.lightGreenAccent
                                                    : Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(30.w),
                                              ),
                                              width: 90.w,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.h,
                                                  horizontal: 5.w),
                                              child: Text("BGMI",
                                                  style: TextStyle(
                                                      color: yourGame == "BGMI"
                                                          ? Colors.green[900]
                                                          : Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 10.sp)),
                                            )),
                                        onTap: () {
                                          if (mounted) {
                                            setState(() {
                                              teamInd = null;
                                              yourGame = "BGMI";
                                              isExit = false;
                                              gotTeam = false;
                                              exitMode = false;
                                              isButtonLoad = false;
                                            });
                                            checkTeamGame();
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: ScreenUtil().setWidth(90),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Colors.lightBlue,
                                                Colors.blue,
                                                Colors.blue[700]
                                              ]),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil()
                                                          .setWidth(30)),
                                            ),
                                            padding: yourGame == "PUBG"
                                                ? EdgeInsets.zero
                                                : EdgeInsets.all(2.w),
                                            child: Container(
                                              alignment: Alignment.center,
                                              //  width: ScreenUtil().setWidth(200),

                                              decoration: BoxDecoration(
                                                color: yourGame == "PUBG"
                                                    ? Colors.lightGreenAccent
                                                    : Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(30.w),
                                              ),
                                              width: 90.w,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.h,
                                                  horizontal: 5.w),
                                              child: Text("PUBG",
                                                  style: TextStyle(
                                                      color: yourGame == "PUBG"
                                                          ? Colors.green[900]
                                                          : Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 10.sp)),
                                            )),
                                        onTap: () {
                                          if (mounted) {
                                            setState(() {
                                              teamInd = null;
                                              yourGame = "PUBG";
                                              isExit = false;
                                              gotTeam = false;
                                              exitMode = false;
                                              isButtonLoad = false;
                                            });
                                            checkTeamGame();
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: ScreenUtil().setWidth(90),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Colors.lightBlue,
                                                Colors.blue,
                                                Colors.blue[700]
                                              ]),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil()
                                                          .setWidth(30)),
                                            ),
                                            padding: yourGame == "COD"
                                                ? EdgeInsets.zero
                                                : EdgeInsets.all(2.w),
                                            child: Container(
                                              alignment: Alignment.center,
                                              //  width: ScreenUtil().setWidth(200),

                                              decoration: BoxDecoration(
                                                color: yourGame == "COD"
                                                    ? Colors.lightGreenAccent
                                                    : Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(30.w),
                                              ),
                                              width: 90.w,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.h,
                                                  horizontal: 5.w),
                                              child: Text("COD",
                                                  style: TextStyle(
                                                      color: yourGame == "COD"
                                                          ? Colors.green[900]
                                                          : Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 10.sp)),
                                            )),
                                        onTap: () {
                                          if (mounted) {
                                            setState(() {
                                              teamInd = null;
                                              yourGame = "COD";
                                              isExit = false;
                                              gotTeam = false;
                                              exitMode = false;
                                              isButtonLoad = false;
                                            });
                                            checkTeamGame();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: ScreenUtil().setWidth(90),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Colors.lightBlue,
                                                Colors.blue,
                                                Colors.blue[700]
                                              ]),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil()
                                                          .setWidth(30)),
                                            ),
                                            padding: yourGame == "FREEFIRE"
                                                ? EdgeInsets.zero
                                                : EdgeInsets.all(2.w),
                                            child: Container(
                                              alignment: Alignment.center,
                                              //  width: ScreenUtil().setWidth(200),

                                              decoration: BoxDecoration(
                                                color: yourGame == "FREEFIRE"
                                                    ? Colors.lightGreenAccent
                                                    : Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(30.w),
                                              ),
                                              width: 90.w,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.h,
                                                  horizontal: 5.w),
                                              child: Text("FREE FIRE",
                                                  style: TextStyle(
                                                      color: yourGame ==
                                                              "FREEFIRE"
                                                          ? Colors.green[900]
                                                          : Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 10.sp)),
                                            )),
                                        onTap: () {
                                          if (mounted) {
                                            setState(() {
                                              teamInd = null;
                                              yourGame = "FREEFIRE";
                                              isExit = false;
                                              gotTeam = false;
                                              exitMode = false;
                                              isButtonLoad = false;
                                            });
                                            checkTeamGame();
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: ScreenUtil().setWidth(90),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Colors.lightBlue,
                                                Colors.blue,
                                                Colors.blue[700]
                                              ]),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil()
                                                          .setWidth(30)),
                                            ),
                                            padding: yourGame == "CLASHROYALE"
                                                ? EdgeInsets.zero
                                                : EdgeInsets.all(2.w),
                                            child: Container(
                                              alignment: Alignment.center,
                                              //  width: ScreenUtil().setWidth(200),

                                              decoration: BoxDecoration(
                                                color: yourGame == "CLASHROYALE"
                                                    ? Colors.lightGreenAccent
                                                    : Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(30.w),
                                              ),
                                              width: 90.w,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.h,
                                                  horizontal: 5.w),
                                              child: Text("CLASH ROYALE",
                                                  style: TextStyle(
                                                      color: yourGame ==
                                                              "CLASHROYALE"
                                                          ? Colors.green[900]
                                                          : Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 10.sp)),
                                            )),
                                        onTap: () {
                                          if (mounted) {
                                            setState(() {
                                              teamInd = null;
                                              yourGame = "CLASHROYALE";
                                              isExit = false;
                                              gotTeam = false;
                                              exitMode = false;
                                              isButtonLoad = false;
                                            });
                                            checkTeamGame();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                        alignment: Alignment.center,
                                        width: ScreenUtil().setWidth(90),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            Colors.lightBlue,
                                            Colors.blue,
                                            Colors.blue[700]
                                          ]),
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil().setWidth(30)),
                                        ),
                                        padding: yourGame == "PUBGLITE"
                                            ? EdgeInsets.zero
                                            : EdgeInsets.all(2.w),
                                        child: Container(
                                          alignment: Alignment.center,
                                          //  width: ScreenUtil().setWidth(200),

                                          decoration: BoxDecoration(
                                            color: yourGame == "PUBGLITE"
                                                ? Colors.lightGreenAccent
                                                : Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          width: 90.w,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h, horizontal: 5.w),
                                          child: Text("PUBG LITE",
                                              style: TextStyle(
                                                  color: yourGame == "PUBGLITE"
                                                      ? Colors.green[900]
                                                      : Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10.sp)),
                                        )),
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          teamInd = null;
                                          yourGame = "PUBGLITE";
                                          isExit = false;
                                          gotTeam = false;
                                          exitMode = false;
                                          isButtonLoad = false;
                                        });
                                        checkTeamGame();
                                      }
                                    },
                                  )
                                ],
                              )),
                          teamInd == null
                              ? Container(
                                  width: 280.w,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      top: 10.h,
                                      bottom: 10.h,
                                      left: 40.w,
                                      right: 40.w),
                                  child: Text(
                                    "You are not in a team. Please create or join one.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                        fontSize: 16.sp),
                                  ))
                              : Container(
                                  width: 180.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.lightBlueAccent,
                                      Colors.lightGreenAccent,
                                    ]),
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(30)),
                                  ),
                                  margin: EdgeInsets.only(
                                      top: 10.h,
                                      bottom: 10.h,
                                      left: 90.w,
                                      right: 90.w),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.h),
                                  child: Text(
                                    myTeamName == null ? "" : "$myTeamName",
                                    style: TextStyle(
                                        color: Colors.green[900],
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20.sp),
                                  )),
                          teamInd == null
                              ? Container(
                                  alignment: Alignment.center,
                                  width: ScreenUtil().setWidth(280),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 40.w),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.lightBlue,
                                      Colors.green,
                                      Colors.blue[700]
                                    ]),
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(30)),
                                  ),
                                  padding: EdgeInsets.all(2.w),
                                  child: Container(
                                      alignment: Alignment.center,
                                      //  width: ScreenUtil().setWidth(200),

                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(30.w),
                                      ),
                                      child: TextField(
                                        controller: tName,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          contentPadding:
                                              EdgeInsets.only(left: 20.w),
                                          hintText: "Team Name",
                                          focusColor: Colors.black,
                                          filled: true,
                                          fillColor: Colors.black,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                        enabled: true,
                                        style: TextStyle(color: Colors.white),
                                        keyboardType: TextInputType.text,
                                        cursorColor: Colors.white,
                                      )))
                              : StreamBuilder(
                                  stream: getTeamBloc.tournamentStream,
                                  builder: (ctx, sss) {
                                    getTeamInfo.actions = "getteam";
                                    getTeamInfo.game = yourGame;
                                    if (gotTeam == false) {
                                      getTeamBloc.eventSink.add(getTeamInfo);
                                    }
                                    if (sss.hasData) {
                                      if (sss.data["success"] == false) {
                                        return Padding(
                                            padding: EdgeInsets.only(top: 40.h),
                                            child: Center(
                                              child: Column(children: <Widget>[
                                                Icon(
                                                  Icons.cancel_rounded,
                                                  color: Colors.white,
                                                  size: 100.h,
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    width: 250.w,
                                                    child: Text(
                                                      'No Information Available',
                                                      style: TextStyle(
                                                        fontSize: 20.sp,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.white,
                                                      ),
                                                    ))
                                              ]),
                                            ));
                                      } else if (sss.data["success"]) {
                                        gotTeam = true;
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: sss
                                                .data["msz"][0]["playersName"]
                                                .length,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (ctx, index) {
                                              if (sss.data["msz"][0]
                                                      ["playersID"][index] ==
                                                  userID) {
                                                uName = sss.data["msz"][0]
                                                    ["playersName"][index];
                                              }
                                              myTeamName = sss.data["msz"][0]
                                                  ["teamName"];
                                              curTeamID =
                                                  sss.data["msz"][0]["teamID"];
                                              isExit = true;
                                              return Container(
                                                  alignment: Alignment.center,
                                                  width: ScreenUtil()
                                                      .setWidth(280),
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10.h,
                                                      horizontal: 40.w),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Colors.lightBlue,
                                                          Colors.green,
                                                          Colors.blue[700]
                                                        ]),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            ScreenUtil()
                                                                .setWidth(10)),
                                                  ),
                                                  padding: EdgeInsets.all(2.w),
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      //  width: ScreenUtil().setWidth(200),

                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.w),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5.h,
                                                              horizontal: 20.w),
                                                      child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                                width: 190.w,
                                                                child: RichText(
                                                                    text: TextSpan(
                                                                        text:
                                                                            "${index + 1}.",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize: 18
                                                                                .sp,
                                                                            fontWeight: FontWeight
                                                                                .w700),
                                                                        children: <
                                                                            TextSpan>[
                                                                      TextSpan(
                                                                          text:
                                                                              "\t\t\t\t\t${sss.data["msz"][0]["playersName"][index]} ",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 14.sp,
                                                                              fontWeight: FontWeight.w300)),
                                                                      TextSpan(
                                                                          text: sss.data["msz"][0]["playersID"][index] == userID
                                                                              ? "(You)"
                                                                              : "",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 10.sp,
                                                                              fontWeight: FontWeight.w800))
                                                                    ]))),
                                                            sss.data["msz"][0]["playersID"]
                                                                            [
                                                                            0] ==
                                                                        userID ||
                                                                    sss.data["msz"][0]["playersID"]
                                                                            [
                                                                            index] ==
                                                                        userID
                                                                ? IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      _showDialog(
                                                                          sss.data["msz"][0]["playersName"]
                                                                              [
                                                                              index],
                                                                          sss.data["msz"][0]["playersID"]
                                                                              [
                                                                              index],
                                                                          sss.data["msz"][0]
                                                                              [
                                                                              "teamName"],
                                                                          sss.data["msz"][0]
                                                                              [
                                                                              "teamID"]);
                                                                    },
                                                                    icon: Icon(
                                                                      Icons
                                                                          .delete_rounded,
                                                                      color: Colors
                                                                          .lightGreenAccent,
                                                                      size:
                                                                          25.w,
                                                                    ))
                                                                : SizedBox()
                                                          ])));
                                            });
                                      }
                                    }
                                    return Column(children: <Widget>[
                                      SizedBox(
                                        height: 150.h,
                                      ),
                                      Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                          //backgroundColor: Colors.black,
                                        ),
                                      )
                                    ]);
                                  }),
                          teamInd == null
                              ? Container(
                                  alignment: Alignment.center,
                                  width: ScreenUtil().setWidth(280),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 40.w),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.lightBlue,
                                      Colors.green,
                                      Colors.blue[700]
                                    ]),
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(30)),
                                  ),
                                  padding: EdgeInsets.all(2.w),
                                  child: Container(
                                      alignment: Alignment.center,
                                      //  width: ScreenUtil().setWidth(200),

                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(30.w),
                                      ),
                                      child: TextField(
                                        controller: pName,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          contentPadding:
                                              EdgeInsets.only(left: 20.w),
                                          hintText: "In Game Name",
                                          focusColor: Colors.black,
                                          filled: true,
                                          fillColor: Colors.black,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                        enabled: true,
                                        style: TextStyle(color: Colors.white),
                                        keyboardType: TextInputType.text,
                                        cursorColor: Colors.white,
                                      )))
                              : Container(),
                          teamInd == null
                              ? Container(
                                  width: 280.w,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      top: 10.h,
                                      bottom: 10.h,
                                      left: 40.w,
                                      right: 40.w),
                                  child: isButtonLoad
                                      ? Text(
                                          'Loading...',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.lightGreenAccent),
                                        )
                                      : ElevatedButton(
                                          style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.green[900]),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.lightGreenAccent)),
                                          child: Text('Create Team'),
                                          onPressed: () async {
                                            if (mounted) {
                                              setState(() {
                                                if (yourGame == null) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          duration: Duration(
                                                              seconds: 2),
                                                          backgroundColor:
                                                              Colors.redAccent,
                                                          content: Text(
                                                            "Select a game first.",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )));
                                                } else if (pName.text.trim() ==
                                                        "" ||
                                                    tName.text.trim() == "") {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          duration: Duration(
                                                              seconds: 2),
                                                          backgroundColor:
                                                              Colors.redAccent,
                                                          content: Text(
                                                              "All fields are required.",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))));
                                                } else {
                                                  isButtonLoad = true;
                                                  teamInfo.type = "create";
                                                  teamInfo.userID = userID;
                                                  teamInfo.game = yourGame;
                                                  teamInfo.player = pName.text;
                                                  teamInfo.teamName =
                                                      tName.text;

                                                  teamBloc.eventSink
                                                      .add(teamInfo);
                                                  isToRefresh = false;
                                                }
                                              });
                                            }
                                          },
                                        ))
                              : Container(),
                          teamInd == null
                              ? Container(
                                  width: 280.w,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      top: 10.h,
                                      bottom: 10.h,
                                      left: 40.w,
                                      right: 40.w),
                                  child: Text(
                                    "OR",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24.sp),
                                  ))
                              : Container(),
                          teamInd == null
                              ? Container(
                                  alignment: Alignment.center,
                                  width: ScreenUtil().setWidth(280),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 40.w),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.lightBlue,
                                      Colors.green,
                                      Colors.blue[700]
                                    ]),
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(30)),
                                  ),
                                  padding: EdgeInsets.all(2.w),
                                  child: Container(
                                      alignment: Alignment.center,
                                      //  width: ScreenUtil().setWidth(200),

                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(30.w),
                                      ),
                                      child: TextField(
                                        controller: tidCon,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          contentPadding:
                                              EdgeInsets.only(left: 20.w),
                                          hintText: "Team ID",
                                          focusColor: Colors.black,
                                          filled: true,
                                          fillColor: Colors.black,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                        enabled: true,
                                        style: TextStyle(color: Colors.white),
                                        keyboardType: TextInputType.text,
                                        cursorColor: Colors.white,
                                      )))
                              : Container(),
                          teamInd == null
                              ? Container(
                                  alignment: Alignment.center,
                                  width: ScreenUtil().setWidth(280),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 40.w),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.lightBlue,
                                      Colors.green,
                                      Colors.blue[700]
                                    ]),
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(30)),
                                  ),
                                  padding: EdgeInsets.all(2.w),
                                  child: Container(
                                      alignment: Alignment.center,
                                      //  width: ScreenUtil().setWidth(200),

                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(30.w),
                                      ),
                                      child: TextField(
                                        controller: jName,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          contentPadding:
                                              EdgeInsets.only(left: 20.w),
                                          hintText: "In Game Name",
                                          focusColor: Colors.black,
                                          filled: true,
                                          fillColor: Colors.black,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                        enabled: true,
                                        style: TextStyle(color: Colors.white),
                                        keyboardType: TextInputType.text,
                                        cursorColor: Colors.white,
                                      )))
                              : Container(),
                          teamInd == null
                              ? Container(
                                  width: 280.w,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      top: 10.h,
                                      bottom: 10.h,
                                      left: 40.w,
                                      right: 40.w),
                                  child: isButtonLoad
                                      ? Text(
                                          'Loading...',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.lightGreenAccent),
                                        )
                                      : ElevatedButton(
                                          style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.blue[900]),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.lightBlueAccent)),
                                          child: Text('Join Team'),
                                          onPressed: () {
                                            if (mounted) {
                                              setState(() {
                                                if (yourGame == null) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          duration: Duration(
                                                              seconds: 2),
                                                          backgroundColor:
                                                              Colors.redAccent,
                                                          content: Text(
                                                              "Select a game first.",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))));
                                                } else if (jName.text.trim() ==
                                                        "" ||
                                                    tidCon.text.trim() == "") {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          duration: Duration(
                                                              seconds: 2),
                                                          backgroundColor:
                                                              Colors.redAccent,
                                                          content: Text(
                                                              "All fields are required.",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))));
                                                } else {
                                                  if (mounted) {
                                                    setState(() {
                                                      isButtonLoad = true;
                                                      isTeamName = "gTeam";
                                                      teamNameInfo.actions =
                                                          "getteam";
                                                      teamNameInfo.game =
                                                          yourGame;

                                                      teamNameInfo.teamID =
                                                          tidCon.text;
                                                      teamNameBloc.eventSink
                                                          .add(teamNameInfo);
                                                    });
                                                  }
                                                }
                                              });
                                            }
                                          },
                                        ))
                              : Container(),
                          isExit == false
                              ? Container()
                              : GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 80.w, vertical: 10.h),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40.w, vertical: 10.h),
                                    width: 200.w,
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlueAccent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.w))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        FaIcon(
                                          FontAwesomeIcons.copy,
                                          size: 15.w,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Text(
                                          "Copy Team ID",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Clipboard.setData(
                                        ClipboardData(text: curTeamID));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration: Duration(seconds: 2),
                                            backgroundColor:
                                                Colors.lightGreenAccent,
                                            content: Text(
                                              "Team ID Copied",
                                              style: TextStyle(
                                                  color: Colors.green[900]),
                                            )));
                                  },
                                ),
                        ],
                      );
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      //backgroundColor: Colors.black,
                    ),
                  );
                })));
  }
}
