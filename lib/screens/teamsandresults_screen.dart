import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rosterz/teamslot.dart';

class TeamAndResultScreen extends StatefulWidget {
  var uIDs;
  var tournamentTeams;
  var game;
  @override
  _TeamAndResultScreenState createState() => _TeamAndResultScreenState();
}

class _TeamAndResultScreenState extends State<TeamAndResultScreen> {
  var selectedRound;
  var selectedGroup;
  var teamOrresult;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: ListView(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
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
                            "Organizer",
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
                Row(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.only(top: 5.h, left: 40.w, right: 20.w),
                        width: 120.w,
                        child: Text('Round',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300))),
                    Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.only(top: 5.h, left: 40.w, right: 20.w),
                        width: 120.w,
                        child: Text('Group',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300))),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.only(top: 2.h, left: 40.w, right: 20.w),
                        width: 120.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.lightBlue,
                            Colors.blue,
                            Colors.blue[700]
                          ]),
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        padding: EdgeInsets.all(2.w),
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                                top: 5.h, bottom: 5.h, left: 20.w, right: 10.w),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                            child: DropdownButton<String>(
                              value: selectedRound,
                              hint: Text(
                                'Select Round',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              icon: Icon(
                                Icons.arrow_downward_rounded,
                                color: Colors.blue,
                              ),
                              iconSize: 0,
                              elevation: 0,
                              dropdownColor: Colors.lightBlue,
                              style: TextStyle(color: Colors.white),
                              underline: Container(
                                height: 0,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  selectedRound = newValue;
                                });
                              },
                              isExpanded: true,
                              alignment: Alignment.center,
                              items: <String>[
                                '2017',
                                '2018',
                                '2019',
                                '2020',
                                '2021'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ))),
                    Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.only(top: 2.h, left: 40.w, right: 20.w),
                        width: 120.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.lightBlue,
                            Colors.blue,
                            Colors.blue[700]
                          ]),
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        padding: EdgeInsets.all(2.w),
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                                top: 5.h, bottom: 5.h, left: 20.w, right: 10.w),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                            child: DropdownButton<String>(
                              value: selectedGroup,
                              hint: Text(
                                'Select Group',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              icon: Icon(
                                Icons.arrow_downward_rounded,
                                color: Colors.blue,
                              ),
                              iconSize: 0,
                              elevation: 0,
                              dropdownColor: Colors.lightBlue,
                              style: TextStyle(color: Colors.white),
                              underline: Container(
                                height: 0,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  selectedGroup = newValue;
                                });
                              },
                              isExpanded: true,
                              alignment: Alignment.center,
                              items: <String>[
                                '2017',
                                '2018',
                                '2019',
                                '2020',
                                '2021'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ))),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: teamOrresult == "team"
                                      ? [Colors.blue[900], Colors.blueAccent]
                                      : [
                                          Colors.white,
                                          Colors.white,
                                        ]),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.w),
                                  bottomLeft: Radius.circular(30.w))),
                          padding: EdgeInsets.all(0.5.w),
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 30.w),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: teamOrresult == "team"
                                          ? [
                                              Colors.blue[900],
                                              Colors.blueAccent
                                            ]
                                          : [
                                              Colors.black,
                                              Colors.black,
                                            ]),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.w),
                                      bottomLeft: Radius.circular(30.w))),
                              child: Text(
                                'Teams',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: teamOrresult == "team"
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: Colors.white),
                              )),
                        ),
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              teamOrresult = "team";
                            });
                          }
                        }),
                    GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: teamOrresult == "result"
                                      ? [Colors.blue[900], Colors.blueAccent]
                                      : [
                                          Colors.white,
                                          Colors.white,
                                        ]),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30.w),
                                  bottomRight: Radius.circular(30.w))),
                          padding: EdgeInsets.all(0.5.w),
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 30.w),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: teamOrresult == "result"
                                          ? [
                                              Colors.blue[900],
                                              Colors.blueAccent
                                            ]
                                          : [
                                              Colors.black,
                                              Colors.black,
                                            ]),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30.w),
                                      bottomRight: Radius.circular(30.w))),
                              child: Text(
                                'Results',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: teamOrresult == "result"
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: Colors.white),
                              )),
                        ),
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              teamOrresult = "result";
                            });
                          }
                        })
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                StreamBuilder(builder: (ctx, snapTeam) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: 20,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, indTeam) {
                        return TeamSlot(
                            indTeam + 1,
                            widget.tournamentTeams["teams"][indTeam]
                                ["teamName"],
                            widget.tournamentTeams["teams"][indTeam]["teamID"],
                            widget.uIDs,
                            widget.game);
                      });
                }),
                SizedBox(
                  height: 50.h,
                ),
              ],
            )));
  }
}
