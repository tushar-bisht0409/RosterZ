import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/blocs/user_bloc.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/models/user_info.dart';
import 'package:rosterz/screens/match_screen.dart';

class MatchJoinHostScreen extends StatefulWidget {
  var joinORhost;
  MatchJoinHostScreen(this.joinORhost);
  @override
  _MatchJoinHostScreenState createState() => _MatchJoinHostScreenState();
}

class _MatchJoinHostScreenState extends State<MatchJoinHostScreen> {
  //final _controller = new TextEditingController();
  UserBloc userBloc = UserBloc();
  UserInfo userInfo = UserInfo();
  UserBloc matchBloc = UserBloc();
  UserInfo matchInfo = UserInfo();
  int selectedIndex;
  AdmobInterstitial interstitialAd;
  var allMatch = [];
  var matchIDs = [];
  var mlen;
  bool noAd = false;
  int adCount = 0;
  String slotsLeft(int ind) {
    var left =
        int.parse(allMatch[ind]["totalSlots"]) - allMatch[ind]["teams"].length;
    return left.toString();
  }

  createAd() {
    interstitialAd = AdmobInterstitial(
      adUnitId: 'ca-app-pub-8553679955744021/7358965017',
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
            if (allMatch[selectedIndex]['matchType'] == "daily") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MatchScreen(
                      matchIDs[selectedIndex],
                      false,
                      allMatch[selectedIndex])));
            } else if (allMatch[selectedIndex]['matchType'] == "reward") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MatchScreen(
                      matchIDs[selectedIndex], true, allMatch[selectedIndex])));
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
    userInfo.actions = "getinfo";
    userInfo.userID = userID;
    userBloc.eventSink.add(userInfo);
    createAd();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return SafeArea(
        child: Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          //  color: Colors.black,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pink, Colors.deepPurple, Colors.lightBlue])),
        ),
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            StreamBuilder(
                stream: userBloc.userStream,
                builder: (ctx, ss) {
                  if (ss.hasData) {
                    if (ss.data['success']) {
                      if (widget.joinORhost == 'join') {
                        matchIDs = ss.data['msz'][0]['matchJoined'];
                      } else {
                        matchIDs = ss.data['msz'][0]['matchHosted'];
                      }
                    }
                    if (matchIDs == []) {
                      mlen = 0;
                    }
                  }
                  return SizedBox();
                }),
            Container(
              alignment: Alignment.topCenter,
              //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
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
                        widget.joinORhost == 'join' ? "Joined" : "Hosted",
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
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                width: double.infinity,
                height: 625.h - toppad, //- bottompad,
                child: StreamBuilder(
                  stream: matchBloc.userStream,
                  builder: (ctx, snapshot) {
                    if (matchIDs != []) {
                      matchInfo.matchIDs = matchIDs;
                      matchInfo.actions = "getMatch";
                      matchBloc.eventSink.add(matchInfo);
                    }
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
                        allMatch = snapshot.data["msz"];
                        print("aasd ${snapshot.data["msz"]}");
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: allMatch.length,
                            itemBuilder: (ctx, index) {
                              return Column(children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                      margin: EdgeInsets.only(bottom: 10.h),
                                      width: ScreenUtil().setWidth(320),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Colors.pink[100].withOpacity(0.4),
                                          Colors.deepPurple[100]
                                              .withOpacity(0.4),
                                          Colors.lightBlue[100].withOpacity(0.4)
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
                                                allMatch[index]["organizer"],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  width: 120.w,
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text: "\nID Pass At: ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: allMatch[
                                                                      index]
                                                                  ["idTime"],
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
                                                  )),
                                              Container(
                                                  width: 120.w,
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text: "\nMatch Time: ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: allMatch[
                                                                      index]
                                                                  ["matchTime"],
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
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  width: 120.w,
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text:
                                                            "\nRegistration: ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: allMatch[
                                                                      index]
                                                                  ["status"],
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
                                                  )),
                                              Container(
                                                  width: 120.w,
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text: "\nMap: ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: allMatch[
                                                                  index]["map"],
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
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  width: 120.w,
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text: "\nEntry Fee: ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "₹ ${allMatch[index]["entryFee"]}",
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
                                                  )),
                                              Container(
                                                  width: 120.w,
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text:
                                                            "\nmin/max players: ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "${allMatch[index]["minPlayers"]}/${allMatch[index]["maxPlayers"]}",
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
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  width: 120.w,
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text: "\nEntry Fee: ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: allMatch[
                                                                      index]
                                                                  ["entryFee"],
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
                                                  )),
                                              Container(
                                                  width: 120.w,
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text:
                                                            "\nmin/max players: ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "${allMatch[index]["minPlayers"]}/${allMatch[index]["maxPlayers"]}",
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
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                        ],
                                      )),
                                  onTap: () async {
                                    if (mounted) {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    }
                                    if (noAd) {
                                      if (allMatch[selectedIndex]
                                              ['matchType'] ==
                                          "daily") {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    MatchScreen(
                                                        matchIDs[selectedIndex],
                                                        false,
                                                        allMatch[
                                                            selectedIndex])));
                                      } else if (allMatch[selectedIndex]
                                              ['matchType'] ==
                                          "reward") {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    MatchScreen(
                                                        matchIDs[selectedIndex],
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
                                                content: Text("Loading...")));
                                      }
                                    }
                                  },
                                ),
                                Container(
                                  child: AdmobBanner(
                                    adUnitId:
                                        'ca-app-pub-8553679955744021/8007867168',
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
                              ;
                            });
                      }
                    }
                    if (mlen == 0) {
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
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        //backgroundColor: Colors.black,
                      ),
                    );
                  },
                ))
          ],
        ),
      ]),
    ));
  }
}
