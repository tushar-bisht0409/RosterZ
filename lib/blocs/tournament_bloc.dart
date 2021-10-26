import 'dart:async';
import 'package:rosterz/main.dart';
import 'package:dio/dio.dart';
import 'package:rosterz/models/tournament_info.dart';

class TournamentBloc {
  final _stateStreamController = StreamController<dynamic>.broadcast();
  StreamSink<dynamic> get _tournamentSink => _stateStreamController.sink;
  Stream<dynamic> get tournamentStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<TournamentInfo>();
  StreamSink<TournamentInfo> get eventSink => _eventStreamController.sink;
  Stream<TournamentInfo> get _eventStream => _eventStreamController.stream;

  TournamentBloc() {
    _eventStream.listen((event) async {
      var response;
      try {
        if (event.actions == "getTournament") {
          if (event.getBy == "tournamentID") {
            response = await dio.get(serverURl + '/gettournament',
                queryParameters: {
                  "tournamentID": event.tournamentID,
                  "getBy": event.getBy
                });
          } else if (event.getBy == "game") {
            response = await dio.get(serverURl + '/gettournament',
                queryParameters: {"game": event.game, "getBy": event.getBy});
          } else if (event.getBy == "organizer") {
            response = await dio.get(serverURl + '/gettournament',
                queryParameters: {
                  "organizer": event.organizer,
                  "getBy": event.getBy
                });
          } else if (event.getBy == "userID") {
            response = await dio.get(serverURl + '/gettournament',
                queryParameters: {"userID": userID, "getBy": event.getBy});
          }
        } else if (event.actions == "register") {
          var teamdata = {
            "tournamentID": event.tournamentID,
            "team": event.team,
            "type": event.type,
            "teamID": event.teamID,
            "userID": userID,
          };

          response = await dio.post(
            serverURl + '/registertournament',
            data: teamdata,
            options: Options(contentType: Headers.formUrlEncodedContentType),
          );
          print(response.data);
        } else if (event.actions == "getteam") {
          response = await dio.get(serverURl + '/getteam', queryParameters: {
            "userID": userID,
            "game": event.game,
            "teamID": event.teamID,
          });
        } else if (event.actions == "teamactions") {
          var teamdata = {
            "teamID": event.teamID,
            "teamName": event.teamName,
            "type": event.type,
            "userID": event.userID,
            "playerName": event.player,
            "game": event.game,
          };

          response = await dio.post(
            serverURl + '/teamactions',
            data: teamdata,
            options: Options(contentType: Headers.formUrlEncodedContentType),
          );
        }
      } on Error catch (e) {
        print(e);
      }
      _tournamentSink.add(response.data);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
