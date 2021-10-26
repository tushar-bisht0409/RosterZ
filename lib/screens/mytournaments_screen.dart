import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rosterz/blocs/tournament_bloc.dart';
import 'package:rosterz/models/tournament_info.dart';
import 'package:rosterz/screens/tournamentscreen.dart';

class MyTournamentScreen extends StatefulWidget {
  static const routeName = '/mytournaments';
  @override
  _MyTournamentScreenState createState() => _MyTournamentScreenState();
}

class _MyTournamentScreenState extends State<MyTournamentScreen> {
  TournamentBloc tournamentBloc = TournamentBloc();
  TournamentInfo tournamentInfo = TournamentInfo();
  var allTournaments = [];
  bool imgError = false;

  String getEntry(var ef) {
    return (int.parse(ef) / 100).toString()[0];
  }

  @override
  void initState() {
    super.initState();
    tournamentInfo.actions = "getTournament";
    tournamentInfo.getBy = "userID";
    tournamentBloc.eventSink.add(tournamentInfo);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
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
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setWidth(30)),
                    ),
                    child: Text(
                      "My Tournaments",
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
          StreamBuilder(
              stream: tournamentBloc.tournamentStream,
              builder: (ctx, snapshot) {
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
                                  'No Tournaments',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ))
                          ]),
                        ));
                  } else if (snapshot.data["success"]) {
                    allTournaments = [];
                    allTournaments = snapshot.data["msz"];
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: allTournaments.length,
                        itemBuilder: (ctx, index) {
                          return GestureDetector(
                              child: Card(
                                  color: Colors.white,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 20.w),
                                  elevation: 0,
                                  shadowColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.w))),
                                  child: Container(
                                    width: 320.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.w)),
                                        color: Colors.white10),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 80.h,
                                          height: 80.h,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.h, horizontal: 10.w),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40.h)),
                                              image: DecorationImage(
                                                image: imgError
                                                    ? AssetImage(
                                                        'assets/images/Flames.png')
                                                    : NetworkImage(
                                                        "https://drive.google.com/uc?export=view&id=${allTournaments[index]["logoID"]}",
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
                                          width: 320.w - 100.h - 20.w,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(
                                              left: 10.w,
                                              top: 10.h,
                                              bottom: 10.h),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                width: 320.w - 100.h,
                                                child: Text(
                                                  "${allTournaments[index]["organizer"]}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Container(
                                                  width: 180.w,
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text: "Pool Prize: ",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "${allTournaments[index]["prize"]}",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              )),
                                                        ]),
                                                  )),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Container(
                                                  width: 180.w,
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text: int.parse(
                                                                    "${allTournaments[index]["maxPlayers"]}") >
                                                                1
                                                            ? "Group Event"
                                                            : "Solo Event",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: int.parse(
                                                                          "${allTournaments[index]["maxPlayers"]}") >
                                                                      1
                                                                  ? "(${allTournaments[index]["maxPlayers"]} Players)"
                                                                  : "(1 Player)",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              )),
                                                        ]),
                                                  )),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Container(
                                                  transformAlignment:
                                                      Alignment.center,
                                                  padding: EdgeInsets.only(
                                                      top: 5.h,
                                                      left: 10.w,
                                                      right: 10.w,
                                                      bottom: 5.h),
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 30.w,
                                                      vertical: 5.h),
                                                  // width: 180.w,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20.w)),
                                                      color: Colors.black),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                          getEntry(
                                                              allTournaments[
                                                                      index]
                                                                  ["entryFee"]),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900)),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      Icon(
                                                        Icons.bolt,
                                                        color: Colors
                                                            .lightGreenAccent,
                                                        size: 20.w,
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TournamentScreen(
                                            allTournaments[index]
                                                ["tournamentID"],
                                            allTournaments[index]["game"])));
                              });
                        });
                  }
                }
                return Column(children: <Widget>[
                  SizedBox(
                    height: 250.h,
                  ),
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      //backgroundColor: Colors.black,
                    ),
                  )
                ]);
              })
        ],
      ),
    ));
  }
}
