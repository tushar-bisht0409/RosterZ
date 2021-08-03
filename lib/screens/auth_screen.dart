import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/blocs/auth_bloc.dart';
import 'package:rosterz/models/user_info.dart';
import 'package:rosterz/screens/home_screen.dart';

enum AuthMode { Login, Signup, Forgot }
AuthMode authMode = AuthMode.Login;

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController phoneNo = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  String countryCode = "";
  var _isLoading = false;
  UserInfo userInfo = UserInfo();
  final authBloc = AuthBloc();

  void authChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          if (authMode == AuthMode.Signup) {
            authMode = AuthMode.Login;
          } else if (authMode == AuthMode.Login) {
            authMode = AuthMode.Signup;
          }
        });
      }
    });
  }

  void showCode() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          if (phoneNo.text.length > 0)
            countryCode = "+91";
          else {
            countryCode = "";
          }
        });
      }
    });
  }

  void submmit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isLoading = true;
          userInfo.phone = phoneNo.text;
          userInfo.password = password.text;
          if (phoneNo.text.length != 10) {
            return snackBar("Type a valid Phone number.");
          } else if (authMode == AuthMode.Signup &&
              confirmPassword.text != password.text) {
            confirmPassword.text = "";
            return snackBar("Password not confirmed.");
          } else if (password.text.trim() == "") {
            return snackBar("Password can't be Empty.");
          } else {
            authBloc.eventSink.add(userInfo);
          }
        });
      }
    });
  }

  void snackBar(String str) {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(str),
      backgroundColor: Colors.deepPurple,
    ));
  }

  void dialogueBox(String str) {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue,
        title: Text(
          'An Error Occurred!',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "$str.",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Ok',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: <Widget>[
              Container(
                height: 690.h,
                width: 360.w,
                alignment: Alignment.topCenter,
                child: Container(
                  height: 300.h,
                  width: 360.h,
                  child: Image.network(
                    "https://www.99images.com/download-image/979126/1080x2340",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 690.h,
                width: 360.w,
                decoration: BoxDecoration(
                    // image: DecorationImage(
                    //     image: NetworkImage(
                    //       "https://www.99images.com/download-image/979126/1080x2340",
                    //     ),
                    //     //   fit: BoxFit.cover,
                    //     colorFilter:
                    //         ColorFilter.mode(Colors.black54, BlendMode.dstATop))
                    ),
                child: ListView(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(320),
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
                                  controller: phoneNo,
                                  onChanged: (value) {
                                    showCode();
                                  },
                                  decoration: InputDecoration(
                                    prefix: Text(
                                      countryCode,
                                      style: TextStyle(color: Colors.white),
                                    ),
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
                                    hintText: "Phone No.",
                                    // fillColor: Colors.transparent[100],
                                    focusColor: Colors.grey[400],
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                ))))),
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
                                  obscureText: true,
                                  controller: password,
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
                                    hintText: "Password",

                                    // fillColor: Colors.transparent[100],
                                    focusColor: Colors.grey[400],
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.text,
                                ))))),
                    authMode == AuthMode.Login
                        ? SizedBox()
                        : Padding(
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
                                      obscureText: true,
                                      controller: confirmPassword,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.w),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.w),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.w),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.w),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.w),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.w),
                                        ),

                                        contentPadding:
                                            EdgeInsets.only(left: 20.w),
                                        hintText: "Confirm Password",
                                        // fillColor: Colors.transparent[100],
                                        focusColor: Colors.grey[400],
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                      ),
                                      style: TextStyle(color: Colors.white),
                                      keyboardType: TextInputType.text,
                                    ))))),
                    StreamBuilder(
                        stream: authBloc.authStream,
                        builder: (ctx, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data["success"] == false) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                dialogueBox(snapshot.data["msz"]);
                                // snackBar(snapshot.data["msz"]);
                                snapshot.data["success"] = null;
                              });
                            } else if (snapshot.data["success"] == true) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                snapshot.data["success"] = null;

                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HomeScreen()));
                              });
                            }
                          }
                          if (_isLoading) {
                            return Container(
                                padding: EdgeInsets.only(top: 30.h),
                                alignment: Alignment.center,
                                child: CircularProgressIndicator());
                          }
                          return Column(children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(40),
                                    right: ScreenUtil().setWidth(115),
                                    left: ScreenUtil().setWidth(115)),
                                child: Container(
                                    alignment: Alignment.center,
                                    width: ScreenUtil().setWidth(80),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(30)),
                                      color: Colors.pink,
                                    ),
                                    child: Center(
                                        child: TextButton(
                                      child: Text(
                                        authMode == AuthMode.Signup
                                            ? "SIGN UP"
                                            : "LOG IN",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: submmit,
                                    )))),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(10),
                                    right: ScreenUtil().setWidth(115),
                                    left: ScreenUtil().setWidth(115)),
                                child: Container(
                                    alignment: Alignment.center,
                                    width: ScreenUtil().setWidth(80),
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
                                            child: TextButton(
                                                child: Text(
                                                  authMode == AuthMode.Signup
                                                      ? "LOG IN"
                                                      : "SIGN UP",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: authChange))))),
                          ]);
                        })
                  ],
                ),
              )
            ],
          )),
    );
  }
}
