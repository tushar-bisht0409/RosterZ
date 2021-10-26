import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LeaderBoardScreen extends StatefulWidget {
  @override
  _LeaderBoardScreenState createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  var playerTeam;
  var killwin;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black,
          ),
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 50.h,
                color: Colors.black,
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
                        alignment: Alignment.center,
                        //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                        height: 50.h,
                        child: Text(
                          "Leader Board",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w900),
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
                                return StatefulBuilder(
                                    builder: (BuildContext context, setModal) {
                                  return Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.only(
                                        bottom: 220.h, left: 30.w, right: 30.w),
                                    padding: EdgeInsets.only(
                                        top: 20.h,
                                        bottom: 20.h,
                                        left: 20.w,
                                        right: 20.w),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        Text('Filter By :',
                                            style: TextStyle(
                                                color: Colors.lightBlueAccent,
                                                fontSize: 22.sp,
                                                fontWeight: FontWeight.w900)),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Container(
                                            width: ScreenUtil().setWidth(200),
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil()
                                                          .setWidth(30)),
                                              color: Colors.black,
                                            ),
                                            padding: EdgeInsets.only(
                                                left: 20.w, right: 10.w),
                                            child: Center(
                                                child: DropdownButton<String>(
                                              value: playerTeam,
                                              isExpanded: true,
                                              elevation: 0,
                                              icon: Icon(
                                                Icons.arrow_circle_down,
                                                color: Colors.white,
                                              ),
                                              dropdownColor: Colors.lightBlue,
                                              hint: Text(
                                                "Team or Player",
                                                style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontSize: 16.sp,
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
                                                  setModal(() {
                                                    playerTeam = newValue;
                                                  });
                                                }
                                              },
                                              items: [
                                                "Team",
                                                "Player"
                                              ].map<DropdownMenuItem<String>>(
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
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Container(
                                            width: ScreenUtil().setWidth(200),
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil()
                                                          .setWidth(30)),
                                              color: Colors.black,
                                            ),
                                            padding: EdgeInsets.only(
                                                left: 20.w, right: 10.w),
                                            child: Center(
                                                child: DropdownButton<String>(
                                              value: killwin,
                                              isExpanded: true,
                                              elevation: 0,
                                              icon: Icon(
                                                Icons.arrow_circle_down,
                                                color: Colors.white,
                                              ),
                                              dropdownColor: Colors.lightBlue,
                                              hint: Text(
                                                "Wins or Finishes",
                                                style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontSize: 16.sp,
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
                                                  setModal(() {
                                                    killwin = newValue;
                                                  });
                                                }
                                              },
                                              items: [
                                                "Wins",
                                                "Finishes"
                                              ].map<DropdownMenuItem<String>>(
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
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Container(
                                          width: 280.w,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                TextButton(
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: Colors
                                                          .lightBlueAccent,
                                                      fontSize: 16.sp,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    'Apply',
                                                    style: TextStyle(
                                                      color: Colors
                                                          .lightBlueAccent,
                                                      fontSize: 16.sp,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (mounted) {
                                                      setState(() {
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    }
                                                  },
                                                )
                                              ]),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                              });
                        })
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 0.h, horizontal: 5.w),
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.pink[100].withOpacity(0.4),
                      Colors.deepPurple[100].withOpacity(0.4),
                      Colors.lightBlue[100].withOpacity(0.4)
                    ]),
                    borderRadius: BorderRadius.all(Radius.circular(5.h))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 100.w,
                      child: Text(
                        'Rank',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12.sp,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 100.w,
                      alignment: Alignment.center,
                      child: Text(
                        playerTeam == null ? "Team" : playerTeam,
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12.sp,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 100.w,
                      alignment: Alignment.centerRight,
                      child: Text(
                        killwin == null ? "Wins" : killwin,
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12.sp,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (ctx, ind) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 25.w),
                      decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   colors: [
                          //     Colors.deepPurpleAccent,
                          //     Colors.deepPurple
                          //     //  Colors.pink.withOpacity(0.3),
                          //     //Colors.blue.withOpacity(0.3),
                          //   ],
                          // ),
                          color: Colors.white10,
                          borderRadius: BorderRadius.all(Radius.circular(5.h))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 100.w,
                            child: ind < 3
                                ? FaIcon(
                                    FontAwesomeIcons.trophy,
                                    color: ind == 0
                                        ? Colors.amber
                                        : ind == 1
                                            ? Colors.white
                                            : Colors.redAccent,
                                    size: 25.w,
                                  )
                                : Text(
                                    '#${ind + 1}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20.sp,
                                        color: Colors.white),
                                  ),
                          ),
                          Container(
                            width: 100.w,
                            alignment: Alignment.center,
                            child: Text(
                              "SOUL",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12.sp,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            width: 100.w,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '10',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18.sp,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  })
            ],
          )
        ],
      ),
    ));
  }
}
