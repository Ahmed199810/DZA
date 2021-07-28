import 'package:doctors/repositories/localdata/user_data.dart';
import 'package:doctors/repositories/remotedata/firebase_conn.dart';
import 'package:doctors/utils/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  BuildContext context;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  Map doctor;

  @override
  void initState() {
    super.initState();
    getUserLocalData();
  }

  @override
  Widget build(BuildContext context) {


    var notificationsList = new FirebaseAnimatedList(
      defaultChild: new Center(
        child: new CircularProgressIndicator(),
      ),
      query: FirebaseDatabase.instance
          .reference()
          .child(AppConstants.notifications),
      padding: const EdgeInsets.all(8.0),
      reverse: false,
      sort: (a, b) {
        return b.key.compareTo(a.key);
      },
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation animation, int index) {
        Map notificationItem = snapshot.value;

        if(!(notificationItem['location'] == "0" ||
            (notificationItem['location'] == AppConstants.currentUser['location'] && notificationItem['sub_location'] == "0") ||
            (notificationItem['location'] == AppConstants.currentUser['location'] && notificationItem['sub_location'] == AppConstants.currentUser['sub_location'])
        )){
          return Container();
        }

        final row = new GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              String urlIf = notificationItem['body'].toString().substring(notificationItem['body'].toString().indexOf('http'));
              _launchURL(urlIf);
            },
            child: new Card(
              shadowColor: Colors.blue,
              elevation: 5,
              child: new SafeArea(
                top: false,
                bottom: false,
                child: new Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 8.0, bottom: 8.0, right: 8.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 12.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              new Text(
                                notificationItem['title'], style: TextStyle(fontWeight: FontWeight.bold),),
                              const Padding(
                                  padding: const EdgeInsets.only(top: 5.0)),
                              new Text(
                                notificationItem['body'], textAlign: TextAlign.end,),
                              const Padding(
                                  padding: const EdgeInsets.only(top: 5.0)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        );
        return new Container(
          margin:
          new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
          color: Colors.white,
          child: new Column(
            children: <Widget>[
              row,
              new Container(
                height: 1.0,
                color: Colors.black12.withAlpha(10),
              ),
            ],
          ),
        );
      },
    );

    return Scaffold(
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "اشعارات",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: notificationsList,
    );
  }

  Future getUserLocalData() async {
    doctor = await UserData.getDoctor();
    print(doctor);
  }

  _launchURL(String urlStr) async {
    if (await canLaunch(urlStr)) {
      await launch(urlStr);
    } else {
      throw 'Could not launch $urlStr';
    }
  }

}
