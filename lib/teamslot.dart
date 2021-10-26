import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rosterz/blocs/tournament_bloc.dart';
import 'package:rosterz/models/tournament_info.dart';

class TeamSlot extends StatefulWidget {
  int ind;
  var tName;
  var tID;
  var uIDs;
  var game;
  TeamSlot(this.ind, this.tName, this.tID, this.uIDs, this.game);
  @override
  _TeamSlotState createState() => _TeamSlotState();
}

class _TeamSlotState extends State<TeamSlot> {
  bool isExpanded = false;
  TournamentBloc teamBloc = TournamentBloc();
  TournamentInfo teamInfo = TournamentInfo();

  // @override
  // void initState() {
  //   super.initState();

  // }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GestureDetector(
        child: Container(
            //  width: 280.w,
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            child: Row(
              children: <Widget>[
                ClipPath(
                    clipper: SkewCut(),
                    child: Container(
                      width: 50.w,
                      height: 30.h,
                      padding: EdgeInsets.only(right: 10.w),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Colors.green[500],
                        Colors.lightGreenAccent,
                      ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
                      child: Text(
                        '${widget.ind}',
                        style: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.w900,
                            fontSize: 16.sp),
                      ),
                    )),
                SizedBox(
                  width: 5.w,
                ),
                Container(
                    width: 260.w,
                    height: 30.h,
                    alignment: Alignment.center,
                    color: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              onPressed: null,
                              icon: FaIcon(
                                FontAwesomeIcons.arrowDown,
                                size: 15.w,
                                color: Colors.transparent,
                              )),
                          Container(
                              width: 200.w - 32.0,
                              alignment: Alignment.center,
                              child: Text(
                                '${widget.tName}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              )),
                          IconButton(
                              onPressed: () {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (mounted) {
                                    setState(() {
                                      if (isExpanded) {
                                        isExpanded = false;
                                      } else {
                                        isExpanded = true;
                                      }
                                    });
                                  }
                                });
                              },
                              icon: FaIcon(
                                isExpanded
                                    ? FontAwesomeIcons.angleDown
                                    : FontAwesomeIcons.angleRight,
                                size: 15.w,
                              ))
                        ])),
              ],
            )),
      ),
      isExpanded
          ? Container(
              width: 260.w,
              color: Colors.black,
              child: StreamBuilder(
                stream: teamBloc.tournamentStream,
                builder: (ctx, snapshot) {
                  teamInfo.actions = "getteam";
                  teamInfo.teamID = widget.tID;
                  teamInfo.game = widget.game;
                  teamBloc.eventSink.add(teamInfo);
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    if (snapshot.data['success']) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              snapshot.data['msz'][0]["playersID"].length,
                          itemBuilder: (ctx, index) {
                            return Container(
                                width: 260.w,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    left: 65.w,
                                    right: 10.w,
                                    top: 2.h,
                                    bottom: 2.h),
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.w)),
                                    gradient: LinearGradient(
                                        colors: widget.uIDs.contains(snapshot.data['msz']
                                                [0]["playersID"][index])
                                            ? [
                                                Colors.green,
                                                Colors.lightGreenAccent
                                              ]
                                            : [Colors.red, Colors.redAccent])),
                                child: Container(
                                    width: 256.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.w)),
                                        color: Colors.black),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 5.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 30.w,
                                          child: Text(
                                            "${index + 1}.",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 12.sp),
                                          ),
                                        ),
                                        Container(
                                          width: 106.w,
                                          child: Text(
                                            snapshot.data['msz'][0]
                                                ["playersName"][index],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 10.sp),
                                          ),
                                        ),
                                      ],
                                    )));
                          });
                    }
                  }

                  return Container(
                      width: 260.w,
                      alignment: Alignment.center,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 50.w,
                            ),
                            Container(
                              width: 150.w - 32.0,
                              alignment: Alignment.center,
                              child: Text(
                                "Loading...",
                                style: TextStyle(
                                    color: Colors.lightGreenAccent,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 10.sp),
                              ),
                            ),
                          ]));
                },
              ),
            )
          : Container()
    ]);
  }
}

class SkewCut extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(15.w, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(SkewCut oldClipper) => false;
}
