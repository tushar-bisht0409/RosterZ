import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/blocs/match_bloc.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/models/match_info.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
    matchInfo.getBy = "game";
    //matchInfo.game = widget.gameName;
    // matchBloc.eventSink.add(matchInfo);
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
                      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                      width: ScreenUtil().setWidth(200),
                      height: 50.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(30)),
                        color: Colors.black87,
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20.w,
                          ),
                          contentPadding: EdgeInsets.only(left: 20.w),
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
                          hintText: "MatchID",

                          // fillColor: Colors.transparent[100],
                          focusColor: Colors.grey[400],
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.white,
                      )),
                  IconButton(
                      icon: Icon(
                        Icons.filter_alt_rounded,
                        color: Colors.white,
                        size: 20.w,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Container(
                                color: Colors.black,
                                margin: EdgeInsets.only(
                                    top: 270.h,
                                    bottom: 270.h,
                                    left: 30.w,
                                    right: 30.w),
                                padding: EdgeInsets.only(
                                    top: 20.h,
                                    bottom: 20.h,
                                    left: 20.w,
                                    right: 20.w),
                                child: Column(
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
                                      width: 280.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          GestureDetector(
                                            child: Column(children: <Widget>[
                                              Icon(
                                                Icons.text_format_rounded,
                                                color: Colors.deepPurple[300],
                                              ),
                                              Text('MatchID',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ]),
                                            onTap: () {},
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
                                            onTap: () {},
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
                                            onTap: () {},
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      })
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
                          // if (snapshot.data["msz"][i]["matchType"] ==
                          //     widget.category) {
                          //   allMatch.add(snapshot.data["msz"][i]);
                          // }
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
                                  // if (widget.category == "daily") {
                                  //   Navigator.of(context).push(
                                  //       MaterialPageRoute(
                                  //           builder: (BuildContext context) =>
                                  //               MatchScreen("matchID", false,
                                  //                   allMatch[index])));
                                  // } else if (widget.category == "reward") {
                                  //   Navigator.of(context).push(
                                  //       MaterialPageRoute(
                                  //           builder: (BuildContext context) =>
                                  //               MatchScreen("matchID", true,
                                  //                   allMatch[index])));
                                  // }
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
