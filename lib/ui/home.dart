import 'package:doctors/repositories/localdata/user_data.dart';
import 'package:doctors/ui/auth/register.dart';
import 'package:doctors/ui/history.dart';
import 'package:doctors/ui/notifications.dart';
import 'package:doctors/ui/reservations.dart';
import 'package:doctors/utils/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'conversations.dart';
import 'doctor_profile.dart';

class HomePage extends StatefulWidget {

  final String myTokenId;

  const HomePage({Key key, this.myTokenId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    // check doctor state
    checkDoctorState();
  }


  @override
  Widget build(BuildContext context) {

    final List<Widget> _children = [
      NotificationsPage(),
      ConversationsPage(myTokenId: widget.myTokenId,),
      ReservationPage(),
      HistoryPage(),
      DoctorProfilePage()
    ];

    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // this will be set when a new tab is tapped
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: new Icon(Icons.notifications),
            title: new Text('اشعارات'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: new Icon(Icons.chat),
            title: new Text('محادثات'),
          ),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.date_range),
              title: Text('الحجوزات')
          ),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.history),
              title: Text('السجل')
          ),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.account_circle),
              title: Text('صفحتي')
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> checkDoctorState() async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.subscribeToTopic('notifications_doctors');
    FirebaseAuth auth = FirebaseAuth.instance;

    String userId = AppConstants.currentUserId;
    var doctorsRef = FirebaseDatabase.instance
        .reference()
        .child(AppConstants.doctors);

    await doctorsRef.once().then((snapshot) async {
      print("Checking in Doctors....");
      if (snapshot.value == null) {
        print("No Data In Doctors");
        // no doctors at all
        // not registered register new doctor here
        print("Doctor is not Registered before");
        // sign out here
        auth.signOut();
      }else{
        Map doctors = snapshot.value;
        if(doctors.containsKey(userId)){
          print("Exist In Doctors");

          // check doctor state

          if(doctors[userId].containsKey('doctor_state')){
            print("new version");

            // checking state

            if(doctors[userId]['doctor_state'] == "0" || doctors[userId]['doctor_state'] == "1"){ // waiting for activation

            } else { // 2 ==> span ==> dot open app and show message
              Navigator.pop(context);
              // sign out here
              auth.signOut();
            }


          }else{
            print("old version");

          }

        }else{
          // not registered
          print("Doctor is not Registered before");
          // sign out here
          auth.signOut();
        }
      }
    });

    // updating token
    var tokensRef = FirebaseDatabase.instance
        .reference()
        .child(AppConstants.tokenIds);

    await tokensRef.child(userId).child("token").set(widget.myTokenId);

  }

}