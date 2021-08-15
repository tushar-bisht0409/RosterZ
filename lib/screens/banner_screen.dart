import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/blocs/match_bloc.dart';
import 'package:rosterz/blocs/user_bloc.dart';

class BannerScreen extends StatefulWidget {
  static const routeName = '/banners';
  var regInfo;
  var uInfo;
  BannerScreen(this.regInfo, this.uInfo);
  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  MatchBloc registerBloc = MatchBloc();
  int bannerAdCount = 0;
  UserBloc uBloc = UserBloc();
  Widget bannerAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );

  loadBannerAd() {
    if (mounted) {
      setState(() {
        bannerAd = FacebookBannerAd(
          placementId: "1240510383077524_1240539173074645",
          // placementId:
          //     "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047", //testid
          bannerSize: BannerSize.STANDARD,
          listener: (result, value) {
            if (result == BannerAdResult.LOADED) {
              if (mounted) {
                setState(() {
                  bannerAdCount++;
                });
              }
            } else if (result == BannerAdResult.ERROR) {
            } else if (result == BannerAdResult.CLICKED) {
              registerBloc.eventSink.add(widget.regInfo);
              uBloc.eventSink.add(widget.uInfo);
            }
            print("Banner Ad: $result -->  $value");
          },
        );
      });
    }
    return bannerAd;
  }

  @override
  void initState() {
    super.initState();
    loadBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: 20,
          itemBuilder: (ctx, index) {
            if (index % 5 == 0) {
              return Container(
                width: 360.w,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  bannerAdCount < 5 ? "Loading..." : 'Click Any Ad To Register',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300),
                ),
              );
            }
            return bannerAd;
          }),
    ));
  }
}
