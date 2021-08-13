import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/screens/allmatch_screen.dart';

class GameScreen extends StatefulWidget {
  static const routeName = '/game';
  var gameName;
  GameScreen(this.gameName);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _controller = new TextEditingController();
  AdmobInterstitial interstitialAd;
  bool noAd = false;
  int adCount = 0;
  String searchType;
  int bannerAdCount = 0;
  int bannerAdFail = 0;
  bool isBanner = false;
  AdmobBanner b1;

  createBannerAd1() {
    b1 = AdmobBanner(
      adUnitId: 'ca-app-pub-7072052726974940/5488771146',
      adSize: AdmobBannerSize.BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        switch (event) {
          case AdmobAdEvent.loaded:
            print('New Admob Ad loaded!');
            if (mounted) {
              setState(() {
                bannerAdCount++;
                isBanner = true;
              });
            }
            break;
          case AdmobAdEvent.opened:
            print('Admob Ad opened!');
            break;
          case AdmobAdEvent.closed:
            print('Admob Ad closed!');
            break;
          case AdmobAdEvent.failedToLoad:
            print('Admob failed to load. :(');
            if (bannerAdFail < 2) {
              if (mounted) {
                setState(() {
                  bannerAdFail++;
                  createBannerAd1();
                });
              }
            } else {
              isBanner = true;
            }
            break;
          case AdmobAdEvent.clicked:
            print('Admob Ad Clicked');
            break;
          case AdmobAdEvent.completed:
            print('Admob Ad Completed');
            break;
          case AdmobAdEvent.impression:
            print('Admob Ad Impression');
            break;
          case AdmobAdEvent.leftApplication:
            break;
          case AdmobAdEvent.started:
            print('Admob Ad Started');
            break;
          case AdmobAdEvent.rewarded:
            print('Admob Ad Rewarded');
            break;
          default:
            print("ggg");
        }
      },
      onBannerCreated: (AdmobBannerController controller) {
        // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
        // Normally you don't need to worry about disposing this yourself, it's handled.
        // If you need direct access to dispose, this is your guy!
        // controller.dispose();
      },
    );
  }

  createAd() {
    interstitialAd = AdmobInterstitial(
      adUnitId: 'ca-app-pub-7072052726974940/3537680635',
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        switch (event) {
          case AdmobAdEvent.loaded:
            print('New Admob Ad loaded!');

            break;
          case AdmobAdEvent.opened:
            print('Admob Ad opened!');
            break;
          case AdmobAdEvent.closed:
            print('Admob Ad closed!');
            interstitialAd.load();
            if (searchType == 'matchID') {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AllMatchScreen(
                      widget.gameName, "", "matchID", _controller.text, "")));
            } else if (searchType == 'organizer') {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AllMatchScreen(
                      widget.gameName, "", "organizer", "", _controller.text)));
            } else if (searchType == 'game') {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      AllMatchScreen(_controller.text, "", "game", "", "")));
            }
            break;
          case AdmobAdEvent.failedToLoad:
            print('Admob failed to load. :(');
            if (mounted) {
              setState(() {
                adCount++;
              });
            }
            if (adCount < 4) {
              createAd();
            } else {
              if (mounted) {
                setState(() {
                  noAd = true;
                });
              }
            }
            break;
          case AdmobAdEvent.clicked:
            print('Admob Ad Clicked');
            break;
          case AdmobAdEvent.completed:
            print('Admob Ad Completed');
            break;
          case AdmobAdEvent.impression:
            print('Admob Ad Impression');
            break;
          case AdmobAdEvent.leftApplication:
            break;
          case AdmobAdEvent.started:
            print('Admob Ad Started');
            break;
          case AdmobAdEvent.rewarded:
            print('Admob Ad Rewarded');
            break;
          default:
            print("ggg");
        }
      },
    );
    interstitialAd.load();
  }

  @override
  void initState() {
    super.initState();
    createAd();
    createBannerAd1();
  }

  @override
  Widget build(BuildContext context) {
    print(" ww $bannerAdFail");
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return SafeArea(
        child: Scaffold(
      body: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
        ),
        ListView(
          children: <Widget>[
            // Container(
            //   child: AdmobBanner(
            //     adUnitId: 'ca-app-pub-7072052726974940/5488771146',
            //     adSize: AdmobBannerSize.BANNER,
            //     listener: (AdmobAdEvent event, Map<String, dynamic> args) {
            //       switch (event) {
            //         case AdmobAdEvent.loaded:
            //           print('New Admob Ad loaded!');

            //           break;
            //         case AdmobAdEvent.opened:
            //           print('Admob Ad opened!');
            //           break;
            //         case AdmobAdEvent.closed:
            //           print('Admob Ad closed!');
            //           break;
            //         case AdmobAdEvent.failedToLoad:
            //           print('Admob failed to load. :(');
            //           break;
            //         case AdmobAdEvent.clicked:
            //           print('Admob Ad Clicked');
            //           break;
            //         case AdmobAdEvent.completed:
            //           print('Admob Ad Completed');
            //           break;
            //         case AdmobAdEvent.impression:
            //           print('Admob Ad Impression');
            //           break;
            //         case AdmobAdEvent.leftApplication:
            //           break;
            //         case AdmobAdEvent.started:
            //           print('Admob Ad Started');
            //           break;
            //         case AdmobAdEvent.rewarded:
            //           print('Admob Ad Rewarded');
            //           break;
            //         default:
            //           print("ggg");
            //       }
            //     },
            //     onBannerCreated: (AdmobBannerController controller) {
            //       // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
            //       // Normally you don't need to worry about disposing this yourself, it's handled.
            //       // If you need direct access to dispose, this is your guy!
            //       // controller.dispose();
            //     },
            //   ),
            // ),
            Container(
              alignment: Alignment.topCenter,
              //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
              width: 360.w,
              height: 75.h,
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
                  GestureDetector(
                      child: Container(
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(200),
                          height: 50.h,
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
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.deepPurple[300],
                                    size: 20.w,
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
                                  hintText: "MatchID",

                                  // fillColor: Colors.transparent[100],
                                  focusColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                                enabled: false,
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.white,
                              )))),
                      onTap: () {
                        if (isBanner) {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Container(
                                  color: Colors.deepPurple[900],
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
                                      Text('Search By :-',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Container(
                                          alignment: Alignment.center,
                                          width: ScreenUtil().setWidth(200),
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                ScreenUtil().setWidth(30)),
                                          ),
                                          padding: EdgeInsets.all(2.w),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ScreenUtil()
                                                            .setWidth(30)),
                                                color: Colors.black,
                                              ),
                                              child: Center(
                                                  child: TextField(
                                                controller: _controller,
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: Colors.white,
                                                    size: 20.w,
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.w),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.w),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.w),
                                                  ),
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.w),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.w),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.w),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 20.w),
                                                  hintText: "Type Here",

                                                  // fillColor: Colors.transparent[100],
                                                  focusColor: Colors.white,
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey[400]),
                                                ),
                                                style: TextStyle(
                                                    color: Colors.white),
                                                keyboardType:
                                                    TextInputType.text,
                                                cursorColor: Colors.white,
                                              )))),
                                      SizedBox(
                                        height: 40.h,
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
                                                  color: Colors.lightGreen,
                                                ),
                                                Text('MatchID',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              ]),
                                              onTap: () async {
                                                if (mounted) {
                                                  setState(() {
                                                    searchType = 'matchID';
                                                  });
                                                  if (noAd) {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                AllMatchScreen(
                                                                    widget
                                                                        .gameName,
                                                                    "",
                                                                    "matchID",
                                                                    _controller
                                                                        .text,
                                                                    "")));
                                                  } else {
                                                    if (await interstitialAd
                                                        .isLoaded) {
                                                      interstitialAd.show();
                                                    } else {
                                                      ScaffoldMessenger
                                                              .of(context)
                                                          .showSnackBar(SnackBar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .deepPurple,
                                                              content: Text(
                                                                  "Loading...")));
                                                    }
                                                  }
                                                }
                                              },
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
                                              onTap: () async {
                                                if (mounted) {
                                                  setState(() {
                                                    searchType = 'organizer';
                                                  });
                                                  if (noAd) {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                AllMatchScreen(
                                                                    widget
                                                                        .gameName,
                                                                    "",
                                                                    "organizer",
                                                                    "",
                                                                    _controller
                                                                        .text)));
                                                  } else {
                                                    if (await interstitialAd
                                                        .isLoaded) {
                                                      interstitialAd.show();
                                                    } else {
                                                      ScaffoldMessenger
                                                              .of(context)
                                                          .showSnackBar(SnackBar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .deepPurple,
                                                              content: Text(
                                                                  "Loading...")));
                                                    }
                                                  }
                                                }
                                              },
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
                                              onTap: () async {
                                                if (mounted) {
                                                  setState(() {
                                                    searchType = 'game';
                                                  });
                                                  if (noAd) {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                AllMatchScreen(
                                                                    _controller
                                                                        .text,
                                                                    "",
                                                                    "game",
                                                                    "",
                                                                    "")));
                                                  } else {
                                                    if (await interstitialAd
                                                        .isLoaded) {
                                                      interstitialAd.show();
                                                    } else {
                                                      ScaffoldMessenger
                                                              .of(context)
                                                          .showSnackBar(SnackBar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .deepPurple,
                                                              content: Text(
                                                                  "Loading...")));
                                                    }
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                    ],
                                  ),
                                );
                              });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.deepPurple,
                              content:
                                  Text("Wait for Few seconds ..... Loading")));
                        }
                      }),
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
            Center(
                child: Text(
              widget.gameName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600),
            )),
            SizedBox(
              height: 10.h,
            ),
            Container(child: b1),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              width: double.infinity,
              //   height: 620.h - toppad - 30.sp, //- bottompad,
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.pink,
                          Colors.deepPurple,
                          Colors.lightBlue
                        ]),
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(20)),
                      ),
                      padding: EdgeInsets.all(2.w),
                      child: Container(
                          width: ScreenUtil().setWidth(320),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(20)),
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 20.w),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Daily Matches",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "\nDescription : ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "Join/Host the macthes here.\n",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(14),
                                            fontWeight: FontWeight.w600,
                                          )),
                                      TextSpan(
                                          text:
                                              "No reward is given by the app for these matches.",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(14),
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ]),
                              ),
                              TextButton(
                                  onPressed: () {
                                    if (isBanner) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  AllMatchScreen(
                                                      widget.gameName,
                                                      "daily",
                                                      "game",
                                                      "",
                                                      "")));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor:
                                                  Colors.deepPurple,
                                              content: Text(
                                                  "Wait for Few seconds ..... Loading")));
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 25.h),
                                    decoration: BoxDecoration(
                                        color: Colors.pink,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.h))),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 20.w),
                                    child: Text(
                                      "Let's Go",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ))
                            ],
                          ))),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(child: b1),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.pink,
                          Colors.deepPurple,
                          Colors.lightBlue
                        ]),
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(20)),
                      ),
                      padding: EdgeInsets.all(2.w),
                      child: Container(
                          width: ScreenUtil().setWidth(320),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(20)),
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 20.w),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Reward Matches",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "\nDescription : ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "Join/Host the macthes here.\n",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(14),
                                            fontWeight: FontWeight.w600,
                                          )),
                                      TextSpan(
                                          text:
                                              "Reward is given by the app for these matches.",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(14),
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ]),
                              ),
                              TextButton(
                                  onPressed: () {
                                    if (isBanner) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  AllMatchScreen(
                                                      widget.gameName,
                                                      "reward",
                                                      "game",
                                                      "",
                                                      "")));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor:
                                                  Colors.deepPurple,
                                              content: Text(
                                                  "Wait for Few seconds ..... Loading")));
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 25.h),
                                    decoration: BoxDecoration(
                                        color: Colors.pink,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.h))),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 20.w),
                                    child: Text(
                                      "Let's Go",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ))
                            ],
                          ))),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    child: AdmobBanner(
                      adUnitId: 'ca-app-pub-7072052726974940/5488771146',
                      adSize: AdmobBannerSize.BANNER,
                      listener:
                          (AdmobAdEvent event, Map<String, dynamic> args) {
                        switch (event) {
                          case AdmobAdEvent.loaded:
                            print('New Admob Ad loaded!');

                            break;
                          case AdmobAdEvent.opened:
                            print('Admob Ad opened!');
                            break;
                          case AdmobAdEvent.closed:
                            print('Admob Ad closed!');
                            break;
                          case AdmobAdEvent.failedToLoad:
                            print('Admob failed to load. :(');
                            break;
                          case AdmobAdEvent.clicked:
                            print('Admob Ad Clicked');
                            break;
                          case AdmobAdEvent.completed:
                            print('Admob Ad Completed');
                            break;
                          case AdmobAdEvent.impression:
                            print('Admob Ad Impression');
                            break;
                          case AdmobAdEvent.leftApplication:
                            break;
                          case AdmobAdEvent.started:
                            print('Admob Ad Started');
                            break;
                          case AdmobAdEvent.rewarded:
                            print('Admob Ad Rewarded');
                            break;
                          default:
                            print("ggg");
                        }
                      },
                      onBannerCreated: (AdmobBannerController controller) {
                        // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                        // Normally you don't need to worry about disposing this yourself, it's handled.
                        // If you need direct access to dispose, this is your guy!
                        // controller.dispose();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.pink,
                          Colors.deepPurple,
                          Colors.lightBlue
                        ]),
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(20)),
                      ),
                      padding: EdgeInsets.all(2.w),
                      child: Container(
                          width: ScreenUtil().setWidth(320),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(20)),
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 20.w),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Tournaments",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              Icon(
                                Icons.lock,
                                size: 40.h,
                                color: Colors.deepPurple[300],
                              )
                            ],
                          )))
                ],
              ),
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          child: Container(child: b1),
        )
      ]),
    ));
  }
}
