import 'dart:io';

import 'package:doctors/repositories/localdata/user_data.dart';
import 'package:doctors/repositories/remotedata/firebase_conn.dart';
import 'package:doctors/ui/maps.dart';
import 'package:doctors/utils/app_constants.dart';
import 'package:doctors/utils/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appointments.dart';
import 'auth/login.dart';
import 'comments.dart';
import 'doctor_certificates.dart';

class DoctorProfilePage extends StatefulWidget {

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  final txtNameController = TextEditingController();
  final txtPhoneController = TextEditingController();
  final txtPriceController = TextEditingController();
  final txtDiscountController = TextEditingController();
  final txtLocController = TextEditingController();
  final txtLocDiscController = TextEditingController();
  final txtEmailController = TextEditingController();
  final txtDescController = TextEditingController();

  File imgProfile;
  final picker = ImagePicker();

  String selectedLocation = "";
  String selectedSubLocation = "";
  String selectedDep = "";
  int reservation = 0;
  int state = 0;
  int showPrice = 0;
  int house = 0;
  int niqabat = 0;

  Map cities;

  String userImage = "";

  var lat;
  var lng;


  List<String> locationsList = new List();
  List<String> subLocationsList = new List();
  List<String> depList = new List();
  List<String> reservationList = new List();
  List<String> stateList = new List();
  List<String> priceList = new List();
  List<String> houseList = new List();
  List<String> niqabatList = new List();

