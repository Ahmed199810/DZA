import 'package:cloud_functions/cloud_functions.dart';
import 'package:doctors/utils/app_constants.dart';
import 'package:doctors/utils/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {

  final Map conversationItem;
  final String userToken;
  final String myTokenId;
  const ChatPage({Key key, this.conversationItem, this.userToken, this.myTokenId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: Colors.blue,
    borderRadius: 5.0,
  );

  BuildContext context;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final txtMsgController = TextEditingController();

  var messagesRef = FirebaseDatabase.instance
      .reference()
      .child(AppConstants.messages);

  var conversationsRef = FirebaseDatabase.instance
      .reference()
      .child(AppConstants.conversations);


  @override
  Widget build(BuildContext context) {

    this.context = context;

    final txtMsg = TextFormField(
      textAlign: TextAlign.end,
      controller: txtMsgController,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: '...اكتب رساله',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final chatsList = new FirebaseAnimatedList(
      defaultChild: new Center(
        child: new CircularProgressIndicator(),
      ),
      query: FirebaseDatabase.instance
          .reference()
          .child(AppConstants.messages)
          .child(AppConstants.currentUserId)
          .child(widget.conversationItem['conversationId']),
      padding: const EdgeInsets.all(8.0),
      reverse: true,
      sort: (a, b) {
        return b.key.compareTo(a.key);
      },
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation animation, int index) {
        Map msg = snapshot.value;
        print(msg.toString());
        final row = new GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {

          },
          child: SafeArea(
            top: false,
            bottom: false,
            child: new Padding(
              padding: const EdgeInsets.only(
                  left: 0, top: 0, bottom: 0, right: 0),
              child: msg['sentToId'] == AppConstants.currentUserId ?
              Container(
                width: 300,
                padding: const EdgeInsets.only(
                    left: 8.0, top: 8.0, bottom: 8.0, right: 8.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new Text(
                              msg['userName'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            const Padding(
                                padding: const EdgeInsets.only(top: 5.0)),
                            new Text(
                                msg['dateTime'], style: TextStyle(color: Colors.white)),
                            const Padding(
                                padding: const EdgeInsets.only(top: 5.0)),
                            new Text(
                                msg['message'], style: TextStyle(color: Colors.white)),
                            const Padding(
                                padding: const EdgeInsets.only(top: 5.0)),
                          ],
                        ),
                      ),),
                    CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: (msg['userImg'] == 'DoctorZoneSupportImage' || msg['userImg'] == 'default') ? Image.asset('assets/images/doctor2.png') :
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            msg['userImg'],
                            height: 100.0,
                            width: 100.0,
                            fit: BoxFit.cover,
                          ),
                        )
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                  color: Colors.blue,
                  boxShadow:[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
              )
                  :
              Container(
                width: 300,
                padding: const EdgeInsets.only(
                    left: 8.0, top: 8.0, bottom: 8.0, right: 8.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: (msg['userImg'] == 'DoctorZoneSupportImage' || msg['userImg'] == 'default') ? Image.asset('assets/images/doctor2.png') :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          msg['userImg'],
                          height: 100.0,
                          width: 100.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: new Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              msg['userName'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            const Padding(
                                padding: const EdgeInsets.only(top: 5.0)),
                            new Text(
                                msg['dateTime'], style: TextStyle(color: Colors.white)),
                            const Padding(
                                padding: const EdgeInsets.only(top: 5.0)),
                            new Text(
                                msg['message'], style: TextStyle(color: Colors.white)),
                            const Padding(
                                padding: const EdgeInsets.only(top: 5.0)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                  color: Colors.lightBlueAccent,
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
            ),
          ),
        );
        return new Container(
          alignment: msg['sentToId'] == AppConstants.currentUserId ? Alignment.centerRight : Alignment.centerLeft,
          margin:
          new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
          child: new Column(
            children: <Widget>[
              row,
            ],
          ),
        );
      },
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: Text(widget.conversationItem['userName'].toString()),
        centerTitle: false,
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 50),
        child: chatsList,
      ),
      bottomSheet: Container(
        height: 60,
        color: Colors.white,
        child:  new ListTile(
          title: txtMsg,
          trailing: GestureDetector(
            onTap: (){
              sendMessage();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.blue,
              ),
              width: 50,
              height: 50,
              child: Icon(Icons.send, color: Colors.white,),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendMessage() async {

    if(txtMsgController.text != ""){

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


      String key = messagesRef.child(AppConstants.currentUserId).child(widget.conversationItem['conversationId']).push().key;


      String myToken = widget.myTokenId;
      print("MMMMMMMMYYYYYYYYY : " + myToken);

      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getDateTime');
      final results = await callable();
      var dateTime = results.data;
      var date = DateTime.fromMillisecondsSinceEpoch(dateTime);
      print("DDDDDDDDDDDDDDDD : " + date.toString());
      String currentData = "";
      if(date.toString().length > 19){
        currentData = date.toString().substring(0, 19);
      }else {
        currentData = date.toString();
      }

      setState(() {

        // my messages
        messagesRef.child(AppConstants.currentUserId).child(widget.conversationItem['conversationId']).child(key).set({
          "conversationId": widget.conversationItem['conversationId'],
          "dateTime": currentData,
          "message": txtMsgController.text,
          "messageImg": "",
          "msgId": key,
          "sentToId": widget.conversationItem['conversationId'].toString().replaceAll(AppConstants.currentUserId, ""),
          "sentToTokenId": widget.userToken,
          "userId": AppConstants.currentUserId,
          "userImg": AppConstants.currentUser['img'],
          "userName": AppConstants.currentUser['user']
        }).catchError((e) {

        });

        // the other messages
        messagesRef.child(widget.conversationItem['conversationId'].toString().replaceAll(AppConstants.currentUserId, "")).child(widget.conversationItem['conversationId']).child(key).set({
          "conversationId": widget.conversationItem['conversationId'],
          "dateTime": currentData,
          "message": txtMsgController.text,
          "messageImg": "",
          "msgId": key,
          "sentToId": widget.conversationItem['conversationId'].toString().replaceAll(AppConstants.currentUserId, ""),
          "sentToTokenId": myToken,
          "userId": AppConstants.currentUserId,
          "userImg": AppConstants.currentUser['img'],
          "userName": AppConstants.currentUser['user']
        }).catchError((e) {

        });

        // the other conversation
        conversationsRef.child(widget.conversationItem['conversationId'].toString().replaceAll(AppConstants.currentUserId, "")).child(widget.conversationItem['conversationId']).update({
          "conversationId": widget.conversationItem['conversationId'],
          "dateTime": currentData,
          "lastMessage": txtMsgController.text,
          "userId": AppConstants.currentUserId,
          "userImg": AppConstants.currentUser['img'],
          "userName": AppConstants.currentUser['user']
        }).catchError((e) {

        });

        // my conversation
        conversationsRef.child(AppConstants.currentUserId).child(widget.conversationItem['conversationId']).update({
          "dateTime": currentData,
          "lastMessage": txtMsgController.text,
        }).catchError((e) {

        });

        txtMsgController.text = "";

        Navigator.pop(context);

      });
    }

  }


}