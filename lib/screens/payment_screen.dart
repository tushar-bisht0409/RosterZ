import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment';
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            Icon(
              Icons.lock_rounded,
              color: Colors.pink,
              size: 100.h,
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
                width: 250.w,
                child: Text(
                  'Wallet not activated for now, it might take a few days. Please be patient !',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w200),
                ))
          ])),
    );
  }
}
