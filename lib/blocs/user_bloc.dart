import 'dart:async';
import 'package:rosterz/main.dart';
import 'package:rosterz/models/user_info.dart';

class UserBloc {
  final _stateStreamController = StreamController<dynamic>.broadcast();
  StreamSink<dynamic> get _userSink => _stateStreamController.sink;
  Stream<dynamic> get userStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<UserInfo>();
  StreamSink<UserInfo> get eventSink => _eventStreamController.sink;
  Stream<UserInfo> get _eventStream => _eventStreamController.stream;

  UserBloc() {
    _eventStream.listen((event) async {
      var response;

      try {
        if (event.actions == "getMatch") {
          response =
              await dio.get(serverURl + '/getusermatch', queryParameters: {
            "matchIDs": event.matchIDs,
          });
        } else if (event.actions == "getinfo") {
          response = await dio.get(serverURl + '/getuser', queryParameters: {
            "userID": event.userID,
          });
        } else if (event.actions == "gettokenlist") {
          response =
              await dio.get(serverURl + '/fcmtokenlist', queryParameters: {
            "userIDs": event.userIDs,
          });
        }
      } on Error catch (e) {
        print(e);
      }

      _userSink.add(response.data);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