  Map currentDoctor;

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: Colors.blue,
    borderRadius: 5.0,
    text: 'Saving Please wait...',
  );

  BuildContext context;

  var doctorsRef = FirebaseDatabase.instance
      .reference()
      .child(AppConstants.doctors);

  @override
  void initState() {
    super.initState();
    initLists();
    getUserData();
  }


  @override
  Widget build(BuildContext context) {
    this.context = context;

    final reservationSpinner = new Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: new Padding(
        padding: const EdgeInsets.all(1.0),
        child: new DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: reservationList.map((String val) {
                return new DropdownMenuItem<String>(
                  value: val,
                  child: new Text(val, textAlign: TextAlign.right,),
                );
              }).toList(),
              hint: Text(reservationList[reservation], textAlign: TextAlign.right,),
              //value: selectedLocation,
              onChanged: onReservationChanged,
              onTap: (){

              },
            )
        ),
      ),
    );

    final stateSpinner = new Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: new Padding(
        padding: const EdgeInsets.all(1.0),
        child: new DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: stateList.map((String val) {
                return new DropdownMenuItem<String>(
                  value: val,
                  child: new Text(val, textAlign: TextAlign.right,),
                );
              }).toList(),
              hint: Text(stateList[state], textAlign: TextAlign.right,),
              //value: selectedLocation,
              onChanged: onStateChanged,
              onTap: (){

              },
            )
        ),
      ),
    );

    final showPriceSpinner = new Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: new Padding(
        padding: const EdgeInsets.all(1.0),
        child: new DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: priceList.map((String val) {
                return new DropdownMenuItem<String>(
                  value: val,
                  child: new Text(val, textAlign: TextAlign.right,),
                );
              }).toList(),
              hint: Text(priceList[showPrice], textAlign: TextAlign.right,),
              //value: selectedLocation,
              onChanged: onShowPriceChanged,
              onTap: (){

              },
            )
        ),
      ),
    );

    final houseSpinner = new Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: new Padding(
        padding: const EdgeInsets.all(1.0),
        child: new DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: houseList.map((String val) {
                return new DropdownMenuItem<String>(
                  value: val,
                  child: new Text(val, textAlign: TextAlign.right,),
                );
              }).toList(),
              hint: Text(houseList[house], textAlign: TextAlign.right,),
              //value: selectedLocation,
              onChanged: onHouseChanged,
              onTap: (){

              },
            )
        ),
      ),
    );

    final niqabatSpinner = new Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: new Padding(
        padding: const EdgeInsets.all(1.0),
        child: new DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: niqabatList.map((String val) {
                return new DropdownMenuItem<String>(
                  value: val,
                  child: new Text(val, textAlign: TextAlign.right,),
                );
              }).toList(),
              hint: Text(niqabatList[niqabat], textAlign: TextAlign.right,),
              //value: selectedLocation,
              onChanged: onNiqabatChanged,
              onTap: (){

              },
            )
        ),
      ),
    );

    final txtName = TextFormField(
      textAlign: TextAlign.end,
      controller: txtNameController,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'الاسم',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final txtPhone = TextFormField(
      textAlign: TextAlign.end,
      controller: txtPhoneController,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'التليفون',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final txtPrice = TextFormField(
      textAlign: TextAlign.end,
      controller: txtPriceController,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'قيمه الكشف',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final txtDiscount = TextFormField(
      textAlign: TextAlign.end,
      controller: txtDiscountController,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'خصم التطبيق',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final txtLocation = TextFormField(
      textAlign: TextAlign.end,
      controller: txtLocController,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        fillColor: Colors.white,
        hintText: 'الموقع',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final txtLocDesc = TextFormField(
      textAlign: TextAlign.end,
      controller: txtLocDiscController,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'وصف المكان',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final txtEmail = TextFormField(
      textAlign: TextAlign.end,
      controller: txtEmailController,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'الايميل',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final txtDesc = TextFormField(
      textAlign: TextAlign.end,
      controller: txtDescController,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'نبزه عامه',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

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

    var depStream = FirebaseDatabase.instance
        .reference()
        .child(AppConstants.departments)
        .orderByValue()
        .onValue;

    var ratingStream = FirebaseDatabase.instance
        .reference()
        .child(AppConstants.ratings)
        .child(AppConstants.currentUserId)
        .orderByValue()
        .onValue;


    var ratingStreamBuilder = new StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          if (map == null) {
            return new Container(
              child: Text("حوالي 0 تقيم من المستخدمين", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold),),
            );
          } else {
            return new Container(
              alignment: Alignment.center,
              child: Text("حوالي " + map.keys.length.toString() + " تقيم من المستخدمين", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold),),
            );
          }
        } else {
          return new Center(
              child: new Center(child: new CircularProgressIndicator()));
        }
      },
      stream: ratingStream,
    );

    var govStreamBuilder = new StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          FirebaseConn fbconn = new FirebaseConn(map);
          print("MAP DOCTOR : " + map.toString());
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
          print("MAP DOCTOR : " + map.toString());
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

    var depStreamBuilder = new StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          print("MAP DOCTOR : " + map.toString());
          if (map == null) {
            return new Container(

            );
          } else {
            getDep(map);
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
                      items: depList.map((String val) {
                        return new DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val, textAlign: TextAlign.right,),
                        );
                      }).toList(),
                      hint: Text(selectedDep, textAlign: TextAlign.right,),
                      //value: selectedLocation,
                      onChanged: onDepChanged,
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
      stream: depStream,
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Row(
            children: <Widget>[
              FlatButton.icon(
                  onPressed: (){
                    signOutUser();
                  },
                  icon: Icon(Icons.exit_to_app, color: Colors.white,),
                  label: Text("تسجيل خروج", style: TextStyle(color: Colors.white),)
              ),
            ],
          ),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: (){
                validateData();
              },
              icon: Icon(Icons.save, color: Colors.white,),
              label: Text("حفظ", style: TextStyle(color: Colors.white),)
          ),

        ],
      ),
      body: Center(
        child: currentDoctor == null ?
        new Center(child: new CircularProgressIndicator())
            :
        Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.blue,
                        child: ClipOval(
                          child: imgProfile == null ? new Container(
                            child: currentDoctor['img'] == ""? Image.asset('assets/images/doctor2.png'): ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                currentDoctor['img'],
                                height: 160.0,
                                width: 160.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ) : new Image.file(new File(
                            imgProfile.path,
                          ),
                            width: 160.0,
                            height: 160.0,
                            fit: BoxFit.cover,
                          ),),
                      ),
                      new FloatingActionButton(
                        backgroundColor: Colors.grey,
                        mini: false,
                        onPressed: () {
                          selectImage();
                        },
                        tooltip: 'اختر صوره',
                        child: new Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20, left: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text("تقيمات", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton.icon(
                              icon: Icon(Icons.star, color: Colors.yellow,),
                              label: Text(currentDoctor['rating'].toString()),
                              onPressed: (){

                              },
                            ),
                          ],
                        ),
                        ratingStreamBuilder,
                        //Text("حوالي 0 تقيم من المستخدمين", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(
                          height: 20,
                        )
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                new ListTile(
                                  title: txtName,
                                  trailing: Container(width: 80, child: Text('الاسم ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                new ListTile(
                                  title: depStreamBuilder,
                                  trailing: Container(width: 80, child: Text('التخصص ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                new ListTile(
                                  title: txtPhone,
                                  trailing: Container(width: 80, child: Text('رقم التليفون ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                new ListTile(
                                  title: reservationSpinner,
                                  trailing: Container(width: 80, child: Text('طريق الحجز  ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
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
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                new ListTile(
                                  leading: new CircleAvatar(
                                    radius: 10,
                                    backgroundColor: state == 1 ? Colors.green: Colors.red,
                                  ),
                                  title: stateSpinner,
                                  trailing: Container(width: 80, child: Text('الوضعيه ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                new ListTile(
                                  title: showPriceSpinner,
                                  trailing: Container(width: 80, child: Text('عرض الكشف ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                new ListTile(
                                  title: txtPrice,
                                  trailing: Container(width: 80, child: Text('قيمه الكشف ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                new ListTile(
                                  title: txtDiscount,
                                  trailing: Container(width: 80, child: Text('خصم التطبيق ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
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
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                new ListTile(
                                  title: houseSpinner,
                                  trailing: Container(width: 80, child: Text('كشف منزلي ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                new ListTile(
                                  title: niqabatSpinner,
                                  trailing: Container(width: 80, child: Text('نقابات وتعاقدات ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                new ListTile(
                                  title: txtEmail,
                                  trailing: Container(width: 80, child: Text('الايميل ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                new ListTile(
                                  title: txtDesc,
                                  trailing: Container(width: 80, child: Text('نبزه عامه ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
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
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                new ListTile(
                                  trailing: Container(width: 80, child: Text('الموقع ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                  leading: GestureDetector(
                                    onTap: (){
                                      openMaps();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      width: 50,
                                      height: 50,
                                      child: Icon(Icons.location_on, color: Colors.white,),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.blue
                                      ),
                                    ),
                                  ),
                                ),
                                new ListTile(
                                  title: govStreamBuilder,
                                  trailing: Container(width: 80, child: Text('المحافظه ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                new ListTile(
                                  title: cityStreamBuilder,
                                  trailing: Container(width: 80, child: Text('المدينه ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                new ListTile(
                                  title: txtLocDesc,
                                  trailing: Container(width: 80, child: Text('تفاصيل الموقع ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
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
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
                            child: Column(
                              children: [
                                new ListTile(
                                  title: FlatButton.icon(onPressed: (){
                                    Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
                                      return new DoctorCertificates();
                                    }));
                                  }, icon: Icon(Icons.insert_drive_file, color: Colors.black,), label: Text("")),
                                  trailing: Container(width: 80, child: Text('شهادات', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                new ListTile(
                                  title: FlatButton.icon(onPressed: (){
                                    Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
                                      return new AppointmentsPage(id: currentDoctor['id'],);
                                    }));
                                  }, icon: Icon(Icons.date_range, color: Colors.black,), label: Text("")),
                                  trailing: Container(width: 80, child: Text('مواعيد العمل', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                new ListTile(
                                  title: FlatButton.icon(onPressed: (){
                                    Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
                                      return new CommentsPage(id: currentDoctor['id']);
                                    }));
                                  }, icon: Icon(Icons.comment, color: Colors.black,), label: Text("")),
                                  trailing: Container(width: 80, child: Text('اراء المستخدم', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                new ListTile(
                                  title: FlatButton.icon(onPressed: (){
                                    Share.share(currentDoctor['user'] + "\n" + currentDoctor['loc_desc'] + "\n" + currentDoctor['phone'] + "\n" + "Doctor Zone"
                                        + "\n" + "https://play.google.com/store/apps/details?id=com.ama.doctorzone.doctors");
                                  }, icon: Icon(Icons.share, color: Colors.black,), label: Text("")),
                                  trailing: Container(width: 80, child: Text('مشاركه', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
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
                          ),
                        ]),),
                ],
              ),
            )
        )
      ),
    );
  }

  Future<void> signOutUser() async {
    FirebaseAuth auth;
    await Firebase.initializeApp();
    auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pop(context);
    Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
      return new LoginPage();
    }));
  }

  Future<void> validateData() async {
    if (txtNameController.text == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("ادخل الاسم"),));
      return;
    }

    if (txtPhoneController.text == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("ادخل رقم المحمول"),));
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    lat = prefs.getDouble('lat');
    lng = prefs.getDouble('lng');

    if(lat == null || lng == null){
      lat = currentDoctor['lat'];
      lng = currentDoctor['lng'];
    }


    String imgUrl = "";

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

    if(imgProfile != null){
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("users_imgs")
          .child(currentDoctor['id'])
          .child("userImg.jpg");
      var uploadTask = await ref.putFile(imgProfile);
      imgUrl = await ref.getDownloadURL();
    }else{
      imgUrl = currentDoctor['img'];
    }

    currentDoctor['user'] = txtNameController.text;
    currentDoctor['dep'] = selectedDep;
    currentDoctor['phone'] = txtPhoneController.text;
    currentDoctor['reservation'] = reservation.toString();
    currentDoctor['state'] = state.toString();
    currentDoctor['show_price'] = showPrice.toString();
    currentDoctor['price'] = txtPriceController.text;
    currentDoctor['discount'] = txtDiscountController.text;
    currentDoctor['house_visit'] = house.toString();
    currentDoctor['niqabat'] = niqabat.toString();
    currentDoctor['loc_desc'] = txtLocDiscController.text;
    currentDoctor['location'] = selectedLocation;
    currentDoctor['sub_location'] = selectedSubLocation;
    currentDoctor['email'] = txtEmailController.text;
    currentDoctor['desc'] = txtDescController.text;
    currentDoctor['img'] = imgUrl;
    currentDoctor['lat'] = lat;
    currentDoctor['lng'] = lng;

    setState(() {
      doctorsRef.child(currentDoctor['id']).update(
          {
            "user": txtNameController.text,
            "dep": selectedDep,
            "phone": txtPhoneController.text,
            "reservation": reservation.toString(),
            "state": state.toString(),
            "show_price": showPrice.toString(),
            "price": txtPriceController.text,
            "discount": txtDiscountController.text.toString(),
            "house_visit": house.toString(),
            "niqabat": niqabat.toString(),
            "loc_desc": txtLocDiscController.text.toString(),
            "location": selectedLocation,
            "sub_location": selectedSubLocation,
            "email": txtEmailController.text,
            "desc": txtDescController.text,
            "img": imgUrl,
            "lat": lat,
            "lng": lng
          }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Update"),));
        Navigator.pop(context);
      });
    });

    saveUserLocal();

  }

  void initLists() {

    reservationList.add("اسبقيه الحضور");
    reservationList.add("من خلال التليفون");

    niqabatList.add("لا يوجد");
    niqabatList.add("يوجد");

    stateList.add("مغلق");
    stateList.add("مفتوح");

    priceList.add("اخفاء");
    priceList.add("عرض");

    houseList.add("لا يوجد");
    houseList.add("يوجد");

  }


  getGov(Map map) {
    locationsList.clear();
    map.forEach((key, value) {
      Map c = value;
      locationsList.add(c['name']);
    });
  }

  getDep(Map map) {
    depList.clear();
    map.forEach((key, value) {
      Map c = value;
      depList.add(c['name']);
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

  void onDepChanged(String value) {
    setState(() {
      selectedDep = value;
    });
  }

  void onReservationChanged(String value) {
    setState(() {
      reservation = reservationList.indexOf(value);
    });
  }

  void onStateChanged(String value) {
    setState(() {
      state = stateList.indexOf(value);
    });
  }

  void onShowPriceChanged(String value) {
    setState(() {
      showPrice = priceList.indexOf(value);
    });
  }

  void onHouseChanged(String value) {
    setState(() {
      house = houseList.indexOf(value);
    });
  }

  void onNiqabatChanged(String value) {
    setState(() {
      niqabat = niqabatList.indexOf(value);
    });
  }

  void onGovChanged(String value) {
    setState(() {
      selectedLocation = value;
      selectedSubLocation = "اختر المدينه";
      getCities(cities, selectedLocation);
      //subLocationsList.clear();
    });
  }

  void onCityChanged(String value) {
    setState(() {
      selectedSubLocation = value;
    });
  }

  Future<void> getUserData() async {
    currentDoctor = await UserData.getDoctor();
    setState(() {
      txtNameController.text = currentDoctor['user'];
      selectedLocation = currentDoctor['location'];
      selectedSubLocation = currentDoctor.containsKey('sub_location')?currentDoctor['sub_location']:'اختر المدينه';
      selectedDep = currentDoctor['dep'];
      reservation = int.parse(currentDoctor['reservation']);
      state = int.parse(currentDoctor['state']);
      showPrice = int.parse(currentDoctor.containsKey('show_price') ? currentDoctor['show_price'] : 0);
      house = int.parse(currentDoctor['house_visit']);
      niqabat = int.parse(currentDoctor['niqabat']);
      txtPhoneController.text = currentDoctor['phone'];
      txtPriceController.text = currentDoctor['price'];
      txtDiscountController.text = currentDoctor.containsKey('discount') == true? currentDoctor['discount'] : "لا يوجد خصم";
      txtLocDiscController.text = currentDoctor['loc_desc'];
      txtEmailController.text = currentDoctor['email'];
      txtDescController.text = currentDoctor['desc'];
      lat = currentDoctor['lat'];
      lng = currentDoctor['lng'];
    });
  }

  saveUserLocal() async {
    await UserData.saveDoctorData(currentDoctor);
    AppConstants.currentUser = currentDoctor;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم التحديث بنجاح"),));
    print("Success");
  }

  Future<void> openMaps() {
    Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
      return new MapsPage();
    }));
  }

  Future selectImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imgProfile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

}