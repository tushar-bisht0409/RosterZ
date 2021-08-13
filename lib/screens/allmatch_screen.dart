import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/blocs/match_bloc.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/models/match_info.dart';
import 'package:rosterz/screens/match_screen.dart';

class AllMatchScreen extends StatefulWidget {
  static const routeName = '/allmatch';
  var gameName;
  var category;
  var getBy;
  var mID;
  var org;
  AllMatchScreen(this.gameName, this.category, this.getBy, this.mID, this.org);
  @override
  _AllMatchScreenState createState() => _AllMatchScreenState();
}

class _AllMatchScreenState extends State<AllMatchScreen> {
  MatchBloc matchBloc = MatchBloc();
  MatchInfo matchInfo = MatchInfo();
  AdmobInterstitial interstitialAd;
  bool noAd = false;
  int adCount = 0;
  int selectedIndex;
  var allMatch = [];

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
            if (bannerAdFail < 1) {
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

  String slotsLeft(int ind) {
    var left =
        int.parse(allMatch[ind]["totalSlots"]) - allMatch[ind]["teams"].length;
    return left.toString();
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
            if (allMatch[selectedIndex]["matchType"] == "daily") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MatchScreen(
                      allMatch[selectedIndex]['matchID'],
                      false,
                      allMatch[selectedIndex])));
            } else if (allMatch[selectedIndex]["matchType"] == "reward") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MatchScreen(
                      allMatch[selectedIndex]['matchID'],
                      true,
                      allMatch[selectedIndex])));
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
    matchInfo.actions = "getMatch";
    matchInfo.getBy = widget.getBy;
    matchInfo.matchID = widget.mID;
    matchInfo.organizer = widget.org;
    matchInfo.game = widget.gameName;
    matchBloc.eventSink.add(matchInfo);
    createAd();
    createBannerAd1();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return SafeArea(
        child: Scaffold(
      body: Stack(
          //alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              height: double.infinity,
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
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
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
                            "Join Now !",
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
                Container(child: b1),
                Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 60),
                    //height: 625.h - toppad, //- bottompad,
                    child: StreamBuilder(
                      stream: matchBloc.matchStream,
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data["success"] == false) {
                            return Padding(
                                padding: EdgeInsets.only(top: 200.h),
                                child: Center(
                                  child: Column(children: <Widget>[
                                    Icon(
                                      Icons.cancel_rounded,
                                      color: Colors.white,
                                      size: 100.h,
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width: 250.w,
                                        child: Text(
                                          'No Matches',
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
                                        ))
                                  ]),
                                ));
                          } else if (snapshot.data["success"]) {
                            if (widget.category == "") {
                              allMatch = [];
                              allMatch = snapshot.data["msz"];
                            } else {
                              allMatch = [];
                              for (int i = 0;
                                  i < snapshot.data["msz"].length;
                                  i++) {
                                if (snapshot.data["msz"][i]["matchType"] ==
                                    widget.category) {
                                  allMatch.add(snapshot.data["msz"][i]);
                                }
                              }
                            }
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: allMatch.length,
                                itemBuilder: (ctx, index) {
                                  return Column(children: [
                                    GestureDetector(
                                      child: Container(
                                          margin: EdgeInsets.only(bottom: 10.h),
                                          width: ScreenUtil().setWidth(320),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Colors.pink[100].withOpacity(0.4),
                                              Colors.deepPurple[100]
                                                  .withOpacity(0.4),
                                              Colors.lightBlue[100]
                                                  .withOpacity(0.4)
                                            ]),
                                            borderRadius: BorderRadius.circular(
                                                ScreenUtil().setWidth(10)),
                                            color: Colors.black,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h, horizontal: 20.w),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                  alignment: Alignment.center,
                                                  width: 250.w,
                                                  child: Text(
                                                    allMatch[index]
                                                        ["organizer"],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22.sp,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      width: 120.w,
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "\nID Pass At: ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text: allMatch[
                                                                          index]
                                                                      [
                                                                      "idTime"],
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  )),
                                                            ]),
                                                      )),
                                                  Container(
                                                      width: 120.w,
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "\nMatch Time: ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text: allMatch[
                                                                          index]
                                                                      [
                                                                      "matchTime"],
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  )),
                                                            ]),
                                                      )),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      width: 120.w,
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "\nRegistration: ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text: allMatch[
                                                                          index]
                                                                      [
                                                                      "status"],
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  )),
                                                            ]),
                                                      )),
                                                  Container(
                                                      width: 120.w,
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text: "\nMap: ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text: allMatch[
                                                                          index]
                                                                      ["map"],
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  )),
                                                            ]),
                                                      )),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      width: 120.w,
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "\nTotal Slots: ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text: allMatch[
                                                                          index]
                                                                      [
                                                                      "totalSlots"],
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  )),
                                                            ]),
                                                      )),
                                                  Container(
                                                      width: 120.w,
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "\nSlots Left: ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text:
                                                                      "${slotsLeft(index)}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  )),
                                                            ]),
                                                      )),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      width: 120.w,
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "\nEntry Fee: ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text:
                                                                      "₹ ${allMatch[index]["entryFee"]}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  )),
                                                            ]),
                                                      )),
                                                  Container(
                                                      width: 120.w,
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "\nmin/max players: ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text:
                                                                      "${allMatch[index]["minPlayers"]}/${allMatch[index]["maxPlayers"]}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  )),
                                                            ]),
                                                      )),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                            ],
                                          )),
                                      onTap: () async {
                                        if (isBanner) {
                                          if (mounted) {
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                          }
                                          if (noAd) {
                                            if (allMatch[selectedIndex]
                                                    ["matchType"] ==
                                                "daily") {
                                              Navigator.of(
                                                      context)
                                                  .push(MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          MatchScreen(
                                                              allMatch[
                                                                      selectedIndex]
                                                                  ['matchID'],
                                                              false,
                                                              allMatch[
                                                                  selectedIndex])));
                                            } else if (allMatch[selectedIndex]
                                                    ["matchType"] ==
                                                "reward") {
                                              Navigator.of(
                                                      context)
                                                  .push(MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          MatchScreen(
                                                              allMatch[
                                                                      selectedIndex]
                                                                  ['matchID'],
                                                              true,
                                                              allMatch[
                                                                  selectedIndex])));
                                            }
                                          } else {
                                            if (await interstitialAd.isLoaded) {
                                              interstitialAd.show();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          Colors.deepPurple,
                                                      content:
                                                          Text("Loading...")));
                                            }
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor:
                                                      Colors.deepPurple,
                                                  content: Text(
                                                      "Wait for Few seconds ..... Loading")));
                                        }
                                      },
                                    ),
                                    Container(
                                      child: AdmobBanner(
                                        adUnitId:
                                            'ca-app-pub-7072052726974940/5488771146',
                                        adSize: AdmobBannerSize.BANNER,
                                        listener: (AdmobAdEvent event,
                                            Map<String, dynamic> args) {
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
                                        onBannerCreated:
                                            (AdmobBannerController controller) {
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
                                  ]);
                                });
                          }
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            //backgroundColor: Colors.black,
                          ),
                        );
                      },
                    )),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                  width: 360.w, alignment: Alignment.center, child: b1),
            )
          ]),
    ));
  }
}
