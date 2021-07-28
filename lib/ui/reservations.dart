import 'package:doctors/repositories/remotedata/firebase_conn.dart';
import 'package:doctors/ui/reservations_preview.dart';
import 'package:doctors/utils/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {

  BuildContext context;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var stream = FirebaseDatabase.instance
        .reference()
        .child(AppConstants.appointments)
        .child(AppConstants.currentUserId)
        .orderByValue()
        .onValue;

    var streamBuilder = new StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          FirebaseConn fbconn = new FirebaseConn(map);
          int length = map == null ? 0 : map.keys.length;
          final firstList = new Flexible(
            child: new ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: length,
              itemBuilder: (context, index) {
                Map reservations = fbconn.getDataAsList()[index]['reservations'];
                int numRes = reservations == null? 0 : reservations.length;
                final row = new GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
                      return new ReservationsPreview(reservations: reservations);
                    }));
                  },
                  child: new Card(
                    elevation: 5,
                    shadowColor: Colors.blue,
                    child: new SafeArea(
                      top: false,
                      bottom: false,
                      child: new Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 8.0, bottom: 8.0, right: 8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Expanded(
                              child: new Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: 30,
                                      height: 30,
                                      child: new Text(numRes.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(10.0)
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            new Text(
                                              fbconn.getDataAsList()[index]['day'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                            const Padding(
                                                padding: const EdgeInsets.only(top: 5.0)),
                                            new Text(" من " +
                                                fbconn.getDataAsList()[index]['start_hr'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                            const Padding(
                                                padding: const EdgeInsets.only(top: 5.0)),
                                            new Text(" الي " +
                                                fbconn.getDataAsList()[index]['end_hr'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                            const Padding(
                                                padding: const EdgeInsets.only(top: 5.0)),
                                          ],
                                        ),
                                        SizedBox(width: 30,),
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.blue,
                                          child: Icon(Icons.date_range, color: Colors.white,),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
            ),
          );

          if (map == null) {
            return new Container(
              constraints: const BoxConstraints(maxHeight: 500.0),
              child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          margin: new EdgeInsets.only(top: 00.0, bottom: 0.0),
                          height: 150.0,
                          width: 150.0,
                          child: new Image.asset('assets/images/doctor2.png')),
                      new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Text(
                          "You have no Reservations ...",
                          style: new TextStyle(fontSize: 14.0, color: Colors.black),
                        ),
                      ),
                    ],
                  )),
            );
          } else {
            return new Column(
                children: [
                  firstList
                ]);
          }
        } else {
          return new Center(
              child: new Center(child: new CircularProgressIndicator()));
        }
      },
    );

    return Scaffold(
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {

          },
          child: new Text(
            "الحجوزات",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: streamBuilder,
    );

  }


}
