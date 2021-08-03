import 'dart:async';
import 'dart:convert';

import 'package:rosterz/main.dart';
import 'package:dio/dio.dart';
import 'package:rosterz/models/match_info.dart';

class MatchBloc {
  final _stateStreamController = StreamController<dynamic>.broadcast();
  StreamSink<dynamic> get _matchSink => _stateStreamController.sink;
  Stream<dynamic> get matchStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<MatchInfo>();
  StreamSink<MatchInfo> get eventSink => _eventStreamController.sink;
  Stream<MatchInfo> get _eventStream => _eventStreamController.stream;

  MatchBloc() {
    _eventStream.listen((event) async {
      var response;

      try {
        if (event.actions == "host") {
          var matchdata = {
            "matchID": event.matchID,
            "organzier": event.organizer,
            "userID": userID,
            "map": event.map,
            "maxPlayers": event.maxPlayers,
            "minPlayers": event.minPlayers,
            "totalSlots": event.totalSlots,
            "matchTime": event.matchTime,
            "idTime": event.idTime,
            "game": event.game,
            "matchType": event.matchType,
            "status": "open",
            "matchLink": event.matchLink
          };

          response = await dio.post(
            serverURl + '/hostmatch',
            data: matchdata,
            options: Options(contentType: Headers.formUrlEncodedContentType),
          );
        } else if (event.actions == "getMatch") {
          if (event.getBy == "matchID") {
            response = await dio.get(serverURl + '/getmatch', queryParameters: {
              "matchID": event.matchID,
              "getBy": event.getBy
            });
          } else if (event.getBy == "game") {
            response = await dio.get(serverURl + '/getmatch',
                queryParameters: {"game": event.game, "getBy": event.getBy});
          } else if (event.getBy == "matchType") {
            response = await dio.get(serverURl + '/getmatch', queryParameters: {
              "matchType": event.matchType,
              "getBy": event.getBy
            });
          } else if (event.getBy == "organizer") {
            response = await dio.get(serverURl + '/getmatch', queryParameters: {
              "organizer": event.organizer,
              "getBy": event.getBy
            });
          }
        } else if (event.actions == "register") {
          var teamdata = {
            "matchID": event.matchID,
            "matchType": event.matchType,
            "type": event.type,
            "teamID": event.teamID,
            "teamName": event.teamName,
            "players": event.player,
            "userID": userID,
          };

          response = await dio.post(
            serverURl + '/registerteam',
            data: teamdata,
            options: Options(contentType: Headers.formUrlEncodedContentType),
          );
        } else if (event.actions == "getteam") {
          response = await dio.get(serverURl + '/getteam',
              queryParameters: {"matchID": event.matchID});
        } else if (event.actions == "postresult") {
          var resultData = {
            "matchID": event.matchID,
            "matchType": event.matchType,
            "game": event.game,
            "organizer": event.organizer,
            "poolPrize": event.prizePool,
            "teamResult": event.result
          };

          response = await dio.post(serverURl + '/postresult',
              data: jsonEncode(resultData));
        } else if (event.actions == "getresult") {
          response = await dio.get(serverURl + '/getresult', queryParameters: {
            "matchID": event.matchID,
          });
        } else if (event.actions == "sendnotification") {
          var notificationData = {
            "matchID": event.matchID,
            "game": event.game,
            "organizer": event.organizer,
            "title": event.title,
            "body": event.body,
            "tokens": event.matchIDs,
            "timeStamp": DateTime.now().toString()
          };

          response = await dio.post(serverURl + '/sendnotification',
              data: jsonEncode(notificationData));
        } else if (event.actions == "getnotification") {
          response =
              await dio.get(serverURl + '/getnotification', queryParameters: {
            "matchIDs": event.matchIDs,
          });
        }
      } on Error catch (e) {
        print(e);
      }

      _matchSink.add(response.data);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
