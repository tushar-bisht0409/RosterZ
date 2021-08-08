import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/blocs/user_bloc.dart';
import 'package:rosterz/models/user_info.dart';

class FeedBackScreen extends StatefulWidget {
  static const routeName = '/feedback';
  @override
  _FeedBackScreenState createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  TextEditingController feedback = TextEditingController();
  UserInfo userInfo = UserInfo();
  UserBloc userBloc = UserBloc();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: <Widget>[
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
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                    height: 70.h,
                    color: Colors.transparent,
                    child: Text(
                      "Feedback",
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
          Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(10),
                  right: ScreenUtil().setWidth(40),
                  left: ScreenUtil().setWidth(40)),
              child: Container(
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
                      height: 200.h,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(30)),
                        color: Colors.black,
                      ),
                      child: TextField(
                        maxLines: null,
                        controller: feedback,
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
                          contentPadding: EdgeInsets.only(
                              left: 20.w, right: 20.w, top: 15.h, bottom: 15.h),
                          hintText: "FeedBack",

                          // fillColor: Colors.transparent[100],
                          focusColor: Colors.grey[400],
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.multiline,
                      )))),
          Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(40),
                  right: ScreenUtil().setWidth(115),
                  left: ScreenUtil().setWidth(115)),
              child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(80),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(30)),
                    color: Colors.pink,
                  ),
                  child: Center(
                      child: TextButton(
                    child: Text(
                      "Send",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (feedback.text.trim() != "") {
                        if (mounted) {
                          setState(() {
                            userInfo.actions = "feedback";
                            userInfo.feedback = feedback.text;
                            userBloc.eventSink.add(userInfo);
                            feedback.text = "";
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("FeedBack Sent Successfully"),
                              backgroundColor: Colors.deepPurple,
                            ));
                          });
                        }
                      }
                    },
                  )))),
        ],
      ),
    ));
  }
}
