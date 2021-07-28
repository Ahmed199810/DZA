import 'package:doctors/ui/auth/register.dart';
import 'package:doctors/ui/auth/verify_phone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final txtPhoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 90.0,
        child: Image.asset('assets/images/doctor2.png'),
      ),
    );

    final phone = TextFormField(
      textAlign: TextAlign.right,
      maxLength: 11,
      controller: txtPhoneController,
      keyboardType: TextInputType.phone,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'رقم المحمول',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          String phone = txtPhoneController.text;
          if (phone == ""){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("ادخل رقم المحمول"),));
            return;
          }

          if (phone.length < 11){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("ادخل رقم صحيح"),));
            return;
          }

          loginUser(phone);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('تفعيل', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final registerPageButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
                return new RegisterPage();
              }));
            },
            padding: EdgeInsets.all(12),
            child: new Text("ليس لديك حساب ؟ انشاء", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            phone,
            SizedBox(height: 8.0),
            loginButton,
            registerPageButton,
          ],
        ),
      ),
    );
  }

  void loginUser(String phone) {
    Navigator.of(context).pop();
    Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
      return new VerifyPhone(type: true, phone: txtPhoneController.text, doctorData: null,); // true type --> login
    }));
  }
}