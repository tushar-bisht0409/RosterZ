import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rosterz/teamslot.dart';

class TournamentTeamScreen extends StatefulWidget {
  static const routeName = '/tournament_teams';
  var orgName;
  var uIDs;
  var tournamentTeams;
  var minPlayers;
  var game;
  TournamentTeamScreen(this.orgName, this.uIDs, this.tournamentTeams,
      this.minPlayers, this.game);

  @override
  _TournamentTeamScreenState createState() => _TournamentTeamScreenState();
}

class _TournamentTeamScreenState extends State<TournamentTeamScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: ListView(children: [
              Container(
                alignment: Alignment.topCenter,
                //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                width: 360.w,
                height: 70.h,
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
                        width: 200.w,
                        height: 50.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(30)),
                        ),
                        child: Text(
                          widget.orgName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600),
                        )),
                    IconButton(
                        icon: Icon(
                          Icons.filter_alt_rounded,
                          color: Colors.transparent,
                          size: 20.w,
                        ),
                        onPressed: () {})
                  ],
                ),
              ),
              Container(
                width: 280.w,
                margin: EdgeInsets.symmetric(horizontal: 40.w),
                alignment: Alignment.center,
                child: Text(
                  "Tournament Teams",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                width: 280.w,
                margin: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  "Teams having atleast ${widget.minPlayers} players having green frame will be allowed to participate.",
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w300),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.tournamentTeams.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, indTeam) {
                    return TeamSlot(
                        indTeam + 1,
                        widget.tournamentTeams[indTeam]["teamName"],
                        widget.tournamentTeams[indTeam]["teamID"],
                        widget.uIDs,
                        widget.game);
                  })
            ])));
  }
}
