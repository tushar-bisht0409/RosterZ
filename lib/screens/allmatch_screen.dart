import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/blocs/match_bloc.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/models/match_info.dart';
import 'package:rosterz/screens/match_screen.dart';

class AllMatchScreen extends StatefulWidget {
  static const routeName = '/allmatch';
  var gameName;
  var category;
  var getBy;
  var mID;
  var org;
  AllMatchScreen(this.gameName, this.category, this.getBy, this.mID, this.org);
  @override
  _AllMatchScreenState createState() => _AllMatchScreenState();
}

class _AllMatchScreenState extends State<AllMatchScreen> {
  final _controller = new TextEditingController();
  MatchBloc matchBloc = MatchBloc();
  MatchInfo matchInfo = MatchInfo();
  var allMatch = [];
  String slotsLeft(int ind) {
    var left =
        int.parse(allMatch[ind]["totalSlots"]) - allMatch[ind]["teams"].length;
    return left.toString();
  }

  @override
  void initState() {
    super.initState();
    matchInfo.actions = "getMatch";
    matchInfo.getBy = widget.getBy;
    matchInfo.matchID = widget.mID;
    matchInfo.organizer = widget.org;
    matchInfo.game = widget.gameName;
    matchBloc.eventSink.add(matchInfo);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          //  color: Colors.black,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pink, Colors.deepPurple, Colors.lightBlue])),
        ),
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
              width: 360.w,
              height: 65.h,
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
                      alignment: Alignment.topCenter,
                      //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                      height: 50.h,
                      child: Text(
                        "Join Now !",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600),
                      )),
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
            Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                width: double.infinity,
                height: 625.h - toppad, //- bottompad,
                child: StreamBuilder(
                  stream: matchBloc.matchStream,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data["success"] == false) {
                        return Center(
                          child: Text("No Matches"),
                        );
                      } else if (snapshot.data["success"]) {
                        for (int i = 0; i < snapshot.data["msz"].length; i++) {
                          allMatch = [];
                          if (widget.category == "") {
                            allMatch = snapshot.data["msz"];
                          } else {
                            if (snapshot.data["msz"][i]["matchType"] ==
                                widget.category) {
                              allMatch.add(snapshot.data["msz"][i]);
                            }
                          }
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: allMatch.length,
                            itemBuilder: (ctx, index) {
                              return GestureDetector(
                                child: Container(
                                    margin: EdgeInsets.only(bottom: 10.h),
                                    width: ScreenUtil().setWidth(320),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colors.pink[100].withOpacity(0.4),
                                        Colors.deepPurple[100].withOpacity(0.4),
                                        Colors.lightBlue[100].withOpacity(0.4)
                                      ]),
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(10)),
                                      color: Colors.black,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 20.w),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          allMatch[index]["organizer"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            RichText(
                                              text: TextSpan(
                                                  text: "\nID Pass At: ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: allMatch[index]
                                                            ["idTime"],
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                  ]),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  text: "\nMatch Time: ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: allMatch[index]
                                                            ["matchTime"],
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            RichText(
                                              text: TextSpan(
                                                  text: "\nRegistration: ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: allMatch[index]
                                                            ["status"],
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                  ]),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  text: "\nMap: ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: allMatch[index]
                                                            ["map"],
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            RichText(
                                              text: TextSpan(
                                                  text: "\nTotal Slots: ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: allMatch[index]
                                                            ["totalSlots"],
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                  ]),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  text: "\nSlots Left: ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            "${slotsLeft(index)}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            RichText(
                                              text: TextSpan(
                                                  text: "\nEntry Fee: ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            "₹ ${allMatch[index]["entryFee"]}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                  ]),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  text: "\nmin/max players: ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            "${allMatch[index]["minPlayers"]}/${allMatch[index]["maxPlayers"]}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                              text: "\nMatch ID: ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w500),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        "${allMatch[index]["matchID"]}",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: ScreenUtil()
                                                          .setSp(20),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ]),
                                        ),
                                      ],
                                    )),
                                onTap: () {
                                  if (allMatch[index]["matchType"] == "daily") {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                MatchScreen("matchID", false,
                                                    allMatch[index])));
                                  } else if (allMatch[index]["matchType"] ==
                                      "reward") {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                MatchScreen("matchID", true,
                                                    allMatch[index])));
                                  }
                                },
                              );
                            });
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        //backgroundColor: Colors.black,
                      ),
                    );
                  },
                ))
          ],
        ),
      ]),
    ));
  }
}
