import 'package:doctors/repositories/remotedata/firebase_conn.dart';
import 'package:doctors/utils/app_constants.dart';
import 'package:doctors/utils/progress.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddAppointment extends StatefulWidget {

  final String id;
  final Map appointment;

  const AddAppointment({Key key, this.id, this.appointment}) : super(key: key);

  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {

  BuildContext context;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> days = new List();
  int selDay = 0;

  final txtStartHrController = TextEditingController();
  final txtEndHrController = TextEditingController();



  var appointmentsRef = FirebaseDatabase.instance
      .reference()
      .child(AppConstants.appointments);

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: Colors.blue,
    borderRadius: 5.0,
    text: 'Saving Please wait...',
  );

  @override
  void initState() {
    super.initState();
    initLists();
    if (widget.appointment != null){
      selDay = days.indexOf( widget.appointment['day']);
      txtStartHrController.text = widget.appointment['start_hr'];
      txtEndHrController.text = widget.appointment['end_hr'];
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    final txtStart = TextFormField(
      textAlign: TextAlign.end,
      controller: txtStartHrController,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: widget.appointment == null ?'بدايه اليوم (الساعه)' : widget.appointment['start_hr'],
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );


    final txtEnd = TextFormField(
      textAlign: TextAlign.end,
      controller: txtEndHrController,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: widget.appointment == null ? 'نهايه اليوم (الساعه)' : widget.appointment['end_hr'],
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final daysSpinner = new Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: new Padding(
        padding: const EdgeInsets.all(1.0),
        child: new DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: days.map((String val) {
                return new DropdownMenuItem<String>(
                  value: val,
                  child: new Text(val, textAlign: TextAlign.right,),
                );
              }).toList(),
              hint: Text(days[selDay], textAlign: TextAlign.right,),
              //value: selectedLocation,
              onChanged: (value){
                setState(() {
                  selDay = days.indexOf(value);
                });
              },
              onTap: (){

              },
            )
        ),
      ),
    );


    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.appointment == null ? "اضافه ميعاد جديد" : "تعديل الميعاد"),
        actions: [
          FlatButton.icon(
              onPressed: (){
                validateData();
              },
              icon: Icon(Icons.save, color: Colors.white,),
              label: Text(widget.appointment == null ? "حفظ" : "حفظ التعديل", style: TextStyle(color: Colors.white),)
          ),
        ],
      ),

      body: Center(
        child: Card(
          elevation: 5,
          shadowColor: Colors.blue,
          margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(child: txtStart, margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),),
              SizedBox(
                height: 10,
              ),
              Container(child: txtEnd, margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),),
              SizedBox(
                height: 10,
              ),
              Container(child: daysSpinner, margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ),

    );
  }


  void initLists() {
    days.add("اختر يوم");
    days.add("السبت");
    days.add("الاحد");
    days.add("الاثنين");
    days.add("الثلاثاء");
    days.add("الاربعاء");
    days.add("الخميس");
    days.add("الجمعه");
  }

  void validateData() {

    if (txtStartHrController.text == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("ادخل بدايه اليوم"),));
      return;
    }

    if (txtEndHrController.text == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("ادخل نهايه اليوم"),));
      return;
    }

    if (selDay == 0){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("اختر اليوم"),));
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context){
          return progress;
        }
    );

    if (widget.appointment == null){
      String key = appointmentsRef.child(widget.id).push().key;
      setState(() {
        appointmentsRef.child(widget.id).child(key).set({
          "day": days[selDay],
          "key": key,
          "start_hr": txtStartHrController.text,
          "end_hr": txtEndHrController.text
        }).catchError((e) {
          //showInSnackBar("Error Occured : $e");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Add"),));
          Navigator.pop(context);
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added Successfully"),));
      });
    }else{
      String key = widget.appointment['key'];
      setState(() {
        appointmentsRef.child(widget.id).child(key).update({
          "day": days[selDay],
          "key": key,
          "start_hr": txtStartHrController.text,
          "end_hr": txtEndHrController.text
        }).catchError((e) {
          //showInSnackBar("Error Occured : $e");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Update"),));
          Navigator.pop(context);
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Updated Successfully"),));
      });

    }


  }


}
