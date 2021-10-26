import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rosterz/blocs/tournament_bloc.dart';
import 'package:rosterz/blocs/user_bloc.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/models/tournament_info.dart';
import 'package:rosterz/models/user_info.dart';
import 'package:rosterz/screens/tournamentteam_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class TournamentScreen extends StatefulWidget {
  static const routeName = '/tournament';
  var tID;
  var gaemName;
  TournamentScreen(this.tID, this.gaemName);
  @override
  _TournamentScreenState createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  TournamentBloc tournamentBloc = TournamentBloc();
  TournamentInfo tournamentInfo = TournamentInfo();
  TournamentBloc getTeamBloc = TournamentBloc();
  TournamentInfo getTeamInfo = TournamentInfo();
  TournamentBloc registerBloc = TournamentBloc();
  TournamentInfo registerInfo = TournamentInfo();
  UserBloc userBloc = UserBloc();
  UserInfo userInfo = UserInfo();
  UserBloc coinsBloc = UserBloc();
  UserInfo coinsInfo = UserInfo();

  bool userRegistered = false;
  bool teamRegistered = false;
  bool gotTeams = false;
  bool gotUser = false;
  bool isRegi = false;
  bool slotsFull = false;
  bool imgError = false;
  var teamIDs = [];
  var totalSlots = "";
  var myTeamID = "";

  var userCoins;
  var myTeam;
  var thisTournaments;
  var boltEntry;

  String getEntry(var ef) {
    boltEntry = (int.parse(ef) / 100).toString()[0];

    return (int.parse(ef) / 100).toString()[0];
  }

  void _showDialog(String dType, String amnt) async {
    if (dType != "pay") {
      if (mounted) {
        setState(() {
          isRegi = true;
        });
      }
    }
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: dType == "pay" ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.w),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: dType == "pay" ? 65.w : 200.w,
                child: Text(
                  dType == "pay" ? 'Use $boltEntry' : "Registered!",
                  style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900),
                )),
            SizedBox(
              width: 0.w,
            ),
            dType == "pay"
                ? Icon(
                    Icons.bolt,
                    size: 25.w,
                    color: Colors.lightGreenAccent,
                  )
                : SizedBox()
          ],
        ),
        content: Text(
          dType == "pay"
              ? "Are you sure to use 1 Z for the registration. You won't be able to cancel it once done."
              : "You have registered for this tournament successfully.",
          style: TextStyle(
              color: dType == "pay" ? Colors.white : Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 16.sp,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              dType == "pay" ? 'Pay' : "Ok",
              style: TextStyle(
                color: dType == "pay"
                    ? Colors.lightGreenAccent
                    : Colors.lightBlueAccent,
                fontSize: 16.sp,
              ),
            ),
            onPressed: () {
              if (mounted) {
                setState(() {
                  if (dType == "pay") {
                    coinsInfo.actions = "updatecoins";
                    coinsInfo.coinAmount = amnt;
                    coinsBloc.eventSink.add(coinsInfo);
                    registerBloc.eventSink.add(registerInfo);
                    Navigator.of(context).pop();
                  } else {
                    userRegistered = true;
                    Navigator.of(context).pop();
                  }
                });
              }
            },
          )
        ],
      ),
    );
  }

  viewTeam() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Stack(
              //  alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                    color: Colors.black87,
                    height: 400.h,
                    child: StreamBuilder(
                        stream: getTeamBloc.tournamentStream,
                        builder: (ctx, sss) {
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
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white,
                                            ),
                                          ))
                                    ]),
                                  ));
                            } else if (sss.data["success"]) {
                              return ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                  Container(
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
                                          top: 30.h,
                                          bottom: 10.h,
                                          left: 90.w,
                                          right: 90.w),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 10.h),
                                      child: Text(
                                        sss.data["msz"][0]["teamName"],
                                        style: TextStyle(
                                            color: Colors.green[900],
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20.sp),
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(bottom: 300.h),
                                      padding: EdgeInsets.only(top: 20.h),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: sss
                                              .data["msz"][0]["playersName"]
                                              .length,
                                          itemBuilder: (ctx, index) {
                                            var isRegTeam = false;
                                            if (thisTournaments["userIDs"] !=
                                                []) {
                                              if (thisTournaments["userIDs"]
                                                  .contains(sss.data["msz"][0]
                                                      ["playersID"][index])) {
                                                isRegTeam = true;
                                              }
                                            }
                                            return Container(
                                                alignment: Alignment.center,
                                                width:
                                                    ScreenUtil().setWidth(280),
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
                                                    alignment: Alignment.center,
                                                    //  width: ScreenUtil().setWidth(200),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.w),
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
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 14.sp,
                                                                            fontWeight: FontWeight.w300)),
                                                                    TextSpan(
                                                                        text: sss.data["msz"][0]["playersID"][index] ==
                                                                                userID
                                                                            ? "(You)"
                                                                            : "",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 10.sp,
                                                                            fontWeight: FontWeight.w800))
                                                                  ]))),
                                                          FaIcon(
                                                            isRegTeam
                                                                ? FontAwesomeIcons
                                                                    .registered
                                                                : Icons
                                                                    .cancel_outlined,
                                                            color: isRegTeam
                                                                ? Colors
                                                                    .lightGreenAccent
                                                                : Colors
                                                                    .redAccent,
                                                            size: 25.w,
                                                          ),
                                                        ])));
                                          }))
                                ],
                              );
                            }
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              //backgroundColor: Colors.black,
                            ),
                          );
                        })),
                Positioned(
                    bottom: 0,
                    child: GestureDetector(
                      child: Container(
                          height: 50.h,
                          width: 360.w,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              bottom: 10.h, top: 0.h, left: 40.w, right: 40.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(30)),
                              color: Colors.black),
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 20.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(30)),
                                color: slotsFull
                                    ? Colors.redAccent
                                    : userRegistered
                                        ? Colors.lightBlueAccent
                                        : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  slotsFull
                                      ? "Slots Full!"
                                      : userRegistered
                                          ? "Registered!"
                                          : "Register Now!",
                                  style: TextStyle(
                                      color: slotsFull
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp),
                                ),
                              ))),
                      onTap: slotsFull
                          ? null
                          : userRegistered
                              ? null
                              : () {
                                  if (userCoins <
                                      int.parse(thisTournaments["entryFee"])) {
                                    return ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 2),
                                            backgroundColor:
                                                Colors.lightGreenAccent,
                                            content: Text(
                                              "You Don't have enough coins. Please Earn Some.",
                                              style: TextStyle(
                                                  color: Colors.green[900]),
                                            )));
                                  }
                                  registerInfo.actions = "register";
                                  registerInfo.tournamentID =
                                      thisTournaments["tournamentID"];
                                  registerInfo.teamID = myTeam["teamID"];
                                  registerInfo.teamName = myTeam["teamName"];
                                  registerInfo.team = {
                                    "teamID": myTeam["teamID"],
                                    "teamName": myTeam["teamName"]
                                  };
                                  if (thisTournaments["teamIDs"] != []) {
                                    if (thisTournaments["teamIDs"]
                                        .contains(myTeam["teamID"])) {
                                      registerInfo.type = "join";
                                    } else {
                                      registerInfo.type = "create";
                                    }
                                  } else {
                                    registerInfo.type = "create";
                                  }
                                  print(registerInfo.type);
                                  Navigator.of(context).pop();
                                  _showDialog(
                                      "pay", "${thisTournaments["entryFee"]}");
                                },
                    )),
                Positioned(
                    top: 0,
                    child: Container(
                      width: 360.w,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(top: 5.h, right: 10.w),
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.cancel_sharp,
                            color: Colors.grey[200],
                            size: 35.w,
                          )),
                    )),
              ]);
        });
  }

  void sFull() {
    if (teamIDs != []) {
      if (teamIDs.length == int.parse(totalSlots)) {
        if (teamIDs.contains(myTeamID) == false) {
          if (mounted) {
            setState(() {
              slotsFull = true;
            });
          }
        }
      }
    }
  }

  String slotsLeft(var len, var list1) {
    var left = int.parse(len) - list1.length;
    return left.toString();
  }

  @override
  void initState() {
    super.initState();
    tournamentInfo.actions = "getTournament";
    tournamentInfo.getBy = "tournamentID";
    tournamentInfo.tournamentID = widget.tID;
    getTeamInfo.actions = "getteam";
    getTeamInfo.userID = userID;
    getTeamInfo.game = widget.gaemName;
    userInfo.actions = "getinfo";
    userInfo.userID = userID;
    userBloc.eventSink.add(userInfo);

    tournamentBloc.eventSink.add(tournamentInfo);
    getTeamBloc.eventSink.add(getTeamInfo);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: StreamBuilder(
                stream: tournamentBloc.tournamentStream,
                builder: (ctx, snapshot) {
                  tournamentBloc.eventSink.add(tournamentInfo);
                  if (snapshot.hasData) {
                    if (snapshot.data["success"] == false) {
                      return Padding(
                          padding: EdgeInsets.only(top: 200.h),
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
                                    'Something Went Wrong!',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ))
                            ]),
                          ));
                    } else if (snapshot.data["success"]) {
                      thisTournaments = snapshot.data["msz"][0];
                      teamIDs = thisTournaments["teamIDs"];
                      totalSlots = thisTournaments["totalSlots"];
                      if (thisTournaments["userIDs"] != []) {
                        if (thisTournaments["userIDs"].contains(userID)) {
                          userRegistered = true;
                        }
                      }
                      return ListView(children: <Widget>[
                        StreamBuilder(
                            stream: registerBloc.tournamentStream,
                            builder: (ctx, regsnap) {
                              if (regsnap.hasData) {
                                if (regsnap.data["success"]) {
                                  if (isRegi == false) {
                                    isRegi = true;
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _showDialog("register", "");
                                    });
                                  }
                                }
                              }
                              return Container();
                            }),
                        Card(
                            elevation: 0,
                            shadowColor: Colors.grey[200],
                            margin: EdgeInsets.zero,
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.w)),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(bottom: 25.h),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.w)),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topCenter,
                                    //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20.h, horizontal: 15.w),
                                    width: 360.w,
                                    height: 70.h,
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(
                                              Icons.arrow_back_ios_rounded,
                                              color: Colors.black,
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil()
                                                          .setWidth(30)),
                                            ),
                                            child: Text(
                                              "${thisTournaments["organizer"]}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24.sp,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                        IconButton(
                                            icon: Icon(
                                              Icons.account_circle_rounded,
                                              color: Colors.black,
                                              size: 20.w,
                                            ),
                                            onPressed: () {
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) => HostProfileScreen(
                                              //             widget.mInfo["userID"])));
                                            })
                                      ],
                                    ),
                                  ),
                                  Row(children: <Widget>[
                                    Container(
                                      width: 80.h,
                                      height: 80.h,
                                      margin: EdgeInsets.only(
                                          left: 30.w, right: 20.w),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40.h)),
                                          image: DecorationImage(
                                            image: imgError
                                                ? AssetImage(
                                                    'assets/images/Flames.png')
                                                : NetworkImage(
                                                    "https://drive.google.com/uc?export=view&id=${thisTournaments["logoID"]}",
                                                  ),
                                            onError: (a, b) {
                                              if (mounted) {
                                                setState(() {
                                                  imgError = true;
                                                });
                                              }
                                            },
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: 0.h, left: 10.w, right: 10.w),
                                      width: 180.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          FaIcon(
                                            FontAwesomeIcons.trophy,
                                            size: 35.h,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text(
                                            "${thisTournaments["prize"]}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 20.h, left: 30.w, right: 30.w),
                                    width: 360.w,
                                    alignment: Alignment.center,
                                    child: RichText(
                                        text: TextSpan(
                                            text: 'Organized By ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400),
                                            children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  "${thisTournaments["organizer"]}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w900))
                                        ])),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(
                                          top: 20.h, left: 30.w, right: 30.w),
                                      width: 360.w,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              width: 150.w,
                                              child: RichText(
                                                  text: TextSpan(
                                                      text: 'Game: ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            "${thisTournaments["game"]}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700))
                                                  ]))),
                                          Container(
                                              width: 150.w,
                                              alignment: Alignment.centerRight,
                                              child: RichText(
                                                  text: TextSpan(
                                                      text: 'Total Slots: ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            "${thisTournaments["totalSlots"]}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700))
                                                  ]))),
                                        ],
                                      )),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 10.h, left: 30.w, right: 30.w),
                                    width: 360.w,
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                        text: TextSpan(
                                            text: int.parse(
                                                        "${thisTournaments["maxPlayers"]}") >
                                                    1
                                                ? "Group Event"
                                                : "Solo Event",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w700),
                                            children: <TextSpan>[
                                          TextSpan(
                                              text: int.parse(
                                                          "${thisTournaments["maxPlayers"]}") >
                                                      1
                                                  ? "(${thisTournaments["maxPlayers"]} Players)"
                                                  : "(1 Player)",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400))
                                        ])),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(
                                          top: 20.h, left: 30.w, right: 30.w),
                                      width: 360.w,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              width: 150.w,
                                              child: RichText(
                                                  text: TextSpan(
                                                      text: 'Start Date: ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            "${thisTournaments["startDate"]}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900))
                                                  ]))),
                                          Container(
                                              width: 150.w,
                                              alignment: Alignment.centerRight,
                                              child: RichText(
                                                  text: TextSpan(
                                                      text: 'End Date: ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            "${thisTournaments["endDate"]}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900))
                                                  ]))),
                                        ],
                                      )),
                                  Container(
                                      padding: EdgeInsets.only(
                                          top: 20.h, left: 30.w, right: 30.w),
                                      width: 360.w,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${thisTournaments["description"]}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400),
                                      )),
                                  Container(
                                      transformAlignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                          top: 5.h,
                                          left: 10.w,
                                          right: 10.w,
                                          bottom: 5.h),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 70.w, vertical: 5.h),
                                      width: 220.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.w)),
                                          color: Colors.black),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          RichText(
                                              text: TextSpan(
                                                  text: 'Entry Fee: ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: getEntry(
                                                        thisTournaments[
                                                            "entryFee"]),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20.sp,
                                                        fontWeight:
                                                            FontWeight.w900))
                                              ])),
                                          Icon(
                                            Icons.bolt,
                                            color: Colors.lightGreenAccent,
                                            size: 30.w,
                                          ),
                                        ],
                                      )),
                                  Container(
                                      padding: EdgeInsets.only(
                                          top: 10.h, left: 30.w, right: 30.w),
                                      width: 360.w,
                                      alignment: Alignment.center,
                                      child: RichText(
                                          text: TextSpan(
                                              text: 'Hurry Up! ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text: slotsLeft(
                                                    thisTournaments[
                                                        "totalSlots"],
                                                    thisTournaments["teams"]),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20.sp,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                            TextSpan(
                                                text: ' Slots Left.',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w400))
                                          ]))),
                                ],
                              ),
                            )),
                        StreamBuilder(
                            stream: getTeamBloc.tournamentStream,
                            builder: (ctx, ssteam) {
                              getTeamBloc.eventSink.add(getTeamInfo);
                              if (ssteam.hasData) {
                                if (ssteam.data["success"]) {
                                  gotTeams = true;
                                  var tin = ssteam.data["msz"].indexWhere(
                                      (element) =>
                                          element["game"] == widget.gaemName);
                                  if (tin == -1) {
                                    return Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 20.h, horizontal: 40.w),
                                      child: Text(
                                        "Please join a team for registration.",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12.sp),
                                      ),
                                    );
                                  } else {
                                    myTeam = ssteam.data["msz"][tin];
                                    myTeamID = myTeam["teamID"];
                                    if (thisTournaments["teamIDs"] != []) {
                                      if (thisTournaments["teamIDs"]
                                          .contains(myTeamID)) {
                                        teamRegistered = true;
                                      }
                                    }
                                    return StreamBuilder(
                                        stream: userBloc.userStream,
                                        builder: (ctx, uuteam) {
                                          userBloc.eventSink.add(userInfo);

                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            sFull();
                                          });
                                          if (uuteam.hasData) {
                                            if (uuteam.data["success"]) {
                                              gotUser = true;
                                              userCoins = uuteam.data["msz"][0]
                                                  ["coins"];
                                              return GestureDetector(
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 10.h,
                                                        top: 20.h,
                                                        left: 40.w,
                                                        right: 40.w),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        30)),
                                                        color: Colors.black),
                                                    child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          30)),
                                                          color: slotsFull
                                                              ? Colors.redAccent
                                                              : userRegistered
                                                                  ? teamRegistered
                                                                      ? Colors
                                                                          .lightGreenAccent
                                                                      : Colors
                                                                          .lightGreenAccent
                                                                  : Colors
                                                                      .white,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            slotsFull
                                                                ? "Slots Full!"
                                                                : userRegistered
                                                                    ? teamRegistered
                                                                        ? "Your Team Registered!"
                                                                        : "Registered!"
                                                                    : "Register Now!",
                                                            style: TextStyle(
                                                                color: slotsFull
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize:
                                                                    16.sp),
                                                          ),
                                                        ))),
                                                onTap: slotsFull
                                                    ? null
                                                    : userRegistered
                                                        ? teamRegistered
                                                            ? viewTeam
                                                            : null
                                                        : () {
                                                            if (userCoins <
                                                                int.parse(
                                                                    thisTournaments[
                                                                        "entryFee"])) {
                                                              return ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(
                                                                      duration: Duration(
                                                                          seconds:
                                                                              2),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .lightGreenAccent,
                                                                      content:
                                                                          Text(
                                                                        "You Don't have enough coins. Please Earn Some.",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.green[900]),
                                                                      )));
                                                            }
                                                            registerInfo
                                                                    .actions =
                                                                "register";
                                                            registerInfo
                                                                    .tournamentID =
                                                                thisTournaments[
                                                                    "tournamentID"];
                                                            registerInfo
                                                                    .teamID =
                                                                myTeam[
                                                                    "teamID"];
                                                            registerInfo
                                                                    .teamName =
                                                                myTeam[
                                                                    "teamName"];
                                                            registerInfo.team =
                                                                {
                                                              "teamID": myTeam[
                                                                  "teamID"],
                                                              "teamName": myTeam[
                                                                  "teamName"]
                                                            };
                                                            if (thisTournaments[
                                                                    "teamIDs"] !=
                                                                []) {
                                                              if (thisTournaments[
                                                                      "teamIDs"]
                                                                  .contains(myTeam[
                                                                      "teamID"])) {
                                                                registerInfo
                                                                        .type =
                                                                    "join";
                                                              } else {
                                                                registerInfo
                                                                        .type =
                                                                    "create";
                                                              }
                                                            } else {
                                                              registerInfo
                                                                      .type =
                                                                  "create";
                                                            }
                                                            print(registerInfo
                                                                .type);
                                                            _showDialog("pay",
                                                                "${thisTournaments["entryFee"]}");
                                                          },
                                              );
                                            }
                                          }
                                          return Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10.h,
                                                horizontal: 40.w),
                                            child: Text(
                                              "Please join a team for registration.",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 12.sp),
                                            ),
                                          );
                                        });
                                  }
                                }
                              }
                              return Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    vertical: 20.h, horizontal: 40.w),
                                child: Text(
                                  "Please join a team for registration.",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12.sp),
                                ),
                              );
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 20.h,
                                  top: 10.h,
                                  left: 40.w,
                                  right: 10.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(30)),
                                  color: Colors.black),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(30)),
                                    color: Colors.white,
                                  ),
                                  child: Container(
                                      width: 120.w,
                                      child: TextButton(
                                          child: Text(
                                            "Road Map",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp),
                                          ),
                                          onPressed: null))),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 20.h,
                                  top: 10.h,
                                  left: 10.w,
                                  right: 40.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(30)),
                                  color: Colors.black),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(30)),
                                    // gradient: LinearGradient(colors: [
                                    //   Colors.pink[100].withOpacity(0.4),
                                    //   Colors.deepPurple[100].withOpacity(0.4),
                                    //   Colors.lightBlue[100].withOpacity(0.4)
                                    // ]),
                                    color: Colors.white,
                                  ),
                                  child: Container(
                                      width: 120.w,
                                      child: TextButton(
                                          child: Text(
                                            "Teams",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp),
                                          ),
                                          onPressed: () {
                                            Navigator
                                                    .of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        TournamentTeamScreen(
                                                            thisTournaments[
                                                                "organizer"],
                                                            thisTournaments[
                                                                "userIDs"],
                                                            thisTournaments[
                                                                "teams"],
                                                            thisTournaments[
                                                                "maxPlayers"],
                                                            thisTournaments[
                                                                "game"])));
                                          }))),
                            ),
                          ],
                        ),
                        Container(
                          width: 360.w,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            bottom: 0.h,
                            top: 10.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                onPressed: () async {
                                  var url = thisTournaments["youtube"];
                                  if (await canLaunch(url))
                                    await launch(url);
                                  else
                                    // can't launch url, there is some error
                                    print('Url Launch Failed');
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.youtube,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  var url = thisTournaments["discord"];
                                  if (await canLaunch(url))
                                    await launch(url);
                                  else
                                    // can't launch url, there is some error
                                    print('Url Launch Failed');
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.discord,
                                  color: Colors.indigo[300],
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  var url = thisTournaments["instagram"];
                                  if (await canLaunch(url))
                                    await launch(url);
                                  else
                                    // can't launch url, there is some error
                                    print('Url Launch Failed');
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.instagram,
                                  color: Colors.pink[400],
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  var url = thisTournaments["facebook"];
                                  if (await canLaunch(url))
                                    await launch(url);
                                  else
                                    // can't launch url, there is some error
                                    print('Url Launch Failed');
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.facebook,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 360.w,
                          margin: EdgeInsets.only(
                              bottom: 0.h, top: 5.h, left: 40.w, right: 40.w),
                          child: Text(
                              "Contact ${thisTournaments["organizer"]} Here!",
                              style: TextStyle(
                                  color: Colors.grey[200], fontSize: 10.sp)),
                        )
                      ]);
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
