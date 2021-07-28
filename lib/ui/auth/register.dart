import 'package:doctors/repositories/remotedata/firebase_conn.dart';
import 'package:doctors/ui/auth/verify_phone.dart';
import 'package:doctors/utils/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final txtEmailController = TextEditingController();
  final txtUserController = TextEditingController();
  final txtPhoneController = TextEditingController();

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  int selectedJobIndex = 0;
  int selectedLocationIndex = 0;
  int selectedSubLocationIndex = 0;

  String selectedJob;

  List<String> jobsList = new List();


  BuildContext context;


  String selectedLocation = "اختر المحافظه";
  String selectedSubLocation = "اختر المدينه";

  Map cities;

  List<String> locationsList = new List();
  List<String> subLocationsList = new List();

  var govStream = FirebaseDatabase.instance
      .reference()
      .child(AppConstants.cities)
      .orderByValue()
      .onValue;

  var cityStream = FirebaseDatabase.instance
      .reference()
      .child(AppConstants.sub_cities)
      .orderByValue()
      .onValue;

  @override
  void initState() {
    super.initState();
    getJobs();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    final email = TextFormField(
      controller: txtEmailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      textAlign: TextAlign.end,
      decoration: InputDecoration(
        hintText: 'الايميل (اختياري)',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final name = TextFormField(
      controller: txtUserController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      textAlign: TextAlign.end,
      decoration: InputDecoration(
        hintText: 'الاسم',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final phone = TextFormField(
      controller: txtPhoneController,
      keyboardType: TextInputType.phone,
      autofocus: false,
      textAlign: TextAlign.end,
      maxLength: 11,
      decoration: InputDecoration(
        hintText: 'رقم المحمول',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final jobsSpinner = new Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: new Padding(
        padding: const EdgeInsets.all(1.0),
        child: new DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: jobsList.map((String val) {
                return new DropdownMenuItem<String>(
                  value: val,
                  child: new Text(val, textAlign: TextAlign.right,),
                );
              }).toList(),
              hint: Text("اختر المهنه", textAlign: TextAlign.right,),
              value: selectedJob,
              onChanged: onChangeJob,
            )
        ),
      ),
    );

    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          registerNewUser();
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('تفعيل', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final loginPageButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
                return new LoginPage();
              }));
            },
            padding: EdgeInsets.all(12),
            child: new Text("لديك حساب ؟ دخول", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))
    );

    var govStreamBuilder = new StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          if (map == null) {
            return new Container(

            );
          } else {
            getGov(map);
            return new Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: new Padding(
                padding: const EdgeInsets.all(1.0),
                child: new DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      items: locationsList.map((String val) {
                        return new DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val, textAlign: TextAlign.right,),
                        );
                      }).toList(),
                      hint: Text(selectedLocation, textAlign: TextAlign.right,),
                      //value: selectedLocation,
                      onChanged: onGovChanged,
                      onTap: (){

                      },
                    )
                ),
              ),
            );
          }
        } else {
          return new Center(
              child: new Center(child: new CircularProgressIndicator()));
        }
      },
      stream: govStream,
    );

    var cityStreamBuilder = new StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          if (map == null) {
            return new Container(

            );
          } else {
            getCities(map, selectedLocation);
            return new Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: new Padding(
                padding: const EdgeInsets.all(1.0),
                child: new DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      items: subLocationsList.map((String val) {
                        return new DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val, textAlign: TextAlign.right,),
                        );
                      }).toList(),
                      hint: Text(selectedSubLocation, textAlign: TextAlign.right,),
                      //value: selectedLocation,
                      onChanged: onCityChanged,
                      onTap: (){

                      },
                    )
                ),
              ),
            );
          }
        } else {
          return new Center(
              child: new Center(child: new CircularProgressIndicator()));
        }
      },
      stream: cityStream,
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            name,
            SizedBox(height: 8.0),
            phone,
            SizedBox(height: 8.0),
            jobsSpinner,
            SizedBox(height: 8.0),
            govStreamBuilder,
            SizedBox(height: 8.0,),
            cityStreamBuilder,
            SizedBox(height: 8.0),
            registerButton,
            loginPageButton
          ],
        ),
      ),
    );
  }

  void onChangeSubLocation(String value) {
    setState(() {
      selectedSubLocation = value;
      selectedSubLocationIndex = 1;
    });
  }

  void onChangeJob(String value) {
    setState(() {
      selectedJob = value;
      selectedJobIndex = jobsList.indexOf(value);
    });
  }


  void getJobs() {
    jobsList.add("اختر المهنه");
    jobsList.add("-----------------------");
    jobsList.add("طبيب");
    jobsList.add("مستشفيات خاصه");
    jobsList.add("مستشفيات عامه");
    jobsList.add("مراكز طبيه خاصه");
    jobsList.add("مراكز طبيه خيريه");
    jobsList.add("معامل تحاليل");
    jobsList.add("مراكز اشعه");
    jobsList.add("صيدليات");
    jobsList.add("مستلزمات طبيه");
    jobsList.add("خدمات طبيه");
    jobsList.add("تبرعات");
    jobsList.add("وحدات صحيه حكوميه");
  }

  void registerNewUser() {
    String user = txtUserController.text;
    String mail = txtEmailController.text;
    String phone = txtPhoneController.text;

    if (mail == "") {
      mail = "email";
    }
    if (user == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("ادخل اسم المستخدم"),));
      return;
    }
    if (phone == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("ادخل رقم المحمول"),));
      return;
    }
    if (phone.length < 11) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("ادخل رقم صحيح"),));
      return;
    }
    if (selectedJobIndex == 0 || selectedJobIndex == 1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("اختر المهنه"),));
      return;
    }
    if (selectedLocationIndex == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("اختر المحافظه"),));
      return;
    }
    if (selectedSubLocationIndex == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("اختر المدينه"),));
      return;
    }

    Map doctorMap = new Map();
    doctorMap['user'] = txtUserController.text;
    doctorMap['email'] = mail;
    doctorMap['type'] = selectedJobIndex.toString();
    doctorMap['dep'] = "غير محدد";
    doctorMap['show_price'] = "0";
    doctorMap['state'] = "0";
    doctorMap['price'] = "0";
    doctorMap['reservation'] = "0";
    doctorMap['rating'] = 0;
    doctorMap['rate_num'] = "0";
    doctorMap['desc'] = "Description";
    doctorMap['house_visit'] = "0";
    doctorMap['id'] = "";
    doctorMap['lat'] = 0;
    doctorMap['lng'] = 0;
    doctorMap['loc_desc'] = "";
    doctorMap['location'] = selectedLocation; // city
    doctorMap['sub_location'] = selectedSubLocation; // sub city
    doctorMap['discount'] = "0";
    doctorMap['niqabat'] = "0";
    doctorMap['pass'] = "pass";
    doctorMap['phone'] = txtPhoneController.text;
    doctorMap['img'] = "default";
    doctorMap['doctor_state'] = "0"; // default value ==> waiting

    Navigator.of(context).pop();
    Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
      return new VerifyPhone(type: false, phone: txtPhoneController.text, doctorData: doctorMap,); // false type --> register
    }));

  }

  getGov(Map map) {
    locationsList.clear();
    map.forEach((key, value) {
      Map c = value;
      if (c['id'] != '-MB6N15DAD4NHv6DVJpz'){
        locationsList.add(c['name']);
      }
    });
  }

  void getCities(Map map, String gov) {
    cities = map;
    subLocationsList.clear();
    map.forEach((key, value) {
      Map c = value;
      if (c['gov'] == gov){
        subLocationsList.add(c['name']);
      }
    });
  }

  void onGovChanged(String value) {
    setState(() {
      selectedSubLocation = "اختر المدينه";
      getCities(cities, selectedLocation);
      selectedLocation = value;
      selectedLocationIndex = 1;
      selectedSubLocationIndex = 0;
    });
  }

  void onCityChanged(String value) {
    setState(() {
      selectedSubLocation = value;
      selectedSubLocationIndex = 1;
    });
  }


}