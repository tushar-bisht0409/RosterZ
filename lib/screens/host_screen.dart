import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rosterz/blocs/match_bloc.dart';
import 'package:rosterz/models/match_info.dart';

class HostScreen extends StatefulWidget {
  static const routeName = '/host';
  @override
  _HostScreenState createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  List<String> gameList = ["PUBG", "BGMI", "FREEFIRE", "COD", "PUBGLITE"];
  List<String> matchType = ["DAILY", "REWARD"];
  var gameName; // = "PUBG";
  var mType;
  TextEditingController organizer = TextEditingController();
  TextEditingController maxPlayers = TextEditingController();
  TextEditingController minPlayers = TextEditingController();
  TextEditingController maps = TextEditingController();
  TextEditingController slots = TextEditingController();
  TextEditingController idTime = TextEditingController();
  TextEditingController matchTime = TextEditingController();
  TextEditingController entryFee = TextEditingController();
  TextEditingController matchLink = TextEditingController();
  var mDate;
  var mTime;
  var idpassTime;
  MatchBloc registerBloc = MatchBloc();
  MatchInfo matchInfo = MatchInfo();

  @override
  Widget build(BuildContext context) {
    if (mType == 'REWARD') {
      setState(() {
        entryFee.text = '0';
      });
    }
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
              child: Text(
                "Host Match",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600),
              )),
          Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(30),
                  right: ScreenUtil().setWidth(40),
                  left: ScreenUtil().setWidth(40)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Organizer',
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
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(30)),
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
                              controller: organizer,
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
                                hintText: "Org Name",

                                // fillColor: Colors.transparent[100],
                                focusColor: Colors.grey[400],
                                hintStyle: TextStyle(color: Colors.grey[400]),
                              ),
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.text,
                            )))),
                  ])),
          Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(30),
                  right: ScreenUtil().setWidth(40),
                  left: ScreenUtil().setWidth(40)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Game',
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
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(30)),
                        ),
                        padding: EdgeInsets.all(2.w),
                        child: Container(
                            padding: EdgeInsets.only(left: 20.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(30)),
                              color: Colors.black,
                            ),
                            child: Center(
                                child: DropdownButton<String>(
                              value: gameName,
                              isExpanded: true,
                              elevation: 0,
                              icon: Icon(
                                Icons.arrow_circle_down,
                                color: Colors.black,
                              ),
                              dropdownColor: Colors.pink,
                              hint: Text(
                                "Choose Game",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 16.sp,
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              underline: Container(
                                height: 0,
                                color: Colors.black,
                              ),
                              onChanged: (String newValue) {
                                if (mounted) {
                                  setState(() {
                                    gameName = newValue;
                                  });
                                }
                              },
                              items: gameList.map<DropdownMenuItem<String>>(
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
                            )))),
                  ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(30),
                      //  right: ScreenUtil().setWidth(40),
                      left: ScreenUtil().setWidth(40)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Max Players',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                            ),
                            alignment: Alignment.center,
                            width: ScreenUtil().setWidth(120),
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
                                  controller: maxPlayers,
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
                                    contentPadding:
                                        EdgeInsets.only(left: 5.w, right: 5.w),
                                    hintText: "Maximum",

                                    // fillColor: Colors.transparent[100],
                                    focusColor: Colors.grey[400],
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                )))),
                      ])),
              Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(30),
                    right: ScreenUtil().setWidth(40),
                    //   left: ScreenUtil().setWidth(20)
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Min Players',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                            ),
                            alignment: Alignment.center,
                            width: ScreenUtil().setWidth(120),
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
                                  controller: minPlayers,
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
                                    contentPadding:
                                        EdgeInsets.only(left: 5.w, right: 5.w),
                                    hintText: "Minimum",

                                    // fillColor: Colors.transparent[100],
                                    focusColor: Colors.grey[400],
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                )))),
                      ])),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(30),
                      //  right: ScreenUtil().setWidth(40),
                      left: ScreenUtil().setWidth(40)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Map',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                            ),
                            alignment: Alignment.center,
                            width: ScreenUtil().setWidth(120),
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
                                  controller: maps,
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
                                    contentPadding:
                                        EdgeInsets.only(left: 5.w, right: 5.w),
                                    hintText: "Game Map",

                                    // fillColor: Colors.transparent[100],
                                    focusColor: Colors.grey[400],
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.center,
                                )))),
                      ])),
              Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(30),
                    right: ScreenUtil().setWidth(40),
                    //   left: ScreenUtil().setWidth(20)
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Slots',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                            ),
                            alignment: Alignment.center,
                            width: ScreenUtil().setWidth(120),
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
                                  controller: slots,
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
                                    contentPadding:
                                        EdgeInsets.only(left: 5.w, right: 5.w),
                                    hintText: "Slots",

                                    // fillColor: Colors.transparent[100],
                                    focusColor: Colors.grey[400],
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                )))),
                      ])),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(30),
                      //  right: ScreenUtil().setWidth(40),
                      left: ScreenUtil().setWidth(40)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'ID Pass Time',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        GestureDetector(
                          child: Container(
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(10),
                              ),
                              alignment: Alignment.center,
                              width: ScreenUtil().setWidth(120),
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
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 20.w),
                                      child: Text(
                                        idpassTime == null
                                            ? "Select"
                                            : "${idpassTime.hourOfPeriod}:${idpassTime.minute} ${idpassTime.period.toString().substring(10)}",
                                        style: TextStyle(
                                            color: idpassTime == null
                                                ? Colors.grey[400]
                                                : Colors.white,
                                            fontSize: 16.sp),
                                      )))),
                          onTap: () async {
                            TimeOfDay pickTime = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            if (pickTime != null) {
                              if (mounted) {
                                setState(() {
                                  idpassTime = pickTime;
                                });
                              }
                            }
                          },
                        )
                      ])),
              Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(30),
                    right: ScreenUtil().setWidth(40),
                    //   left: ScreenUtil().setWidth(20)
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Match Time',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        GestureDetector(
                          child: Container(
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(10),
                              ),
                              alignment: Alignment.center,
                              width: ScreenUtil().setWidth(120),
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
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 20.w),
                                      child: Text(
                                        mTime == null
                                            ? "Select"
                                            : "${mTime.hourOfPeriod}:${mTime.minute} ${mTime.period.toString().substring(10)},${DateFormat('d MMMM, y').format(mDate).toString()}",
                                        style: TextStyle(
                                            color: mTime == null
                                                ? Colors.grey[400]
                                                : Colors.white,
                                            fontSize: 16.sp),
                                      )))),
                          onTap: () async {
                            DateTime pickDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year),
                                lastDate: DateTime(DateTime.now().year + 1));
                            if (pickDate != null) {
                              if (mounted) {
                                setState(() {
                                  mDate = pickDate;
                                });
                              }
                              TimeOfDay pickTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (pickTime != null) {
                                if (mounted) {
                                  setState(() {
                                    mTime = pickTime;
                                  });
                                }
                              }
                            }
                          },
                        )
                      ])),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(30),
                      //  right: ScreenUtil().setWidth(40),
                      left: ScreenUtil().setWidth(40)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Match Type',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                            ),
                            alignment: Alignment.center,
                            width: ScreenUtil().setWidth(120),
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
                                padding: EdgeInsets.only(left: 20.w),
                                child: Center(
                                    child: DropdownButton<String>(
                                  value: mType,
                                  isExpanded: true,
                                  elevation: 0,
                                  icon: Icon(
                                    Icons.arrow_circle_down,
                                    color: Colors.black,
                                  ),
                                  dropdownColor: Colors.pink,
                                  hint: Text(
                                    "Choose",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  underline: Container(
                                    height: 0,
                                    color: Colors.black,
                                  ),
                                  onChanged: (String newValue) {
                                    if (mounted) {
                                      setState(() {
                                        mType = newValue;
                                      });
                                    }
                                  },
                                  items: matchType
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
                                )))),
                      ])),
              Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(30),
                    right: ScreenUtil().setWidth(40),
                    //   left: ScreenUtil().setWidth(20)
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Entry Fee',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                            ),
                            alignment: Alignment.center,
                            width: ScreenUtil().setWidth(120),
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
                                  enabled: mType == 'REWARD' ? false : true,
                                  controller: entryFee,
                                  decoration: InputDecoration(
                                    prefix: Text("₹",
                                        style: TextStyle(color: Colors.white)),
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
                                    contentPadding:
                                        EdgeInsets.only(left: 5.w, right: 5.w),
                                    hintText: "Entry Fee",

                                    // fillColor: Colors.transparent[100],
                                    focusColor: Colors.grey[400],
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                )))),
                      ])),
            ],
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(30),
                  right: ScreenUtil().setWidth(40),
                  left: ScreenUtil().setWidth(40)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Match Link',
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
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(30)),
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
                              controller: matchLink,
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
                                hintText: "Match Video Link (Optional)",

                                // fillColor: Colors.transparent[100],
                                focusColor: Colors.grey[400],
                                hintStyle: TextStyle(color: Colors.grey[400]),
                              ),
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.text,
                            )))),
                  ])),
          Padding(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(60),
                bottom: 60.h,
                right: ScreenUtil().setWidth(120),
                left: ScreenUtil().setWidth(120)),
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(ScreenUtil().setWidth(30)),
                  color: Colors.pink,
                ),
                child: Center(
                    child: TextButton(
                  child: Text(
                    "Host",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                  onPressed: () {
                    if (organizer.text.trim() == "" ||
                        maxPlayers.text.trim() == "" ||
                        minPlayers.text.trim() == "" ||
                        maps.text.trim() == "" ||
                        slots.text.trim() == "" ||
                        entryFee.text.trim() == "" ||
                        gameName == "" ||
                        idpassTime == null ||
                        mTime == null ||
                        mType == "") {
                      return ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Some Fields Are Empty")));
                    } else {
                      matchInfo.actions = "host";
                      matchInfo.organizer = organizer.text;
                      matchInfo.map = maps.text;
                      matchInfo.maxPlayers = maxPlayers.text;
                      matchInfo.minPlayers = minPlayers.text;
                      matchInfo.totalSlots = slots.text;
                      matchInfo.entryFee = entryFee.text;
                      matchInfo.matchTime =
                          "${mTime.hourOfPeriod}:${mTime.minute} ${mTime.period.toString().substring(10)},${DateFormat('d MMMM, y').format(mDate).toString()}";
                      matchInfo.idTime =
                          "${idpassTime.hourOfPeriod}:${idpassTime.minute} ${idpassTime.period.toString().substring(10)}";

                      matchInfo.game = gameName;
                      matchInfo.matchType = mType;
                      matchInfo.matchLink = matchLink.text;
                      matchInfo.matchID =
                          "$gameName${organizer.text}${DateTime.now()}$mType";
                      registerBloc.eventSink.add(matchInfo);
                      Navigator.of(context).pop();
                    }
                  },
                ))),
          )
        ],
      ),
    ));
  }
}
