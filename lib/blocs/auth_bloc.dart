import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rosterz/main.dart';
import 'package:dio/dio.dart';
import 'package:rosterz/models/user_info.dart';
import 'package:rosterz/screens/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

var authResult = {'success': false, 'msz': '', 'token': ''};

class AuthBloc {
  final _stateStreamController = StreamController<dynamic>.broadcast();
  StreamSink<dynamic> get _authSink => _stateStreamController.sink;
  Stream<dynamic> get authStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<UserInfo>();
  StreamSink<UserInfo> get eventSink => _eventStreamController.sink;
  Stream<UserInfo> get _eventStream => _eventStreamController.stream;

  saveData(String uID, String fToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("a $uID");
    await prefs.setString('userID', uID);
    await prefs.setString('fcmToken', fToken);
  }

  AuthBloc() {
    _eventStream.listen((event) async {
      var response;
      var response2;

      try {
        if (authMode == AuthMode.Signup) {
          response = await dio.post(serverURl + "/adduser",
              data: {"phone": event.phone, "password": event.password},
              options: Options(contentType: Headers.formUrlEncodedContentType));
          if (response.data['success'] == true) {
            response2 = await dio.post(serverURl + "/authenticate",
                data: {"phone": event.phone, "password": event.password},
                options:
                    Options(contentType: Headers.formUrlEncodedContentType));
            if (response2.data['success'] == true) {
              authResult = {
                'success': response2.data['success'],
                'msz': response2.data['msz'],
                'token': response2.data['token']
              };
              userID = response2.data['userID'];
              token = response2.data['token'];
              var fcm = await FirebaseMessaging.instance.getToken();
              await dio.post(serverURl + '/saveuser',
                  data: jsonEncode({
                    "userID": userID,
                    "fcmToken": fcm,
                  }));
              saveData(userID, fcm);
            }
          } else {
            authResult = {
              'success': response.data['success'],
              'msz': response.data['msz'],
              'token': ''
            };
            token = '';
          }
        } else if (authMode == AuthMode.Login) {
          response = await dio.post(serverURl + "/authenticate",
              data: {"phone": event.phone, "password": event.password},
              options: Options(contentType: Headers.formUrlEncodedContentType));
          if (response.data['success'] == true) {
            authResult = {
              'success': response.data['success'],
              'msz': response.data['msz'],
              'token': response.data['token']
            };
            userID = response.data['userID'];
            token = response.data['token'];
            var fcm = await FirebaseMessaging.instance.getToken();
            saveData(userID, fcm);
          } else {
            authResult = {
              'success': response.data['success'],
              'msz': response.data['msz'],
              'token': ''
            };
            token = '';
          }
        } else if (authMode == AuthMode.Forgot) {
          print("forgot");
        }
      } on Error catch (e) {
        print(e);
      }

      _authSink.add(authResult);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
