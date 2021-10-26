import 'dart:convert';
//import 'package:facebook_audience_network/ad/ad_banner.dart';
//import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tapjoy/flutter_tapjoy.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:tap_joy_plugin/tap_joy_plugin.dart';
import 'package:rosterz/blocs/match_bloc.dart';
import 'package:rosterz/blocs/user_bloc.dart';
import 'package:rosterz/drawer.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/models/match_info.dart';
import 'package:rosterz/models/user_info.dart';
import 'package:rosterz/screens/alltournament_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rosterz/screens/notification_screen.dart';
import 'package:rosterz/screens/profile_screen.dart';
import 'package:rosterz/screens/team_screen.dart';

var gameImg = {
  "PUBG": "assets/images/PUBG.png",
  "BGMI": "assets/images/BGMI.png",
  "FREEFIRE": "assets/images/FREEFIRE.png",
  "COD": "assets/images/COD.png",
  "PUBGLITE": "assets/images/PUBGLITE.png"
};

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> gameNo = ["PUBG", "BGMI", "FREEFIRE", "COD", "PUBGLITE"];
  var fcmToken;
  var matchIDs;
  bool isNotification = false;
  UserBloc userBloc = UserBloc();
  UserInfo userInfo = UserInfo();
  MatchBloc notiBloc = MatchBloc();
  MatchInfo notiInfo = MatchInfo();
  var uCoins;
  TJPlacement myPlacement = TJPlacement(name: "RosterZ_Home_Wall");
  TJPlacement myPlacement2 = TJPlacement(name: "Interstitial");
  String contentStateText = "";
  String connectionState = "";
  String iOSATTAuthResult = "";
  String balance = "";
  bool isTapJoy = false;
  // AdmobInterstitial interstitialAd;
  bool noAd = false;
  // int adCount = 0;
  //AdmobBanner b2;
  //AdmobBanner b3;
  // int bannerAdCount = 0;
  // int bannerAdFail = 0;
  // bool isBanner = false;
  // AdmobBanner b1;

  // bool isInterstitialAdLoaded = false;

  // showInterstitialAd() {
  //   if (isInterstitialAdLoaded == true)
  //     FacebookInterstitialAd.showInterstitialAd();
  //   else
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         backgroundColor: Colors.deepPurple, content: Text("Loading...")));
  // }

  // void loadInterstitialAd() {
  //   FacebookInterstitialAd.loadInterstitialAd(
  //     placementId:
  //         "1240510383077524_1240541763074386", //"IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617" YOUR_PLACEMENT_ID
  //     listener: (result, value) {
  //       print(">> FAN > Interstitial Ad: $result --> $value");
  //       if (result == InterstitialAdResult.DISPLAYED) {
  //         Navigator.of(context).push(MaterialPageRoute(
  //             builder: (BuildContext context) => NotificationScreen()));
  //       }
  //       if (result == InterstitialAdResult.LOADED)
  //         isInterstitialAdLoaded = true;

  //       /// Once an Interstitial Ad has been dismissed and becomes invalidated,
  //       /// load a fresh Ad by calling this function.
  //       if (result == InterstitialAdResult.DISMISSED &&
  //           value["invalidated"] == true) {
  //         if (mounted) {
  //           setState(() {
  //             adCount++;
  //           });
  //         }
  //         if (adCount < 4) {
  //           isInterstitialAdLoaded = false;
  //           loadInterstitialAd();
  //         } else {
  //           if (mounted) {
  //             setState(() {
  //               noAd = true;
  //             });
  //           }
  //         }
  //       }
  //     },
  //   );
  // }

  // Widget bannerAd = SizedBox(
  //   width: 0.0,
  //   height: 0.0,
  // );

  // loadBannerAd() {
  //   if (mounted) {
  //     setState(() {
  //       bannerAd = FacebookBannerAd(
  //         placementId: "1240510383077524_1240539173074645",
  //         // placementId:
  //         //     "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047", //testid
  //         bannerSize: BannerSize.STANDARD,
  //         listener: (result, value) {
  //           if (result == BannerAdResult.LOADED) {
  //             if (mounted) {
  //               setState(() {
  //                 bannerAdCount++;
  //                 isBanner = true;
  //               });
  //             }
  //           } else if (result == BannerAdResult.ERROR) {
  //             if (bannerAdFail < 2) {
  //               if (mounted) {
  //                 setState(() {
  //                   bannerAdFail++;
  //                 });
  //               }
  //               loadBannerAd();
  //             } else {
  //               isBanner = true;
  //             }
  //           }
  //           print("Banner Ad: $result -->  $value");
  //         },
  //       );
  //     });
  //   }
  //   return bannerAd;
  // }

  // createBannerAd1() {
  //   b1 = AdmobBanner(
  //     adUnitId: 'ca-app-pub-7072052726974940/5488771146',
  //     adSize: AdmobBannerSize.BANNER,
  //     listener: (AdmobAdEvent event, Map<String, dynamic> args) {
  //       switch (event) {
  //         case AdmobAdEvent.loaded:
  //           print('New Admob Ad loaded!');
  //           if (mounted) {
  //             setState(() {
  //               bannerAdCount++;
  //               isBanner = true;
  //             });
  //           }
  //           break;
  //         case AdmobAdEvent.opened:
  //           print('Admob Ad opened!');
  //           break;
  //         case AdmobAdEvent.closed:
  //           print('Admob Ad closed!');
  //           break;
  //         case AdmobAdEvent.failedToLoad:
  //           print('Admob failed to load. :(');
  //           if (bannerAdFail < 2) {
  //             if (mounted) {
  //               setState(() {
  //                 bannerAdFail++;
  //                 createBannerAd1();
  //               });
  //             }
  //           } else {
  //             isBanner = true;
  //           }
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
  //   );
  // }

  // createBannerAd2() {
  //   b2 = AdmobBanner(
  //     adUnitId: 'ca-app-pub-7072052726974940/5488771146',
  //     adSize: AdmobBannerSize.BANNER,
  //     listener: (AdmobAdEvent event, Map<String, dynamic> args) {
  //       switch (event) {
  //         case AdmobAdEvent.loaded:
  //           print('New Admob Ad loaded!');
  //           if (mounted) {
  //             setState(() {
  //               bannerAdCount++;
  //             });
  //           }
  //           break;
  //         case AdmobAdEvent.opened:
  //           print('Admob Ad opened!');
  //           break;
  //         case AdmobAdEvent.closed:
  //           print('Admob Ad closed!');
  //           break;
  //         case AdmobAdEvent.failedToLoad:
  //           print('Admob failed to load. :(');
  //           if (bannerAdFail < 5) {
  //             if (mounted) {
  //               setState(() {
  //                 bannerAdFail++;
  //               });
  //             }
  //           } else {
  //             createBannerAd2();
  //           }
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
  //   );
  // }

  // createBannerAd3() {
  //   b3 = AdmobBanner(
  //     adUnitId: 'ca-app-pub-7072052726974940/5488771146',
  //     adSize: AdmobBannerSize.BANNER,
  //     listener: (AdmobAdEvent event, Map<String, dynamic> args) {
  //       switch (event) {
  //         case AdmobAdEvent.loaded:
  //           print('New Admob Ad loaded!');
  //           if (mounted) {
  //             setState(() {
  //               bannerAdCount++;
  //             });
  //           }
  //           break;
  //         case AdmobAdEvent.opened:
  //           print('Admob Ad opened!');
  //           break;
  //         case AdmobAdEvent.closed:
  //           print('Admob Ad closed!');
  //           break;
  //         case AdmobAdEvent.failedToLoad:
  //           print('Admob failed to load. :(');
  //           if (bannerAdFail < 5) {
  //             if (mounted) {
  //               setState(() {
  //                 bannerAdFail++;
  //               });
  //             }
  //           } else {
  //             createBannerAd3();
  //           }
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
  //   );
  // }

  Future<void> getuser() async {
    userInfo.actions = "getinfo";
    userInfo.userID = userID;
    userBloc.eventSink.add(userInfo);
  }

  Future<void> saveFcmToken() async {
    var fcm = await FirebaseMessaging.instance.getToken();
    if (fcmToken != fcm) {
      try {
        await dio.post(serverURl + '/updatefcmtoken',
            data: jsonEncode({
              "userID": userID,
              "fcmToken": fcm,
            }));
      } on Error catch (e) {
        print(e);
      }
    }
  }

  // Future<void> getTap() async {
  //   await myPlacement.requestContent().then((value) {
  //     if (mounted) {
  //       setState(() {
  //         isTapJoy = true;
  //       });
  //     }
  //   });
  //   await myPlacement2.requestContent();
  // }

  // createAd() {
  //   interstitialAd = AdmobInterstitial(
  //     adUnitId: 'ca-app-pub-7072052726974940/3537680635',
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
  //           interstitialAd.load();
  //           Navigator.of(context).push(MaterialPageRoute(
  //               builder: (BuildContext context) => NotificationScreen()));
  //           break;
  //         case AdmobAdEvent.failedToLoad:
  //           print('Admob failed to load. :(');
  //           if (mounted) {
  //             setState(() {
  //               adCount++;
  //             });
  //           }
  //           if (adCount < 4) {
  //             createAd();
  //           } else {
  //             if (mounted) {
  //               setState(() {
  //                 noAd = true;
  //               });
  //             }
  //           }
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
  //   );
  //   interstitialAd.load();
  // }

  double getIndicator() {
    if (uCoins == null) {
      return 0.0;
    } else {
      return (190.w * ((uCoins % 100) / 100));
    }
  }

  void initState() {
    super.initState();
    saveFcmToken();
    getuser();
    // set connection result handler
    TapJoyPlugin.shared.setConnectionResultHandler(_connectionResultHandler());
    // connect to TapJoy, all fields are required.
    TapJoyPlugin.shared.connect(
        androidApiKey:
            "A_um0CNHQQWLoZZMovGeKgECb2ugqkw7NYjFd9Zs3SWN94S8Yq2QucYx30g8",
        iOSApiKey:
            "6fSI8DbuTwimJ4Lqy0VA6AEBsNwQo75QL2oqyZsXmZm7hFhKzBKx43yeP5Qy",
        debug: false);
    // set userID
    TapJoyPlugin.shared.setUserID(userID: userID);
    // set contentState handler for each placement
    myPlacement.setHandler(_placementHandler());
    myPlacement2.setHandler(_placementHandler());
    // add placements.
    TapJoyPlugin.shared.addPlacement(myPlacement);
    TapJoyPlugin.shared.addPlacement(myPlacement2);
    loadOfferwall();
    // set currency Handlers
    // TapJoyPlugin.shared.setGetCurrencyBalanceHandler(_currencyHandler());
    // TapJoyPlugin.shared.setAwardCurrencyHandler(_currencyHandler());
    // TapJoyPlugin.shared.setSpendCurrencyHandler(_currencyHandler());
    // TapJoyPlugin.shared.setEarnedCurrencyAlertHandler(_currencyHandler());
    //  getTap();
    // createAd();
    // createBannerAd1();
    // createBannerAd2();
    // createBannerAd3();
    // loadInterstitialAd();
    // loadBannerAd();
  }

  // TJSpendCurrencyHandler _currencyHandler() {
  //   TJSpendCurrencyHandler handler = (currencyName, amount, error) {
  //     setState(() {
  //       balance = "Currency Name: " +
  //           currencyName.toString() +
  //           " Amount:  " +
  //           amount.toString() +
  //           " Error:" +
  //           error.toString();
  //     });
  //   };
  //   return handler;
  // }

  TJConnectionResultHandler _connectionResultHandler() {
    TJConnectionResultHandler handler = (result) {
      switch (result) {
        case TJConnectionResult.connected:
          setState(() {
            print("Connected Yoo");
            connectionState = "Connected";
          });
          break;
        case TJConnectionResult.disconnected:
          setState(() {
            print("Disconnected Noo");
            connectionState = "Disconnected";
            TapJoyPlugin.shared.connect(
                androidApiKey:
                    "A_um0CNHQQWLoZZMovGeKgECb2ugqkw7NYjFd9Zs3SWN94S8Yq2QucYx30g8",
                iOSApiKey:
                    "6fSI8DbuTwimJ4Lqy0VA6AEBsNwQo75QL2oqyZsXmZm7hFhKzBKx43yeP5Qy",
                debug: false);
          });
          break;
      }
    };
    return handler;
  }

  loadOfferwall() async {
    await myPlacement.requestContent();
  }

  // placement Handler
  TJPlacementHandler _placementHandler() {
    TJPlacementHandler handler = (contentState, name, error) {
      switch (contentState) {
        case TJContentState.contentReady:
          setState(() {
            contentStateText = "Content Ready for placement :  $name";
            isTapJoy = true;
          });
          break;
        case TJContentState.contentDidAppear:
          setState(() {
            contentStateText = "Content Did Appear for placement :  $name";
          });
          break;
        case TJContentState.contentDidDisappear:
          setState(() {
            contentStateText = "Content Did Disappear for placement :  $name";
            myPlacement.requestContent();
          });
          break;
        case TJContentState.contentRequestSuccess:
          setState(() {
            contentStateText = "Content Request Success for placement :  $name";
          });
          break;
        case TJContentState.contentRequestFail:
          setState(() {
            contentStateText =
                "Content Request Fail + $error for placement :  $name";
            myPlacement.requestContent();
          });
          break;
        case TJContentState.userClickedAndroidOnly:
          setState(() {
            contentStateText = "Content User Clicked for placement :  $name";
          });
          break;
      }
    };
    return handler;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    toppad = MediaQuery.of(context).padding.top.ceil();
    bottompad = MediaQuery.of(context).padding.bottom.ceil();
    return SafeArea(
        child: Scaffold(
      drawer: AppDrawer(),
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Container(
      //     child: //bannerAd //
      //         b1),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        Container(
          width: 360.w,
          height: 1.h,
          color: Colors.grey,
        ),
        Container(
            color: Colors.black,
            height: 7.h + 50.w + 10.sp,
            padding:
                EdgeInsets.only(top: 0.h, bottom: 7.h, right: 20.w, left: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TeamScreen()));
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.teamspeak,
                          size: 25.w,
                          color: Colors.redAccent,
                        )),
                    Text(
                      'My Team',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    isTapJoy
                        ? IconButton(
                            onPressed: () async {
                              await myPlacement.showPlacement();
                              await myPlacement.requestContent();
                            },
                            icon: Icon(
                              Icons.bolt,
                              size: 25.w,
                              color: Colors.lightGreenAccent,
                            ))
                        : Container(
                            height: 25.w,
                            alignment: Alignment.topCenter,
                            child: Text("Loading...",
                                style: TextStyle(
                                  color: Colors.lightGreenAccent,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w800,
                                ))),
                    Text(
                      'Earn Points',
                      style: TextStyle(
                          color: Colors.lightGreenAccent,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(userID)));
                        },
                        icon: Icon(
                          Icons.account_circle_rounded,
                          size: 25.w,
                          color: Colors.lightBlueAccent,
                        )),
                    Text(
                      'My Profile',
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ],
            ))
      ]),
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          // child: Image.asset(
          //   "assets/images/Background.png",
          //   fit: BoxFit.cover,
          //   color: Colors.black.withOpacity(0.8),
          //   colorBlendMode: BlendMode.darken,
          // ),
        ),
        ListView(
          children: <Widget>[
            StreamBuilder(
                stream: userBloc.userStream,
                builder: (ctx, sss) {
                  userBloc.eventSink.add(userInfo);
                  if (sss.hasData) {
                    if (sss.data['success']) {
                      uCoins = sss.data['msz'][0]['coins'];
                      matchIDs = sss.data['msz'][0]['matchJoined'] +
                          sss.data['msz'][0]['matchHosted'];
                    }
                  }
                  return SizedBox();
                }),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              width: 360.w,
              height: 70.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(30.h),
                ),

                //   gradient: LinearGradient(
                //       colors: [Colors.pink, Colors.deepPurple, Colors.lightBlue]),
                //   // colors: [Colors.brown, Colors.amber, Colors.yellow]),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Builder(
                      builder: (context) => IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 20.w,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          })),
                  Container(
                      width: 200.w,
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.w),
                          )),
                      padding: EdgeInsets.only(
                        top: 5.h,
                        bottom: 5.h,
                      ),
                      child: Column(children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                                uCoins == null
                                    ? "Loading"
                                    : "${(uCoins / 100).floor()}",
                                style: TextStyle(
                                  color: Colors.lightGreenAccent,
                                  fontSize: uCoins == null ? 12.sp : 22.sp,
                                  fontWeight: FontWeight.w800,
                                )),
                            Icon(
                              Icons.bolt,
                              color: Colors.lightGreenAccent,
                              size: 30.w,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.w),
                              ),
                              border: Border.all(
                                  width: 0.01.w, color: Colors.black),
                            ),
                            width: 190.w,
                            child: Container(
                              height: 12.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.w),
                                ),
                                gradient: LinearGradient(colors: [
                                  Colors.lightBlueAccent,
                                  //      Colors.amber,
                                  Colors.lightGreenAccent
                                ]),
                              ),
                              margin: EdgeInsets.only(
                                  right: (190.w - getIndicator()) / 2,
                                  left: (190.w - getIndicator()) / 2),
                              child: Text(
                                uCoins == null ? "" : '${(uCoins % 100)}',
                                style: TextStyle(
                                    fontSize: 9.h, fontWeight: FontWeight.w900),
                              ),
                            ))
                      ])),
                  StreamBuilder(
                      stream: notiBloc.matchStream,
                      builder: (ctx, snapshot) {
                        notiInfo.actions = "getnotification";
                        notiInfo.matchIDs = matchIDs;
                        notiBloc.eventSink.add(notiInfo);
                        if (snapshot.hasData) {
                          if (snapshot.data['success']) {
                            if (notificationCount !=
                                snapshot.data['msz'].length) {
                              isNotification = true;
                            }
                          }
                        }
                        return IconButton(
                            icon: Icon(
                              isNotification
                                  ? Icons.notifications_active_rounded
                                  : Icons.notifications_rounded,
                              color: isNotification
                                  ? Colors.amberAccent
                                  : Colors.white,
                              size: isNotification ? 30.w : 20.w,
                            ),
                            onPressed: () async {
                              // if (noAd) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      NotificationScreen()));
                              // } else {
                              //   if (await interstitialAd.isLoaded) {
                              //     interstitialAd.show();
                              //   } else {
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(
                              //             duration: Duration(seconds: 2),
                              //             backgroundColor: Colors.pink,
                              //             content: Text("Loading...")));
                              //   }
                              // }
                            });
                      }),
                ],
              ),
            ),
            // Container(
            //     child: // bannerAd
            //         b1),
            Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                width: 360.w,
                //   height: 630.h - toppad, //- bottompad,
                child: GridView.builder(
                    shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 20.h,
                        crossAxisSpacing: 40.w,
                        childAspectRatio: 1.3,
                        crossAxisCount: 2),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Card(
                            elevation: 2,
                            margin: EdgeInsets.only(
                                top: 10.h, left: 20.w, right: 20.w),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.h))),
                            child: Container(
                              height: 65.h,
                              width: 70.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.h)),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          gameImg["${gameNo[index]}"]),
                                      fit: BoxFit.cover)),
                            )),
                        onTap: () {
                          // if (isBanner) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AllTournamentScreen(gameNo[index])));
                          // } else {
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //       duration: Duration(seconds: 2),
                          //       backgroundColor: Colors.pink,
                          //       content: Text(
                          //           "Wait for Few seconds ..... Loading")));
                          // }
                        },
                      );
                    })),
            // Container(
            //     child: // bannerAd //
            //         b1),
          ],
        )
      ]),
    ));
  }
}
