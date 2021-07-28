import 'dart:math';

import 'package:doctors/repositories/localdata/user_data.dart';
import 'package:doctors/ui/auth/register.dart';
import 'package:doctors/ui/home.dart';
import 'package:doctors/utils/app_constants.dart';
import 'package:doctors/utils/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerifyPhone extends StatefulWidget {
  final bool type;
  final BuildContext context;
  final String phone;
  final Map doctorData;

  VerifyPhone({Key key, this.type, this.context, this.phone, this.doctorData, }) : super(key: key);

  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String codeState = "في انتظار كود التفعيل";
  final codeTextController = TextEditingController();
  String status;
  AuthCredential phoneAuthCredential;
  String verificationId;
  int code;
  BuildContext context;

  var requestsRef = FirebaseDatabase.instance
      .reference()
      .child(AppConstants.requests);

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: Colors.blue,
    borderRadius: 5.0,
    text: 'Verifying Please wait...',
  );

  @override
  void initState() {
    super.initState();
    sendVerificationCode(widget.phone);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    final codeText = TextFormField(
      controller: codeTextController,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      autofocus: false,
      maxLength: 6,
      decoration: InputDecoration(
        hintText: 'Code',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final verifyButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () async {
          await submitOTP();
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('تفعيل', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          SizedBox(height: 48.0),
          codeText,
          SizedBox(height: 8.0),
          verifyButton,
          new Text(codeState, textAlign: TextAlign.right,)
        ],
      ),
    );

  }

  Future submitOTP() async {

    String smsCode = codeTextController.text;

    if (smsCode == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("ادخل كود التحقق"),));
      return;
    }

    if (smsCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("ادخل كود التحقق بشكل صحيح"),));
      return;
    }

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

    this.phoneAuthCredential = PhoneAuthProvider.credential(verificationId: this.verificationId, smsCode: smsCode);
    print("AUTH LOGIN CRENTIAL : " + phoneAuthCredential.toString());
    await signIn(verificationId, smsCode);
  }

  Future<void> sendVerificationCode(String phone) async {
    String phoneNumber = "+2" + phone;
    print(phoneNumber);
    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      this.phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
    }

    void verificationFailed(FirebaseAuthException error) {
      print('verificationFailed');
      print(error);
    }

    void codeSent(String verificationId, [int code]) {
      print('codeSent');
      setState(() {
        codeState = "تم ارسال كود التفعيل";
      });
      this.verificationId = verificationId;
      print(verificationId);
      this.code = code;
      print(code.toString());
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

  Future signIn(String verificationId, String smsCode) async {

    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    String userId = "";

    try {
      var firebaseUser = await FirebaseAuth.instance.signInWithCredential(credential);
      print("Login Successful");
      print("USER ID : " + firebaseUser.user.uid);
      userId = firebaseUser.user.uid;
    } catch (e) {
      print("Login not successful");
    }

    if(userId == ""){
      print("ERRRRRRRRRRRROOOORRRR");
      return;
    }
    // search by this use id
    // search in doctors
    checkInDoctors(userId);
  }

  Future<void> checkInDoctors(String userId) async {

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String token = await messaging.getToken(
      vapidKey: "BGpdLRsSDASsdd",
    );

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

        if(widget.type) { // login
          // not registered
          print("Doctor is not Registered before");
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
            return new RegisterPage();
          }));
        }else{ // saving doctor data
          await doctorsRef.child(userId).set(widget.doctorData);

          //save data locally
          await UserData.saveDoctorData(widget.doctorData);
          AppConstants.currentUserId = widget.doctorData['id'];
          AppConstants.currentUser = widget.doctorData;
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
            return new HomePage(myTokenId: token,);
          }));

        }



      }else{
        Map doctors = snapshot.value;
        if(doctors.containsKey(userId)){
          print("Exist In Doctors");

          // check doctor state

          if(doctors[userId].containsKey('doctor_state')){
            print("new version");

            // checking state

            if(doctors[userId]['doctor_state'] == "0"){ // waiting for activation
              //save data locally
              await UserData.saveDoctorData(doctors[userId]);
              AppConstants.currentUserId = doctors[userId]['id'];
              AppConstants.currentUser = doctors[userId];
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
                return new HomePage(myTokenId: token,);
              }));
            }else if(doctors[userId]['doctor_state'] == "1"){ // activated ==> welcome
              //save data locally
              await UserData.saveDoctorData(doctors[userId]);
              AppConstants.currentUserId = doctors[userId]['id'];
              AppConstants.currentUser = doctors[userId];
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
                return new HomePage(myTokenId: token,);
              }));
            }else { // 2 ==> span ==> dot open app and show message
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("حسابك متوقف - تواصل مع الدعم")));
              // sign out here
            }


          }else{
            print("old version");

            // waiting for activation
            //save data locally
            await UserData.saveDoctorData(doctors[userId]);
            AppConstants.currentUserId = doctors[userId]['id'];
            AppConstants.currentUser = doctors[userId];
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
              return new HomePage(myTokenId: token,);
            }));
          }


        }else{
          // not registered
          print("Doctor is not Registered before");

          if(widget.type){ // login
            // not registered
            print("Doctor is not Registered before");
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
              return new RegisterPage();
            }));
          }else{ // register
            // register new doctor here
            widget.doctorData['id'] = userId;
            await doctorsRef.child(userId).set(widget.doctorData);

            //save data locally
            await UserData.saveDoctorData(widget.doctorData);
            AppConstants.currentUserId = userId;
            AppConstants.currentUser = widget.doctorData;
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
              return new HomePage(myTokenId: token,);
            }));
          }

        }
      }
    });
  }

}