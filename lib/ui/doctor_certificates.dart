import 'package:doctors/repositories/remotedata/firebase_conn.dart';
import 'package:doctors/utils/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_certificate.dart';

class DoctorCertificates extends StatefulWidget {

  @override
  _DoctorCertificatesState createState() => _DoctorCertificatesState();
}

class _DoctorCertificatesState extends State<DoctorCertificates> {

  @override
  Widget build(BuildContext context) {
    var stream = FirebaseDatabase.instance
        .reference()
        .child(AppConstants.certificates)
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
                final row = new GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      final key = map.keys.elementAt(index);
                      Map cert = map[key];
                      showDeleteDialog(cert);
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: new Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        fbconn.getDataAsList()[index]['desc'], style: TextStyle(fontWeight: FontWeight.bold),),
                                      const Padding(
                                          padding: const EdgeInsets.only(top: 5.0)),
                                      Image.network(fbconn.getDataAsList()[index]['imgUrl']),
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
                          "You have no Certificates ...",
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
          onLongPress: () {},
          child: new Text(
            "الشهادات",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: streamBuilder,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
            return new AddCertificate();
          }));
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  void showDeleteDialog(Map cert) {
    AlertDialog alert = AlertDialog(
      title: Text("مسح الشهاده ؟"),
      content: FlatButton.icon(
          onPressed: (){
            var certRef = FirebaseDatabase.instance
                .reference()
                .child(AppConstants.certificates)
                .child(AppConstants.currentUserId);
            certRef.child(cert['key']).remove().whenComplete(() => {
              Navigator.pop(context)
            });
          },
          icon: Icon(Icons.delete_forever), label: Text("مسح")),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
