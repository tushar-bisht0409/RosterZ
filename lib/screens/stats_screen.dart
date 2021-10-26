import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsScreen extends StatefulWidget {
  static const routeName = '/stats';
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                child: Image.asset(
                  "assets/images/Background.png",
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.8),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              StreamBuilder(
                  //      stream: getBloc.userStream,
                  builder: (ctx, snapshot) {
                return ListView(children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
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
                              "Zenith",
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
                    padding: EdgeInsets.only(
                        left: 5.w, right: 5.w, bottom: 15.h, top: 30.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Card(
                          elevation: 2,
                          margin: EdgeInsets.zero,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.h))),
                          child: Container(
                            height: 65.h,
                            width: 70.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                // gradient: LinearGradient(colors: [
                                //   Colors.pink[100].withOpacity(0.4),
                                //   Colors.deepPurple[100].withOpacity(0.4),
                                //   Colors.lightBlue[100].withOpacity(0.4)
                                // ]),
                                color: Colors.lightBlueAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.h))),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.center,
                                      width: 70.h,
                                      child: Text(
                                        "Games",
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      width: 70.h,
                                      child: Text("5",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400)))
                                ]),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          margin: EdgeInsets.zero,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.h))),
                          child: Container(
                            height: 65.h,
                            width: 70.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                // gradient: LinearGradient(colors: [
                                //   Colors.pink[100].withOpacity(0.4),
                                //   Colors.deepPurple[100].withOpacity(0.4),
                                //   Colors.lightBlue[100].withOpacity(0.4)
                                // ]),
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.h))),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.center,
                                      width: 70.h,
                                      child: Text(
                                        "Wins",
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      width: 70.h,
                                      child: Text("5",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400)))
                                ]),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          margin: EdgeInsets.zero,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.h))),
                          child: Container(
                            height: 65.h,
                            width: 70.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                // gradient: LinearGradient(colors: [
                                //   Colors.pink[100].withOpacity(0.4),
                                //   Colors.deepPurple[100].withOpacity(0.4),
                                //   Colors.lightBlue[100].withOpacity(0.4)
                                // ]),
                                color: Colors.lightGreenAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.h))),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.center,
                                      width: 70.h,
                                      child: Text(
                                        "Finishes",
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      width: 70.h,
                                      child: Text("5",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400)))
                                ]),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          margin: EdgeInsets.zero,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.h))),
                          child: Container(
                            height: 65.h,
                            width: 70.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                // gradient: LinearGradient(colors: [
                                //   Colors.pink[100].withOpacity(0.4),
                                //   Colors.deepPurple[100].withOpacity(0.4),
                                //   Colors.lightBlue[100].withOpacity(0.4)
                                // ]),
                                color: Colors.pink[300],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.h))),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.center,
                                      width: 70.h,
                                      child: Text(
                                        "F/D Ratio",
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      width: 70.h,
                                      child: Text("1",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400)))
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 0.h, horizontal: 5.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
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
                            'Mode',
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
                            'Finishes',
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
                      itemCount: 5,
                      itemBuilder: (ctx, ind) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 5.w),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 25.w),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.pink.withOpacity(0.3),
                                  Colors.blue.withOpacity(0.3),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.h))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 100.w,
                                child: Text(
                                  '#3',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20.sp,
                                      color: Colors.white),
                                ),
                              ),
                              Container(
                                width: 100.w,
                                alignment: Alignment.center,
                                child: Text(
                                  "Classic TPP BGMI Squad Erangle \n10-12-2001",
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
                                  '10',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 18.sp,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                ]);
              })
            ])));
  }
}
