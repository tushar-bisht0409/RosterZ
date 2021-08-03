import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/blocs/match_bloc.dart';
import 'package:rosterz/blocs/user_bloc.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/models/match_info.dart';
import 'package:rosterz/models/user_info.dart';
import 'package:rosterz/payment.dart';
import 'package:rosterz/screens/result_screen.dart';

class MatchScreen extends StatefulWidget {
  static const routeName = '/match';
  var matchID;
  var isReward;
  var mInfo;
  MatchScreen(this.matchID, this.isReward, this.mInfo);
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  TextEditingController teamName = TextEditingController();
  TextEditingController playerName = TextEditingController();
  String dropdownValue = "";
  List<String> teamList = [""];
  var teamIDs = {};
  var tokenList = [];
  var match;
  bool isLoading;
  MatchBloc matchBloc = MatchBloc();
  MatchBloc registerBloc = MatchBloc();
  MatchBloc notiBloc = MatchBloc();
  MatchInfo matchInfo = MatchInfo();
  MatchInfo regInfo = MatchInfo();
  MatchInfo notiInfo = MatchInfo();
  UserInfo notiusers = UserInfo();
  UserBloc listBloc = UserBloc();

  bool isRegistered() {
    if (widget.mInfo["registeredBy"] != null) {
      if (widget.mInfo["registeredBy"].contains(userID)) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    notiusers.actions = 'gettokenlist';
    notiusers.userIDs = widget.mInfo['registeredBy'];
    listBloc.eventSink.add(notiusers);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: <Widget>[
                Container(
                  //    height: double.infinity,
                  width: double.infinity,
                  //  color: Colors.black,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.pink,
                    Colors.deepPurple,
                    Colors.lightBlue
                  ])),
                ),
                ListView(
                  //  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 20.w,
                              ),
                              onPressed: () {}),
                          Container(
                              width: 200.w,
                              height: 50.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(30)),
                              ),
                              child: Text(
                                widget.mInfo["organizer"],
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
                    StreamBuilder(
                        stream: listBloc.userStream,
                        builder: (ctx, sss) {
                          if (sss.hasData) {
                            if (sss.data['success']) {
                              tokenList = sss.data['msz'];
                            }
                          }
                          return SizedBox();
                        }),
                    StreamBuilder(
                        stream: notiBloc.matchStream,
                        builder: (ctx, sss) {
                          if (sss.hasData) {
                            if (sss.data['success']) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("ID Pass Sent SuccessFully")));
                              });
                            } else if (sss.data['success'] == false) {
                              sss.data['success'] = null;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("ID Pass Not Sent !!!")));
                              });
                            }
                          }
                          return SizedBox();
                        }),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 20.w),
                      width: double.infinity,
                      // height: 620.h - toppad,
                      child: Column(
                        // physics: ClampingScrollPhysics(),
                        //physics: NeverScrollableScrollPhysics(),
                        //   shrinkWrap: true,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                    text: "\nID Pass At: ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: widget.mInfo["idTime"],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ]),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "\nMatch Time: ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: widget.mInfo["matchTime"],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ]),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                    text: "\nRegistration: ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: widget.mInfo["status"],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ]),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "\nMap: ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: widget.mInfo["map"],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ]),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                    text: "\nTotal Slots: ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: widget.mInfo["totalSlots"],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ]),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "\nmin/max players: ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              "${widget.mInfo["minPlayers"]}/${widget.mInfo["maxPlayers"]}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ]),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                    text: "\nEntry Fee: ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "₹ ${widget.mInfo["entryFee"]}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ]),
                              ),
                              GestureDetector(
                                child: RichText(
                                  text: TextSpan(
                                      text: "\nMatch ID: ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "${widget.mInfo["matchID"]}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(12),
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ]),
                                ),
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: widget.mInfo["matchID"]));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text("Match ID Copied")));
                                },
                              ),
                            ],
                          ),
                          widget.mInfo["userID"] == userID
                              ? Container(
                                  alignment: Alignment.center,
                                  width: ScreenUtil().setWidth(180),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(30)),
                                    color: Colors.black,
                                  ),
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(30),
                                      bottom: 10.h,
                                      right: ScreenUtil().setWidth(100),
                                      left: ScreenUtil().setWidth(100)),
                                  child: Center(
                                      child: TextButton(
                                    child: Text(
                                      "Declare Result",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ResultScreen("make",
                                                      widget.mInfo, "")));
                                    },
                                  )))
                              : SizedBox(),
                          SizedBox(
                            height: 10.h,
                          ),
                          widget.isReward == true
                              ? Center(
                                  child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 30.w),
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Pool Prize:",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  "  ₹ ${widget.mInfo["poolPrize"]}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22.sp,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ]),
                                  ),
                                ))
                              : SizedBox(),
                          Container(
                              //   margin: EdgeInsets.only(top: 30.h),
                              //       height: 1200.h,
                              child: StreamBuilder(
                                  stream: matchBloc.matchStream,
                                  builder: (ctx, snapshot) {
                                    matchInfo.actions = "getteam";
                                    // matchInfo.actions = "getMatch";
                                    // matchInfo.getBy = "matchID";
                                    matchInfo.matchID = "123"; //widget.matchID;
                                    matchBloc.eventSink.add(matchInfo);
                                    if (snapshot.hasData) {
                                      if (snapshot.data["success"] == false) {
                                        return Center(
                                          child: Text("Something Went Wrong"),
                                        );
                                      } else if (snapshot.data["success"]) {
                                        match = snapshot.data["msz"];
                                        var listLen =
                                            snapshot.data["msz"].length;

                                        // match = snapshot.data["msz"][0];
                                        // while (
                                        //     teamIDs.length < match.length + 1) {
                                        //   for (int i = 0;
                                        //       i < match.length;
                                        //       i++) {
                                        //     teamIDs["${match[i]["teamName"]}"] =
                                        //         match[i]["teamID"];
                                        //   }
                                        // }
                                        while (teamList.length <
                                            match.length + 1) {
                                          for (int i = 0;
                                              i < match.length;
                                              i++) {
                                            teamList.add(match[i]["teamName"]);
                                            teamIDs["${match[i]["teamName"]}"] =
                                                match[i]["teamID"];
                                          }
                                        }
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            //  physics: ClampingScrollPhysics(),
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: int.parse(
                                                widget.mInfo["totalSlots"]),
                                            itemBuilder: (ctx, index) {
                                              return GestureDetector(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      //   color: Colors.black54,
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.black,
                                                            Colors.black26,
                                                            Colors.black54,
                                                          ],
                                                          stops: [
                                                            0.5,
                                                            0.8,
                                                            1.0
                                                          ]),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.h))),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5.h,
                                                      horizontal: 20.w),
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 5.h,
                                                      horizontal: 30.w),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 35.h,
                                                  width: 300.w,
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text: "${index + 1}.  ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: index <
                                                                      listLen
                                                                  ? match[index]
                                                                      [
                                                                      "teamName"]
                                                                  : "",
                                                              // text: index <
                                                              //         match["teams"]
                                                              //             .length
                                                              //     ? match["teams"]
                                                              //         [index]
                                                              //     : "",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              )),
                                                        ]),
                                                  ),
                                                ),
                                                onTap: () {},
                                              );
                                            });
                                      }
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                        //backgroundColor: Colors.black,
                                      ),
                                    );
                                  }))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    )
                  ],
                ),
                Positioned(
                  bottom: 0.h,
                  //  left: 180.w - 40.w,
                  child: Container(
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setHeight(10),
                        //    right: ScreenUtil().setWidth(115),
                        //  left: ScreenUtil().setWidth(115)
                      ),
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(360),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.pink,
                          Colors.deepPurple,
                          Colors.lightBlue
                        ]),
                      ),
                      padding: EdgeInsets.only(top: 2.w),
                      child: Container(
                          decoration: BoxDecoration(
                            color: widget.mInfo["userID"] == userID
                                ? Colors.black
                                : isRegistered()
                                    ? Colors.deepPurple
                                    : widget.mInfo["teams"].length ==
                                            int.parse(
                                                widget.mInfo["totalSlots"])
                                        ? Colors.red
                                        : Colors.black,
                          ),
                          child: Center(
                              child: widget.mInfo["userID"] == userID
                                  ? TextButton(
                                      onPressed: () {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              isScrollControlled: true,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 20.h,
                                                      horizontal: 20.w),
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.h))),
                                                  margin: EdgeInsets.only(
                                                      bottom: 200.h,
                                                      left: 20.w,
                                                      right: 20.w),
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    children: <Widget>[
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                              top: ScreenUtil()
                                                                  .setHeight(
                                                                      10),
                                                              right: ScreenUtil()
                                                                  .setWidth(40),
                                                              left: ScreenUtil()
                                                                  .setWidth(
                                                                      40)),
                                                          alignment:
                                                              Alignment.center,
                                                          width: ScreenUtil()
                                                              .setWidth(280),
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                                    colors: [
                                                                  Colors.pink,
                                                                  Colors
                                                                      .deepPurple,
                                                                  Colors
                                                                      .lightBlue
                                                                ]),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            30)),
                                                          ),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  2.w),
                                                          child: Container(
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          5.h,
                                                                      horizontal:
                                                                          10.w),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: BorderRadius.circular(
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            30)),
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              child: Center(
                                                                  child: Text(
                                                                widget.mInfo[
                                                                    'organizer'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20.sp,
                                                                    color: Colors
                                                                        .white),
                                                              )))),
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                              top: ScreenUtil()
                                                                  .setHeight(
                                                                      20),
                                                              right:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          40),
                                                              left: ScreenUtil()
                                                                  .setWidth(
                                                                      40)),
                                                          alignment:
                                                              Alignment.center,
                                                          width: ScreenUtil()
                                                              .setWidth(280),
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                                    colors: [
                                                                  Colors.pink,
                                                                  Colors
                                                                      .deepPurple,
                                                                  Colors
                                                                      .lightBlue
                                                                ]),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            10)),
                                                          ),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  2.w),
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: BorderRadius.circular(
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            10)),
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              child: Center(
                                                                  child:
                                                                      TextField(
                                                                controller:
                                                                    playerName,
                                                                maxLines: 6,
                                                                decoration:
                                                                    InputDecoration(
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.w),
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.w),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.w),
                                                                  ),
                                                                  disabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.w),
                                                                  ),
                                                                  errorBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.w),
                                                                  ),
                                                                  focusedErrorBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.w),
                                                                  ),
                                                                  contentPadding: EdgeInsets.only(
                                                                      top: 10.h,
                                                                      bottom:
                                                                          10.h,
                                                                      right:
                                                                          20.w,
                                                                      left:
                                                                          20.w),
                                                                  hintText:
                                                                      "ID Pass and Match Details here.",
                                                                  focusColor:
                                                                      Colors.grey[
                                                                          400],
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          400]),
                                                                ),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .multiline,
                                                              )))),
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width: ScreenUtil()
                                                              .setWidth(80),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            30)),
                                                            color: Colors.pink,
                                                          ),
                                                          margin: EdgeInsets.only(
                                                              top: ScreenUtil()
                                                                  .setHeight(
                                                                      30),
                                                              bottom: 10.h,
                                                              right:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          100),
                                                              left: ScreenUtil()
                                                                  .setWidth(
                                                                      100)),
                                                          child: Center(
                                                              child: TextButton(
                                                                  child: Text(
                                                                    "Send",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    if (tokenList ==
                                                                        []) {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(content: Text("Loading.....")));
                                                                    } else if (playerName
                                                                            .text
                                                                            .trim() ==
                                                                        "") {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(content: Text("Details cannot be empty.")));
                                                                    } else {
                                                                      if (mounted) {
                                                                        setState(
                                                                            () {
                                                                          notiInfo.actions =
                                                                              "sendnotification";
                                                                          notiInfo.title =
                                                                              "ID Pass";
                                                                          notiInfo.body =
                                                                              playerName.text;
                                                                          notiInfo.organizer =
                                                                              widget.mInfo["organizer"];
                                                                          notiInfo.game =
                                                                              widget.mInfo["game"];
                                                                          notiInfo.matchID =
                                                                              widget.mInfo["matchID"];
                                                                          notiInfo.matchIDs =
                                                                              tokenList;
                                                                          notiBloc
                                                                              .eventSink
                                                                              .add(notiInfo);
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        });
                                                                      }
                                                                    }
                                                                  }))),
                                                    ],
                                                  ),
                                                );
                                              });
                                        });
                                      },
                                      child: Text(
                                        "Send ID Password!",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp),
                                      ),
                                    )
                                  : TextButton(
                                      child: Text(
                                        isRegistered()
                                            ? "Already Registered !"
                                            : widget.mInfo["teams"].length ==
                                                    int.parse(widget
                                                        .mInfo["totalSlots"])
                                                ? "Registeration Closed !"
                                                : "Register Now !",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp),
                                      ),
                                      onPressed: isRegistered()
                                          ? null
                                          : widget.mInfo["teams"].length ==
                                                  int.parse(widget
                                                      .mInfo["totalSlots"])
                                              ? null
                                              : widget.isReward == true
                                                  ? () {
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        showModalBottomSheet(
                                                            context: context,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            isScrollControlled:
                                                                true,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StatefulBuilder(builder:
                                                                  (BuildContext
                                                                          context,
                                                                      setModal) {
                                                                return StreamBuilder(
                                                                    stream: registerBloc
                                                                        .matchStream,
                                                                    builder: (ctx,
                                                                        snap) {
                                                                      return Container(
                                                                          padding: EdgeInsets.symmetric(
                                                                              vertical: 20
                                                                                  .h,
                                                                              horizontal: 20
                                                                                  .w),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors
                                                                                  .black,
                                                                              borderRadius: BorderRadius.all(Radius.circular(10
                                                                                  .h))),
                                                                          margin: EdgeInsets.only(
                                                                              bottom: 100.h,
                                                                              left: 20.w,
                                                                              right: 20.w),
                                                                          child: ListView(shrinkWrap: true, children: <Widget>[
                                                                            Padding(
                                                                                padding: EdgeInsets.only(top: ScreenUtil().setHeight(30), right: ScreenUtil().setWidth(40), left: ScreenUtil().setWidth(40)),
                                                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                                                                  Text(
                                                                                    'Create Team',
                                                                                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                                                                  ),
                                                                                  Container(
                                                                                      margin: EdgeInsets.only(
                                                                                        top: ScreenUtil().setHeight(10),
                                                                                      ),
                                                                                      alignment: Alignment.center,
                                                                                      width: ScreenUtil().setWidth(280),
                                                                                      decoration: BoxDecoration(
                                                                                        gradient: LinearGradient(colors: [
                                                                                          Colors.pink,
                                                                                          Colors.deepPurple,
                                                                                          Colors.lightBlue
                                                                                        ]),
                                                                                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
                                                                                      ),
                                                                                      padding: EdgeInsets.all(2.w),
                                                                                      child: Container(
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
                                                                                            color: Colors.black,
                                                                                          ),
                                                                                          child: Center(
                                                                                              child: TextField(
                                                                                            controller: teamName,
                                                                                            decoration: InputDecoration(
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
                                                                                              hintText: "Team Name",

                                                                                              // fillColor: Colors.transparent[100],
                                                                                              focusColor: Colors.grey[400],
                                                                                              hintStyle: TextStyle(color: Colors.grey[400]),
                                                                                            ),
                                                                                            style: TextStyle(color: Colors.white),
                                                                                            keyboardType: TextInputType.text,
                                                                                          )))),
                                                                                ])),
                                                                            teamList == [""]
                                                                                ? SizedBox()
                                                                                : Padding(
                                                                                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(30), right: ScreenUtil().setWidth(40), left: ScreenUtil().setWidth(40)),
                                                                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                                                                      Text(
                                                                                        'Join Team',
                                                                                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                                                                      ),
                                                                                      Container(
                                                                                          margin: EdgeInsets.only(
                                                                                            top: ScreenUtil().setHeight(10),
                                                                                          ),
                                                                                          alignment: Alignment.center,
                                                                                          width: ScreenUtil().setWidth(280),
                                                                                          decoration: BoxDecoration(
                                                                                            gradient: LinearGradient(colors: [
                                                                                              Colors.pink,
                                                                                              Colors.deepPurple,
                                                                                              Colors.lightBlue
                                                                                            ]),
                                                                                            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
                                                                                          ),
                                                                                          padding: EdgeInsets.all(2.w),
                                                                                          child: Container(
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
                                                                                                color: Colors.black,
                                                                                              ),
                                                                                              padding: EdgeInsets.only(left: 20.w),
                                                                                              child: Center(
                                                                                                  child: DropdownButton<String>(
                                                                                                value: dropdownValue,
                                                                                                isExpanded: true,
                                                                                                elevation: 0,
                                                                                                icon: Icon(
                                                                                                  Icons.arrow_circle_down,
                                                                                                  color: Colors.black,
                                                                                                ),
                                                                                                dropdownColor: Colors.pink,
                                                                                                style: const TextStyle(color: Colors.white),
                                                                                                underline: Container(
                                                                                                  height: 0,
                                                                                                  color: Colors.black,
                                                                                                ),
                                                                                                onChanged: (String newValue) {
                                                                                                  if (mounted) {
                                                                                                    setModal(() {
                                                                                                      dropdownValue = newValue;
                                                                                                    });
                                                                                                  }
                                                                                                },
                                                                                                items: teamList.map<DropdownMenuItem<String>>((String value) {
                                                                                                  return DropdownMenuItem<String>(
                                                                                                    value: value,
                                                                                                    child: Text(
                                                                                                      value,
                                                                                                      style: TextStyle(
                                                                                                        color: Colors.white,
                                                                                                        fontSize: 16.sp,
                                                                                                      ),
                                                                                                    ),
                                                                                                  );
                                                                                                }).toList(),
                                                                                              ))))
                                                                                    ])),
                                                                            Padding(
                                                                                padding: EdgeInsets.only(top: ScreenUtil().setHeight(30), right: ScreenUtil().setWidth(40), left: ScreenUtil().setWidth(40)),
                                                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                                                                  Text(
                                                                                    'Player Name',
                                                                                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                                                                  ),
                                                                                  Container(
                                                                                      margin: EdgeInsets.only(
                                                                                        top: ScreenUtil().setHeight(10),
                                                                                      ),
                                                                                      alignment: Alignment.center,
                                                                                      width: ScreenUtil().setWidth(280),
                                                                                      decoration: BoxDecoration(
                                                                                        gradient: LinearGradient(colors: [
                                                                                          Colors.pink,
                                                                                          Colors.deepPurple,
                                                                                          Colors.lightBlue
                                                                                        ]),
                                                                                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
                                                                                      ),
                                                                                      padding: EdgeInsets.all(2.w),
                                                                                      child: Container(
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
                                                                                            color: Colors.black,
                                                                                          ),
                                                                                          child: Center(
                                                                                              child: TextField(
                                                                                            controller: playerName,
                                                                                            decoration: InputDecoration(
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
                                                                                              hintText: "Player Name",

                                                                                              // fillColor: Colors.transparent[100],
                                                                                              focusColor: Colors.grey[400],
                                                                                              hintStyle: TextStyle(color: Colors.grey[400]),
                                                                                            ),
                                                                                            style: TextStyle(color: Colors.white),
                                                                                            keyboardType: TextInputType.text,
                                                                                          )))),
                                                                                ])),
                                                                            Container(
                                                                              alignment: Alignment.center,
                                                                              width: ScreenUtil().setWidth(280),
                                                                              padding: EdgeInsets.only(top: ScreenUtil().setHeight(50), right: ScreenUtil().setWidth(40), left: ScreenUtil().setWidth(40)),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: <Widget>[
                                                                                  Container(
                                                                                      alignment: Alignment.center,
                                                                                      width: ScreenUtil().setWidth(80),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
                                                                                        color: Colors.pink,
                                                                                      ),
                                                                                      child: Center(
                                                                                          child: TextButton(
                                                                                              onPressed: () {
                                                                                                if (mounted) {
                                                                                                  setState(() {
                                                                                                    if (teamName.text.trim() == "" || playerName.text.trim() == "") {
                                                                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Fill all the Fields")));
                                                                                                    } else if (teamList.contains(teamName.text)) {
                                                                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Team Already Exist")));
                                                                                                    } else {
                                                                                                      isLoading = true;
                                                                                                      regInfo.actions = "register";
                                                                                                      regInfo.type = "create";
                                                                                                      regInfo.matchID = "123"; //widget.matchID
                                                                                                      regInfo.player = playerName.text;
                                                                                                      regInfo.teamName = teamName.text;
                                                                                                      regInfo.matchType = "reward";
                                                                                                      regInfo.teamID = "${regInfo.teamName}${DateTime.now()}${regInfo.matchID}";
                                                                                                      widget.mInfo["registeredBy"].add(userID);

                                                                                                      registerBloc.eventSink.add(regInfo);
                                                                                                      Navigator.of(context).pop();
                                                                                                      //  _createRewardedAd();
                                                                                                    }
                                                                                                  });
                                                                                                }
                                                                                              },
                                                                                              child: Text(
                                                                                                "Create",
                                                                                                style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                                                                              )))),
                                                                                  Container(
                                                                                      alignment: Alignment.center,
                                                                                      width: ScreenUtil().setWidth(80),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
                                                                                        color: teamList.length > 1 ? Colors.pink : Colors.black,
                                                                                      ),
                                                                                      child: Center(
                                                                                          child: TextButton(
                                                                                              onPressed: teamList != [""]
                                                                                                  ? () {
                                                                                                      if (mounted) {
                                                                                                        setState(() {
                                                                                                          if (dropdownValue == "" || playerName.text.trim() == "") {
                                                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Fill all the Fields")));
                                                                                                          } else {
                                                                                                            isLoading = true;
                                                                                                            regInfo.actions = "register";
                                                                                                            regInfo.type = "join";
                                                                                                            regInfo.matchID = "123"; //widget.matchID
                                                                                                            regInfo.player = playerName.text;
                                                                                                            regInfo.teamName = dropdownValue;
                                                                                                            regInfo.matchType = "reward";
                                                                                                            regInfo.teamID = teamIDs["$dropdownValue"];
                                                                                                            widget.mInfo["registeredBy"].add(userID);

                                                                                                            registerBloc.eventSink.add(regInfo);
                                                                                                            Navigator.of(context).pop();

                                                                                                            //    _createRewardedAd();
                                                                                                          }
                                                                                                        });
                                                                                                      }
                                                                                                    }
                                                                                                  : null,
                                                                                              child: Text(
                                                                                                "Join",
                                                                                                style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                                                                              ))))
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 20.h,
                                                                            )
                                                                          ]));
                                                                    });
                                                              });
                                                            });
                                                      });
                                                    }
                                                  : () {
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        showModalBottomSheet(
                                                            context: context,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            isScrollControlled:
                                                                true,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StreamBuilder(
                                                                  stream: registerBloc
                                                                      .matchStream,
                                                                  builder: (ctx,
                                                                      snap) {
                                                                    return Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical: 20
                                                                              .h,
                                                                          horizontal:
                                                                              20.w),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .black,
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(10.h))),
                                                                      margin: EdgeInsets.only(
                                                                          bottom: 200
                                                                              .h,
                                                                          left: 20
                                                                              .w,
                                                                          right:
                                                                              20.w),
                                                                      child:
                                                                          ListView(
                                                                        shrinkWrap:
                                                                            true,
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                              margin: EdgeInsets.only(top: ScreenUtil().setHeight(10), right: ScreenUtil().setWidth(40), left: ScreenUtil().setWidth(40)),
                                                                              alignment: Alignment.center,
                                                                              width: ScreenUtil().setWidth(280),
                                                                              decoration: BoxDecoration(
                                                                                gradient: LinearGradient(colors: [
                                                                                  Colors.pink,
                                                                                  Colors.deepPurple,
                                                                                  Colors.lightBlue
                                                                                ]),
                                                                                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
                                                                              ),
                                                                              padding: EdgeInsets.all(2.w),
                                                                              child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  child: Center(
                                                                                      child: TextField(
                                                                                    controller: teamName,
                                                                                    decoration: InputDecoration(
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
                                                                                      hintText: "Team Name",

                                                                                      // fillColor: Colors.transparent[100],
                                                                                      focusColor: Colors.grey[400],
                                                                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                                                                    ),
                                                                                    style: TextStyle(color: Colors.white),
                                                                                    keyboardType: TextInputType.text,
                                                                                  )))),
                                                                          Container(
                                                                              margin: EdgeInsets.only(top: ScreenUtil().setHeight(20), right: ScreenUtil().setWidth(40), left: ScreenUtil().setWidth(40)),
                                                                              alignment: Alignment.center,
                                                                              width: ScreenUtil().setWidth(280),
                                                                              decoration: BoxDecoration(
                                                                                gradient: LinearGradient(colors: [
                                                                                  Colors.pink,
                                                                                  Colors.deepPurple,
                                                                                  Colors.lightBlue
                                                                                ]),
                                                                                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
                                                                              ),
                                                                              padding: EdgeInsets.all(2.w),
                                                                              child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  child: Center(
                                                                                      child: TextField(
                                                                                    controller: playerName,
                                                                                    maxLines: 6,
                                                                                    decoration: InputDecoration(
                                                                                      focusedBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(10.w),
                                                                                      ),
                                                                                      border: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(10.w),
                                                                                      ),
                                                                                      enabledBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(10.w),
                                                                                      ),
                                                                                      disabledBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(10.w),
                                                                                      ),
                                                                                      errorBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(10.w),
                                                                                      ),
                                                                                      focusedErrorBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(10.w),
                                                                                      ),
                                                                                      contentPadding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 20.w),
                                                                                      hintText: "\t\t\t\t\t\t\t\t\t\t(Optional)\nPlayer 1\nPlayer 2\nPlayer 3\nPlayer 4\n......",

                                                                                      // fillColor: Colors.transparent[100],
                                                                                      focusColor: Colors.grey[400],
                                                                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                                                                    ),
                                                                                    style: TextStyle(color: Colors.white),
                                                                                    keyboardType: TextInputType.multiline,
                                                                                  )))),
                                                                          Container(
                                                                              alignment: Alignment.center,
                                                                              width: ScreenUtil().setWidth(80),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
                                                                                color: Colors.pink,
                                                                              ),
                                                                              margin: EdgeInsets.only(top: ScreenUtil().setHeight(30), bottom: 10.h, right: ScreenUtil().setWidth(100), left: ScreenUtil().setWidth(100)),
                                                                              child: Center(
                                                                                  child: TextButton(
                                                                                child: Text(
                                                                                  "Register",
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                                onPressed: () {
                                                                                  if (mounted) {
                                                                                    setState(() {
                                                                                      if (teamName.text.trim() == "") {
                                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Team Name is required")));
                                                                                      } else {
                                                                                        isLoading = true;
                                                                                        regInfo.actions = "register";
                                                                                        regInfo.type = "create";
                                                                                        regInfo.matchID = "123"; //widget.matchID

                                                                                        regInfo.player = playerName.text;
                                                                                        regInfo.teamName = teamName.text;
                                                                                        regInfo.matchType = "daily";
                                                                                        regInfo.teamID = "${regInfo.teamName}${DateTime.now()}${regInfo.matchID}";

                                                                                        widget.mInfo["registeredBy"].add(userID);
                                                                                        if (widget.mInfo["entryFee"] == null || widget.mInfo["entryFee"] == "0" || widget.mInfo["entryFee"] == "null") {
                                                                                          registerBloc.eventSink.add(regInfo);
                                                                                          Navigator.of(context).pop();
                                                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registered Successfully")));
                                                                                        } else {
                                                                                          Navigator.of(context).pop();
                                                                                          showModalBottomSheet(
                                                                                              context: context,
                                                                                              backgroundColor: Colors.transparent,
                                                                                              isScrollControlled: true,
                                                                                              builder: (BuildContext context) {
                                                                                                return Payment('${widget.mInfo["entryFee"]}', regInfo);
                                                                                              });
                                                                                        }
                                                                                      }
                                                                                    });
                                                                                  }
                                                                                },
                                                                              ))),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  });
                                                            });
                                                      });
                                                    })))),
                )
              ],
            )));
  }
}