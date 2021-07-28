import 'package:doctors/repositories/localdata/user_data.dart';
import 'package:doctors/ui/auth/login.dart';
import 'package:doctors/ui/auth/register.dart';
import 'package:doctors/ui/home.dart';
import 'package:doctors/utils/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Tajawal',
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0)
          )
      ),
      home: SplashS(),
    );
  }
}

class SplashS extends StatefulWidget {
  @override
  _SplashSState createState() => _SplashSState();
}

class _SplashSState extends State<SplashS> {

  BuildContext context;
  Widget statefulWidget = new LoginPage();

  @override
  void initState() {
    super.initState();
    checkUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: statefulWidget,
      title: new Text('DoctorZone Plus', textScaleFactor: 2, style: TextStyle(color: Colors.blue),),
      image: Image.asset("assets/images/doc.png"),
      loadingText: Text("Loading"),
      photoSize: 100.0,
      loaderColor: Colors.blue,
    );
  }

  checkUserLogin() async {
    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // use the returned token to send messages to users from your custom server
    String token = await messaging.getToken(
      vapidKey: "BGpdLRsSDASsdd",
    );

    print("USER TOKEN : " + token);


    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();
    try {
      if (auth.currentUser == null) {
        print('User is currently signed out!');
        setState(() {
          statefulWidget = new RegisterPage();
        });
      } else {
        print('User is signed in!');
        Map doctor = await UserData.getDoctor();
        AppConstants.currentUserId = doctor['id'];
        AppConstants.currentUser = doctor;
        setState(() {
          statefulWidget = new HomePage(myTokenId: token,);
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-action-code') {
        print('The code is invalid.');
      }
    }
  }


}