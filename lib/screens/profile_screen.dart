import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rosterz/blocs/user_bloc.dart';
import 'package:rosterz/main.dart';
import 'package:rosterz/models/user_info.dart';
import 'package:rosterz/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  var uID;
  ProfileScreen(this.uID);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserInfo getInfo = UserInfo();
  UserBloc getBloc = UserBloc();
  UserInfo editInfo = UserInfo();
  UserBloc editBloc = UserBloc();
  TextEditingController editController = TextEditingController();
  var isMe = false;
  @override
  void initState() {
    super.initState();
    if (userID == widget.uID) {
      isMe = true;
    }
  }

  bool starStatus(var starList) {
    if (starList == null) {
      return false;
    } else if (starList.length == 0) {
      return false;
    } else if (starList.contains(userID)) {
      return true;
    } else {
      return false;
    }
  }

  void _showEdit1Dialog(String title, String type, String old) async {
    editController.text = old;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white54,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.h))),
        title: Text(title),
        content: Container(
            width: ScreenUtil().setWidth(200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.h),
              color: Colors.black,
              shape: BoxShape.rectangle,
            ),
            child: TextField(
              cursorColor: Colors.white,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              onSubmitted: (value) {},
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(5),
                      bottom: ScreenUtil().setHeight(5),
                      left: ScreenUtil().setWidth(10)),
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white38)),
              controller: editController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              autofocus: true,
              style: TextStyle(color: Colors.white),
              onChanged: (value) {},
            )),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.pink[700]),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Save'),
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.pink[700]),
            ),
            onPressed: () {
              if (editController.text.trim() != "") {
                if (mounted) {
                  setState(() {
                    editInfo.actions = "updateinfo";
                    editInfo.userID = userID;
                    editInfo.type = type;
                    editInfo.newinfo = editController.text;
                    editBloc.eventSink.add(editInfo);
                  });
                }
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.pink,
                    content: Text("Fill the fields.")));
              }
            },
          )
        ],
      ),
    );
  }

  void _showDropEdit1Dialog(String title, String type, String old) async {
    var gameName;
    if (old != "") {
      gameName = old;
    } else {}
    List<String> gameList = ["PUBG", "BGMI", "FREEFIRE", "COD", "PUBGLITE"];
    await showDialog(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (BuildContext context, setAlert) {
              return AlertDialog(
                backgroundColor: Colors.white54,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.h))),
                title: Text(title),
                content: Container(
                    width: 200.w,
                    height: 40.h,
                    padding: EdgeInsets.only(left: 20.w),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setWidth(30)),
                      color: Colors.black,
                    ),
                    child: Center(
                        child: DropdownButton<String>(
                      value: gameName,
                      isExpanded: true,
                      elevation: 0,
                      icon: Icon(
                        Icons.arrow_circle_down,
                        color: Colors.black,
                      ),
                      dropdownColor: Colors.pink,
                      hint: Text(
                        "Choose Game",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16.sp,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      underline: Container(
                        height: 0,
                        color: Colors.black,
                      ),
                      onChanged: (String newValue) {
                        if (mounted) {
                          setAlert(() {
                            gameName = newValue;
                          });
                        }
                      },
                      items: gameList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        );
                      }).toList(),
                    ))),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.pink[700]),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Save'),
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.pink[700]),
                    ),
                    onPressed: () {
                      if (gameName != null) {
                        if (mounted) {
                          setAlert(() {
                            editInfo.actions = "updateinfo";
                            editInfo.userID = userID;
                            editInfo.type = type;
                            editInfo.newinfo = gameName;
                            editBloc.eventSink.add(editInfo);
                          });
                        }

                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.greenAccent,
                            content: Text("Fill the fields.",style: TextStyle(color: Colors.black),)));
                      }
                    },
                  )
                ],
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                child: Image.asset(
                  "assets/images/Background.png",
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.8),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              StreamBuilder(
                stream: getBloc.userStream,
                builder: (ctx, snapshot) {
                  getInfo.actions = "getinfo";
                  getInfo.userID = widget.uID;
                  getBloc.eventSink.add(getInfo);
                  if (snapshot.hasData) {
                    if (snapshot.data["success"]) {
                      var uInfo = snapshot.data["msz"][0];
                      var lostCount =
                          uInfo["matchJoined"].length - uInfo["winCount"];
                      return ListView(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topCenter,
                            //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                            padding: EdgeInsets.symmetric(
                                vertical: 20.h, horizontal: 15.w),
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
                                      uInfo["inGameName"],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w600),
                                    )),
                                isMe
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.edit_rounded,
                                          size: 15.h,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          _showEdit1Dialog(
                                              "In Game Name",
                                              "inGameName",
                                              uInfo["inGameName"]);
                                        })
                                    : IconButton(
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
                            width: 360.w,
                            padding: EdgeInsets.only(
                                left: 20.w,
                                top: 10.h,
                                bottom: 0.h,
                                right: 25.w),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  isMe
                                      ? Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 25.w,
                                        )
                                      : IconButton(
                                          icon: Icon(
                                            starStatus(uInfo["star"])
                                                ? Icons.star
                                                : Icons.star_border_rounded,
                                            color: starStatus(uInfo["star"])
                                                ? Colors.amber
                                                : Colors.grey[300],
                                            size: 25.w,
                                          ),
                                          onPressed: () {
                                            if (mounted) {
                                              setState(() {
                                                editInfo.actions = "updateinfo";
                                                editInfo.userID = userID;
                                                editInfo.type = "star";
                                                if (starStatus(uInfo["star"])) {
                                                  editInfo.starType = "false";
                                                } else {
                                                  editInfo.starType = "true";
                                                }
                                                editInfo.senderID = userID;
                                                editInfo.receiverID =
                                                    uInfo["userID"];
                                                editBloc.eventSink
                                                    .add(editInfo);
                                              });
                                            }
                                          }),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    "${uInfo["star"].length}",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 50.w, right: 50.w, bottom: 15.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Card(
                                  elevation: 2,
                                  margin: EdgeInsets.zero,
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.h))),
                                  child: Container(
                                    height: 65.h,
                                    width: 70.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Colors.pink[100].withOpacity(0.4),
                                          Colors.deepPurple[100]
                                              .withOpacity(0.4),
                                          Colors.lightBlue[100].withOpacity(0.4)
                                        ]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.h))),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              alignment: Alignment.center,
                                              width: 70.h,
                                              child: Text(
                                                "Tournaments",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Container(
                                              alignment: Alignment.center,
                                              width: 70.h,
                                              child: Text(
                                                  "${uInfo["matchJoined"].length}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w400)))
                                        ]),
                                  ),
                                ),
                                Card(
                                  elevation: 2,
                                  margin: EdgeInsets.zero,
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.h))),
                                  child: Container(
                                    height: 65.h,
                                    width: 70.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Colors.pink[100].withOpacity(0.4),
                                          Colors.deepPurple[100]
                                              .withOpacity(0.4),
                                          Colors.lightBlue[100].withOpacity(0.4)
                                        ]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.h))),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              alignment: Alignment.center,
                                              width: 70.h,
                                              child: Text(
                                                "Win",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Container(
                                              alignment: Alignment.center,
                                              width: 70.h,
                                              child: Text(
                                                  "${uInfo["winCount"]}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w400)))
                                        ]),
                                  ),
                                ),
                                Card(
                                  elevation: 2,
                                  margin: EdgeInsets.zero,
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.h))),
                                  child: Container(
                                    height: 65.h,
                                    width: 70.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Colors.pink[100].withOpacity(0.4),
                                          Colors.deepPurple[100]
                                              .withOpacity(0.4),
                                          Colors.lightBlue[100].withOpacity(0.4)
                                        ]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.h))),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              alignment: Alignment.center,
                                              width: 70.h,
                                              child: Text(
                                                "Lost",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Container(
                                              alignment: Alignment.center,
                                              width: 70.h,
                                              child: Text("$lostCount",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w400)))
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 360.w,
                            padding: EdgeInsets.only(
                                left: 20.w,
                                top: 10.h,
                                bottom: 0.h,
                                right: 25.w),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "About",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  isMe
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.edit_rounded,
                                            size: 15.h,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            _showEdit1Dialog("About", "about",
                                                uInfo["about"]);
                                          })
                                      : SizedBox()
                                ]),
                          ),
                          Container(
                            width: 360.w,
                            padding: EdgeInsets.only(
                                left: 20.w, bottom: 10.h, right: 25.w),
                            child: Text(
                              uInfo["about"],
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 20.w,
                                        top: 10.h,
                                        bottom: 0.h,
                                        right: 25.w),
                                    child: Text(
                                      "Primary Game",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  uInfo["primaryGame"] == ""
                                      ? SizedBox()
                                      : Card(
                                          elevation: 2,
                                          margin: EdgeInsets.only(
                                              top: 10.h,
                                              left: 20.w,
                                              right: 20.w),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.h))),
                                          child: Container(
                                            height: 65.h,
                                            width: 70.h,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.h)),
                                                image: DecorationImage(
                                                    image: AssetImage(gameImg[
                                                        uInfo["primaryGame"]]),
                                                    fit: BoxFit.cover)),
                                          )),
                                  isMe
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.edit_rounded,
                                            size: 15.h,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            _showDropEdit1Dialog(
                                                "Primary Game",
                                                "primaryGame",
                                                uInfo["primaryGame"]);
                                          })
                                      : SizedBox()
                                ]),
                                Column(children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 20.w,
                                        top: 10.h,
                                        bottom: 0.h,
                                        right: 25.w),
                                    child: Text(
                                      "Secondary Game",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  uInfo["secondaryGame"] == ""
                                      ? SizedBox()
                                      : Card(
                                          elevation: 2,
                                          margin: EdgeInsets.only(
                                              top: 10.h,
                                              left: 20.w,
                                              right: 20.w),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.h))),
                                          child: Container(
                                            height: 65.h,
                                            width: 70.h,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.h)),
                                                image: DecorationImage(
                                                    image: AssetImage(gameImg[
                                                        uInfo[
                                                            "secondaryGame"]]),
                                                    fit: BoxFit.cover)),
                                          )),
                                  isMe
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.edit_rounded,
                                            size: 15.h,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            _showDropEdit1Dialog(
                                                "Secondary Game",
                                                "secondaryGame",
                                                uInfo["secondaryGame"]);
                                          })
                                      : SizedBox()
                                ]),
                              ]),
                          SizedBox(
                            height: 40.h,
                          ),
                          GestureDetector(
                            child: Container(
                              width: 360.w,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.h))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FaIcon(
                                    FontAwesomeIcons.facebook,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    "InGameName's Facebook",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  isMe
                                      ? Icon(
                                          Icons.edit_rounded,
                                          size: 15.h,
                                          color: Colors.green,
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                            onTap: isMe
                                ? () {
                                    _showEdit1Dialog("Facebook", "facebook",
                                        uInfo["facebook"]);
                                  }
                                : () async {
                                    var url = uInfo["facebook"];
                                    if (await canLaunch(url))
                                      await launch(url);
                                    else
                                      // can't launch url, there is some error
                                      print('Url Launch Failed');
                                  },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          GestureDetector(
                            child: Container(
                              width: 360.w,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.h))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FaIcon(
                                    FontAwesomeIcons.instagram,
                                    color: Colors.pink,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    "InGameName's Instagram",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  isMe
                                      ? Icon(
                                          Icons.edit_rounded,
                                          size: 15.h,
                                          color: Colors.green,
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                            onTap: isMe
                                ? () {
                                    _showEdit1Dialog("Instagram", "instagram",
                                        uInfo["instagram"]);
                                  }
                                : () async {
                                    var url = uInfo["instagram"];
                                    if (await canLaunch(url))
                                      await launch(url);
                                    else
                                      // can't launch url, there is some error
                                      print('Url Launch Failed');
                                  },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          GestureDetector(
                            child: Container(
                              width: 360.w,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.h))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FaIcon(
                                    FontAwesomeIcons.youtube,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    "InGameName's YouTube",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  isMe
                                      ? Icon(
                                          Icons.edit_rounded,
                                          size: 15.h,
                                          color: Colors.green,
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                            onTap: isMe
                                ? () {
                                    _showEdit1Dialog(
                                        "YouTube", "youtube", uInfo["youtube"]);
                                  }
                                : () async {
                                    var url = uInfo["youtube"];
                                    if (await canLaunch(url))
                                      await launch(url);
                                    else
                                      // can't launch url, there is some error
                                      print('Url Launch Failed');
                                  },
                          ),
                          SizedBox(
                            height: 50.h,
                          )
                        ],
                      );
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ])));
  }
}
