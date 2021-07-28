import 'package:doctors/repositories/remotedata/firebase_conn.dart';
import 'package:doctors/utils/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';



class CommentsPage extends StatefulWidget {

  final String id;

  const CommentsPage({Key key, this.id}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {

  @override
  Widget build(BuildContext context) {
    var stream = FirebaseDatabase.instance
        .reference()
        .child(AppConstants.comments)
        .child(widget.id)
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

                    },
                    child: Container(
                      child: SafeArea(
                        top: false,
                        bottom: false,
                        child: new Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 8.0, bottom: 8.0, right: 8.0),
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
                                        fbconn.getDataAsList()[index]['user'], style: TextStyle(fontWeight: FontWeight.bold),),
                                      const Padding(
                                          padding: const EdgeInsets.only(top: 5.0)),
                                      new Text(
                                        fbconn.getDataAsList()[index]['comment'], textAlign: TextAlign.end,),
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
                  child: new Column(
                    children: <Widget>[
                      row,
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow:[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 1), // changes position of shadow
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
                          "You have no Comments ...",
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
            "اشعارات",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        child: streamBuilder,
        margin: EdgeInsets.only(top: 10),
      ),
    );
  }


}