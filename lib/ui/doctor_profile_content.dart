import 'package:flutter/material.dart';


class DoctorProfileContent extends StatefulWidget {

  final Map doctor;
  static final GlobalKey<_DoctorProfileContentState> staticGlobalKey = new GlobalKey<_DoctorProfileContentState>();
  const DoctorProfileContent({Key key, this.doctor}) : super(key: key);

  @override
  _DoctorProfileContentState createState() => _DoctorProfileContentState();
}

class _DoctorProfileContentState extends State<DoctorProfileContent> {


  @override
  Widget build(BuildContext context) {

  }

}

/*
class DoctorProfileContent extends StatefulWidget {

  final Map doctor;
  const DoctorProfileContent({Key key, this.doctor}) : super(key: key);

  @override
  _DoctorProfileContentState createState() => _DoctorProfileContentState();
}

class _DoctorProfileContentState extends State<DoctorProfileContent> {

  final txtNameController = TextEditingController();
  final txtPhoneController = TextEditingController();
  final txtPriceController = TextEditingController();
  final txtDiscountController = TextEditingController();
  final txtLocController = TextEditingController();
  final txtLocDiscController = TextEditingController();
  final txtEmailController = TextEditingController();
  final txtDescController = TextEditingController();

  String imgProfile = "";

  String selectedLocation = "";
  String selectedSubLocation = "";
  String selectedDep = "";
  int reservation = 0;
  int state = 0;
  int showPrice = 0;
  int house = 0;
  int niqabat = 0;

  Map cities;


  List<String> locationsList = new List();
  List<String> subLocationsList = new List();
  List<String> depList = new List();
  List<String> reservationList = new List();
  List<String> stateList = new List();
  List<String> priceList = new List();
  List<String> houseList = new List();
  List<String> niqabatList = new List();


  BuildContext context;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalData();
    initLists();
  }

  @override
  Widget build(BuildContext context) {

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

    return Container(
      child: Column(
          children: [
            new SingleChildScrollView(
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.blue,
                  margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      new ListTile(
                        title: Expanded(
                          child: txtName,
                        ),
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('الاسم ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: depStreamBuilder,
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('التخصص ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: Expanded(
                          child: txtPhone,
                        ),
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('رقم التليفون ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: reservationSpinner,
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('طريق الحجز  ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: stateSpinner,
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('الوضعيه ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: showPriceSpinner,
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('عرض الكشف ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: Expanded(
                          child: txtPrice,
                        ),
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('قيمه الكشف ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: Expanded(
                          child: txtDiscount,
                        ),
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('خصم التطبيق ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: houseSpinner,
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('كشف منزلي ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: niqabatSpinner,
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('نقابات وتعاقدات ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: Expanded(
                          child: txtLocation,
                        ),
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('الموقع ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: Expanded(
                          child: govStreamBuilder,
                        ),
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('المحافظه ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: Expanded(
                          child: cityStreamBuilder,
                        ),
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('المدينه ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: Expanded(
                          child: txtLocDesc,
                        ),
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('تفاصيل الموقع ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: Expanded(
                          child: txtEmail,
                        ),
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('الايميل ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: Expanded(
                          child: txtDesc,
                        ),
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('نبزه عامه ', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: Expanded(
                          child: FlatButton.icon(onPressed: (){

                          }, icon: Icon(Icons.insert_drive_file, color: Colors.black,), label: Text("")),
                        ),
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('شهادات', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: Expanded(
                          child: FlatButton.icon(onPressed: (){

                          }, icon: Icon(Icons.date_range, color: Colors.black,), label: Text("")),
                        ),
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('مواعيد العمل', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: Expanded(
                          child: FlatButton.icon(onPressed: (){

                          }, icon: Icon(Icons.comment, color: Colors.black,), label: Text("")),
                        ),
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('اراء المستخدم', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      new ListTile(
                        title: Expanded(
                          child: FlatButton.icon(onPressed: (){

                          }, icon: Icon(Icons.share, color: Colors.black,), label: Text("")),
                        ),
                        trailing: Expanded(
                            child: Container(width: 80, child: Text('مشاركه', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
            )
          ]),
    );
  }

  getLocalData() {
    txtNameController.text = widget.doctor['user'];
    selectedLocation = widget.doctor['location'];
    selectedSubLocation = widget.doctor.containsKey('sub_location')?widget.doctor['sub_location']:'اختر المدينه';
    selectedDep = widget.doctor['dep'];
    reservation = int.parse(widget.doctor['reservation']);
    state = int.parse(widget.doctor['state']);
    showPrice = int.parse(widget.doctor.containsKey('show_price') ? widget.doctor['show_price'] : 0);
    house = int.parse(widget.doctor['house_visit']);
    niqabat = int.parse(widget.doctor['niqabat']);
    txtPhoneController.text = widget.doctor['phone'];
    txtPriceController.text = widget.doctor['price'];
    txtDiscountController.text = widget.doctor.containsKey('discount') == true? widget.doctor['discount'] : "لا يوجد خصم";
    txtLocDiscController.text = widget.doctor['loc_desc'];
    txtEmailController.text = widget.doctor['email'];
    txtDescController.text = widget.doctor['desc'];
  }

  void initLists() {
    reservationList.add("من خلال التليفون");
    reservationList.add("اسبقيه الحضور");

    niqabatList.add("يوجد");
    niqabatList.add("لا يوجد");

    stateList.add("مفتوح");
    stateList.add("مغلق");

    priceList.add("عرض");
    priceList.add("اخفاء");

    houseList.add("يوجد");
    houseList.add("لا يوجد");
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


}

*/