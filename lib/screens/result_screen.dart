//import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/blocs/match_bloc.dart';
import 'package:rosterz/blocs/user_bloc.dart';
import 'package:rosterz/models/match_info.dart';
import 'package:rosterz/models/user_info.dart';

class ResultScreen extends StatefulWidget {
  static const routeName = '/result';
  var showmake;
  var mInfo;
  var mID;
  ResultScreen(this.showmake, this.mInfo, this.mID);
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<String> teams = [];
  var dropdownTeam = [];
  var result = [];
  var saveResult = MatchInfo();
  var resultBloc = MatchBloc();
  var isLoading = false;
  var tokenList = [];
  UserInfo notiusers = UserInfo();
  UserBloc listBloc = UserBloc();
  MatchBloc notiBloc = MatchBloc();
  MatchInfo notiInfo = MatchInfo();
  void _showDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Match Status!',
          style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w600),
        ),
        content: Text(
          "Result Declared Successfully",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Ok',
              style: TextStyle(
                color: Colors.pink,
                fontSize: 16.sp,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.showmake == "make") {
      for (int i = 0; i < widget.mInfo['teams'].length; i++) {
        teams.add(widget.mInfo['teams'][i]);
      }
      //    teams = widget.mInfo['teams'];
      notiusers.actions = 'gettokenlist';
      notiusers.userIDs = widget.mInfo['registeredBy'];
      listBloc.eventSink.add(notiusers);
      for (int i = 0; i < teams.length; i++) {
        dropdownTeam.add(null);
        result.add({
          "teamName": "${teams[i]}",
          "points": "",
          "prize": "",
          "gPay": "",
          "position": ""
        });
      }
    } else if (widget.showmake == "show") {
      saveResult.matchID = widget.mID;
      saveResult.actions = "getresult";
      resultBloc.eventSink.add(saveResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: ListView(children: <Widget>[
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
                        child: Text(
                          "Organizer",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600),
                        )),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 20.h,
                          color: Colors.transparent,
                        ),
                        onPressed: () {}),
                  ]),
              widget.showmake == "make"
                  ? StreamBuilder(
                      stream: listBloc.userStream,
                      builder: (ctx, sss) {
                        if (sss.hasData) {
                          if (sss.data['success']) {
                            tokenList = sss.data['msz'];
                          }
                        }
                        return SizedBox();
                      })
                  : SizedBox(),
              widget.showmake == "make"
                  ? Container(
                      alignment: Alignment.centerLeft,
                      //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                      padding:
                          EdgeInsets.symmetric(vertical: 0.h, horizontal: 15.w),
                      width: 360.w,
                      height: 50.h,
                      color: Colors.transparent,
                      child: Text(
                        "Make Result :-",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w300),
                      ))
                  : SizedBox(),
              widget.showmake == "show"
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(5.h))),
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
                      margin:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 30.w),
                      alignment: Alignment.centerLeft,
                      // height: 35.h,
                      width: 300.w,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                alignment: Alignment.center,
                                width: 90.w,
                                child: Text(
                                  "Position",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300),
                                )),
                            Container(
                                alignment: Alignment.center,
                                width: 90.w,
                                child: Text("Team",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(16),
                                      fontWeight: FontWeight.w300,
                                    ))),
                            Container(
                                alignment: Alignment.center,
                                width: 90.w,
                                child: Text("Points",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(16),
                                      fontWeight: FontWeight.w300,
                                    ))),
                          ]))
                  : SizedBox(),
              widget.showmake == "show"
                  ? StreamBuilder(
                      stream: resultBloc.matchStream,
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data["success"]) {
                            print(snapshot.data);
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot
                                    .data["msz"][0]["teamResult"].length,
                                shrinkWrap: true,
                                itemBuilder: (ctx, index) {
                                  int ind = snapshot.data["msz"][0]
                                          ["teamResult"]
                                      .indexWhere((element) =>
                                          int.parse(element["position"]) ==
                                          index);

                                  var tinfo = snapshot.data["msz"][0]
                                      ["teamResult"][ind];
                                  return GestureDetector(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            //   color: Colors.black54,
                                            gradient: LinearGradient(colors: [
                                              Colors.deepPurple,
                                              Colors.black26,
                                              Colors.black54,
                                              Colors.pink
                                            ], stops: [
                                              0.1,
                                              0.4,
                                              0.6,
                                              1.0
                                            ]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.h))),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.h, horizontal: 20.w),
                                        margin: EdgeInsets.symmetric(
                                            vertical: 5.h, horizontal: 30.w),
                                        alignment: Alignment.centerLeft,
                                        // height: 35.h,
                                        width: 300.w,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  alignment: Alignment.center,
                                                  width: 20.w,
                                                  child: Text(
                                                    "${index + 1}.  ",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  )),
                                              Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  width: 120.w,
                                                  child: Text(
                                                      "${tinfo["teamName"]}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: ScreenUtil()
                                                            .setSp(12),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ))),
                                              Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  width: 120.w,
                                                  child:
                                                      Text("${tinfo["points"]}",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(12),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ))),
                                            ])),
                                    onTap: () {
                                      var prizeMoney = tinfo["prize"];
                                      if (prizeMoney == "") {
                                        prizeMoney = "0";
                                      }
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) async {
                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: Colors.black,
                                            title: Text(
                                              'Prize',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            content: Text(
                                              "${tinfo["teamName"]} is awarded with ₹ $prizeMoney .",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text(
                                                  'Ok',
                                                  style: TextStyle(
                                                    color: Colors.pink,
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                    },
                                  );
                                });
                          }
                          return Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 250.h),
                            child: Text(
                              "Result Not Declared",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          );
                        }
                        return Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 250.h),
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.pink)),
                        );
                      })
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: teams.length,
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return Container(
                            decoration: BoxDecoration(
                                //   color: Colors.black54,
                                gradient: LinearGradient(colors: [
                                  Colors.deepPurple,
                                  Colors.black26,
                                  Colors.black54,
                                  Colors.pink
                                ], stops: [
                                  0.1,
                                  0.4,
                                  0.6,
                                  1.0
                                ]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.h))),
                            padding: EdgeInsets.symmetric(
                                vertical: 5.h, horizontal: 10.w),
                            margin: EdgeInsets.symmetric(
                                vertical: 5.h, horizontal: 30.w),
                            alignment: Alignment.centerLeft,
                            height: 35.h,
                            width: 340.w,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  Container(
                                      width: 25.w,
                                      child: Text(
                                        "${index + 1}.  ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700),
                                      )),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Container(
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Center(
                                          child: DropdownButton<String>(
                                        value: dropdownTeam[index],
                                        isExpanded: true,
                                        elevation: 0,
                                        icon: Icon(
                                          Icons.arrow_circle_down,
                                          color: Colors.black,
                                        ),
                                        dropdownColor: Colors.pink,
                                        hint: Text(
                                          "Name",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                        underline: Container(
                                          height: 0,
                                          color: Colors.black,
                                        ),
                                        onChanged: (String newValue) {
                                          if (mounted) {
                                            setState(() {
                                              if (dropdownTeam
                                                      .contains(newValue) &&
                                                  dropdownTeam[index] == null) {
                                                return ScaffoldMessenger
                                                        .of(context)
                                                    .showSnackBar(SnackBar(
                                                        backgroundColor:
                                                            Colors.deepPurple,
                                                        content: Text(
                                                            "Team Already Selected")));
                                              } else if (dropdownTeam[index] !=
                                                  null) {
                                                int ind0 = dropdownTeam
                                                    .indexWhere((element) =>
                                                        element == newValue);
                                                if (ind0 != -1) {
                                                  dropdownTeam[ind0] =
                                                      dropdownTeam[index];
                                                }

                                                int ind1 = result.indexWhere(
                                                    (element) =>
                                                        element["teamName"] ==
                                                        dropdownTeam[index]);
                                                int ind2 = result.indexWhere(
                                                    (element) =>
                                                        element["teamName"] ==
                                                        newValue);
                                                dropdownTeam[index] = newValue;
                                                var tempPrize =
                                                    result[ind1]["prize"];
                                                var tempPoints =
                                                    result[ind1]["points"];
                                                var tempPosition =
                                                    result[ind1]["position"];
                                                result[ind1]["prize"] =
                                                    result[ind2]["prize"];
                                                result[ind1]["points"] =
                                                    result[ind2]["points"];
                                                result[ind1]["position"] =
                                                    result[ind2]["position"];
                                                result[ind2]["prize"] =
                                                    tempPrize;
                                                result[ind2]["points"] =
                                                    tempPoints;
                                                result[ind2]["teamName"] =
                                                    newValue;
                                                result[ind2]["position"] =
                                                    tempPosition;
                                              } else {
                                                dropdownTeam[index] = newValue;
                                                int ind = result.indexWhere(
                                                    (element) =>
                                                        element["teamName"] ==
                                                        newValue);
                                                result[ind]["teamName"] =
                                                    newValue;
                                                result[ind]["position"] =
                                                    "$index";
                                              }
                                            });
                                          }
                                        },
                                        items: teams
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
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
                                      ))),
                                  Container(
                                      width: 70.w,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Center(
                                          child: TextField(
                                        cursorColor: Colors.white,
                                        enabled: dropdownTeam[index] == null
                                            ? false
                                            : true,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.w),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.w),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.w),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent)),
                                          disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.w),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.w),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent)),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.w),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent)),
                                          contentPadding: EdgeInsets.only(
                                              left: 5.w, right: 5.w),
                                          hintText: "Points",

                                          // fillColor: Colors.transparent[100],
                                          focusColor: Colors.white,
                                          hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp),
                                        ),
                                        style: TextStyle(color: Colors.white),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          int ind = result.indexWhere(
                                              (element) =>
                                                  element["teamName"] ==
                                                  dropdownTeam[index]);
                                          result[ind]["points"] = value;
                                        },
                                      ))),
                                  Container(
                                      width: 70.w,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Center(
                                          child: TextField(
                                        cursorColor: Colors.white,
                                        enabled: dropdownTeam[index] == null
                                            ? false
                                            : true,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.w),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.w),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.w),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent)),
                                          disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.w),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.w),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent)),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.w),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent)),
                                          contentPadding: EdgeInsets.only(
                                              left: 5.w, right: 5.w),
                                          hintText: "Prize",
                                          prefix: Text("   ₹",
                                              style: TextStyle(
                                                  color: Colors.white)),

                                          // fillColor: Colors.transparent[100],
                                          focusColor: Colors.white,
                                          hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp),
                                        ),
                                        style: TextStyle(color: Colors.white),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          int ind = result.indexWhere(
                                              (element) =>
                                                  element["teamName"] ==
                                                  dropdownTeam[index]);
                                          result[ind]["prize"] = value;
                                        },
                                      ))),
                                ]));
                      }),
              widget.showmake == "make"
                  ? Container(
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(80),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(30)),
                        color: Colors.pink,
                      ),
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(60),
                          bottom: 20.h,
                          right: ScreenUtil().setWidth(100),
                          left: ScreenUtil().setWidth(100)),
                      child: Center(
                          child: TextButton(
                        child: Text(
                          "Declare Result",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (mounted) {
                            setState(() {
                              isLoading = true;
                              saveResult.actions = "postresult";
                              saveResult.game = "PUBG";
                              saveResult.matchID = "123"; //widget.matchID
                              saveResult.matchType = "daily";
                              saveResult.organizer = "Organizer";
                              saveResult.prizePool = "11";
                              saveResult.result = result;
                              resultBloc.eventSink.add(saveResult);
                              notiInfo.actions = "sendnotification";
                              notiInfo.title = "Result";
                              notiInfo.body =
                                  "Result Declared for Match ${widget.mInfo['matchID']}.";
                              notiInfo.organizer = widget.mInfo["organizer"];
                              notiInfo.game = widget.mInfo["game"];
                              notiInfo.matchID = widget.mInfo["matchID"];
                              notiInfo.matchIDs = tokenList;
                              notiBloc.eventSink.add(notiInfo);
                              //print(result);
                              Navigator.of(context).pop();

                              //    _createRewardedAd();
                            });
                          }
                          _showDialog();
                        },
                      )))
                  : Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(
                          vertical: 30.h, horizontal: 30.w),
                      width: 300.h,
                      child: Text(
                        "Tap on the team to view prize.",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
            ])));
  }
}
