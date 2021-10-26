import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rosterz/blocs/match_bloc.dart';
import 'package:rosterz/blocs/user_bloc.dart';
import 'package:rosterz/models/user_info.dart';

class Payment extends StatefulWidget {
  var entryFee;
  var regInfo;
  bool premium;
  Payment(this.entryFee, this.regInfo, this.premium);
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final razorpay = Razorpay();
  MatchBloc registerBloc = MatchBloc();
  UserBloc uBloc = UserBloc();
  UserInfo uInfo = UserInfo();
  @override
  void initState() {
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWallet);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paySuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, payError);
    super.initState();
  }

  void paySuccess(PaymentSuccessResponse response) {
    if (widget.premium == true) {
    } else {
      registerBloc.eventSink.add(widget.regInfo);
      uInfo.actions = "joinhost";
      uInfo.type = "join";
      uInfo.matchID = widget.regInfo.matchID;
      uBloc.eventSink.add(uInfo);
    }
  }

  void payError(PaymentFailureResponse response) {
    print(response.message + response.code.toString());
  }

  void externalWallet(ExternalWalletResponse response) {
    print(response.walletName);
  }

  getPayment() {
    double mny = double.parse(widget.entryFee) * 100;
    var options = {
      'key': 'rzp_live_VKEA5IwmvM3Zxo',
      'amount': mny,
      'name': 'SpiritZee',
    };
    try {
      razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            top: 250.h,
            right: ScreenUtil().setWidth(20),
            left: ScreenUtil().setWidth(20)),
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(30),
                    right: ScreenUtil().setWidth(40),
                    left: ScreenUtil().setWidth(40)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Make Payment:',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400),
                          )),
                      Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(10),
                          ),
                          alignment: Alignment.center,
                          //  constraints:
                          //    BoxConstraints(maxWidth: 200.w, minWidth: 100.w),
                          width: ScreenUtil().setWidth(120),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.pink,
                              Colors.deepPurple,
                              Colors.lightBlue
                            ]),
                            borderRadius: BorderRadius.circular(10.h),
                          ),
                          padding: EdgeInsets.all(2.w),
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 20.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.h),
                                color: Colors.black,
                              ),
                              child: Center(
                                  child: Text(
                                "₹ ${widget.entryFee}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600),
                              )))),
                    ])),
            Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(80),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.w),
                  color: Colors.pink,
                ),
                margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(30),
                    bottom: 10.h,
                    right: ScreenUtil().setWidth(100),
                    left: ScreenUtil().setWidth(100)),
                child: Center(
                    child: TextButton(
                  child: Text(
                    "Pay",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    getPayment();
                  },
                ))),
          ],
        ));
  }
}
