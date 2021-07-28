import 'package:doctors/ui/chat.dart';
import 'package:doctors/utils/app_constants.dart';
import 'package:doctors/utils/progress.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConversationsPage extends StatefulWidget {
  final String myTokenId;

  const ConversationsPage({Key key, this.myTokenId}) : super(key: key);
  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {

  BuildContext context;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: Colors.blue,
    borderRadius: 5.0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var conversationsList = new FirebaseAnimatedList(
      defaultChild: new Center(
        child: new CircularProgressIndicator(),
      ),
      query: FirebaseDatabase.instance
          .reference()
          .child(AppConstants.conversations)
          .child(AppConstants.currentUserId),
      padding: const EdgeInsets.all(8.0),
      reverse: false,
      sort: (a, b) {
        return b.value['dateTime'].compareTo(a.value['dateTime']);
      },
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation animation, int index) {
        Map conversationItem = snapshot.value;
        final row = new GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            openChat(conversationItem, context);
          },
          child: Container(
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
                              conversationItem['userName'], style: TextStyle(fontWeight: FontWeight.bold),),
                            const Padding(
                                padding: const EdgeInsets.only(top: 5.0)),
                            new Text(
                                conversationItem['lastMessage']),
                            const Padding(
                                padding: const EdgeInsets.only(top: 5.0)),
                            new Text(
                                conversationItem['dateTime']),
                            const Padding(
                                padding: const EdgeInsets.only(top: 5.0)),
                          ],
                        ),
                      ),
                    ),
                    CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: (conversationItem['userImg'] == 'DoctorZoneSupportImage' || conversationItem['userImg'] == 'default') ? Image.asset('assets/images/doctor2.png') :
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            conversationItem['userImg'],
                            height: 100.0,
                            width: 100.0,
                            fit: BoxFit.cover,
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
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
    );

    return Scaffold(
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "المحادثات",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: conversationsList,
    );
  }

  Future<void> openChat(Map conversationItem, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: progress,
        );
      },
    );

    var tokensRef = FirebaseDatabase.instance
        .reference()
        .child(AppConstants.tokenIds);
    String userToken = "";
    await tokensRef.once().then((snapshot) async {
      if (snapshot.value == null) {
        print("No Data In Tokens");
      }else{
        Map usersTokens = snapshot.value;
        if(usersTokens.containsKey(conversationItem['sentToId'])){
          userToken = usersTokens[conversationItem['sentToId']]['token'];
        }
      }
      Navigator.pop(context);
      Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
        return new ChatPage(conversationItem: conversationItem, userToken: userToken, myTokenId: widget.myTokenId,);
      }));
    });


  }


}