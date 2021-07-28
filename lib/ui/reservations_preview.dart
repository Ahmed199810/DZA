import 'package:doctors/utils/app_constants.dart';
import 'package:doctors/utils/progress.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReservationsPreview extends StatefulWidget {
  final Map reservations;
  const ReservationsPreview({Key key, this.reservations}) : super(key: key);

  @override
  _ReservationsPreviewState createState() => _ReservationsPreviewState(reservations);
}

class _ReservationsPreviewState extends State<ReservationsPreview> {
  BuildContext context;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final Map reservations;

  var usersReservationRef = FirebaseDatabase.instance.reference().child(AppConstants.users_reservations);
  var appointmentRef = FirebaseDatabase.instance.reference().child(AppConstants.appointments);
  var usersReservationHistoryRef = FirebaseDatabase.instance.reference().child(AppConstants.users_reservations_history);
  var doctorsReservationHistoryRef = FirebaseDatabase.instance.reference().child(AppConstants.reservations_history);

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: Colors.blue,
    borderRadius: 5.0,
    text: 'Please wait...',
  );


  _ReservationsPreviewState(this.reservations);
  @override
  Widget build(BuildContext context) {
    this.context = context;
    print(reservations.toString());
    var resList = ListView.builder(
      itemCount: reservations == null ? 0 : reservations.length,
      itemBuilder: (context, index) {
        var keys = reservations.keys.toList();
        if(reservations == null){
          return new Container(
            constraints: const BoxConstraints(maxHeight: 500.0),
            child: new Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        margin: new EdgeInsets.only(top: 00.0, bottom: 0.0),
                        height: 150.0,
                        width: 150.0,
                        child: new Image.asset('assets/images/doctor2.png')),
                    new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Text(
                        "You have no Reservations in That Day...",
                        style: new TextStyle(fontSize: 14.0, color: Colors.black),
                      ),
                    ),
                  ],
                )),
          );
        }
        return Card(
          elevation: 5,
          shadowColor: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
              margin: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(reservations[keys[index]]['day'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                  Text(reservations[keys[index]]['date']),
                  Text(reservations[keys[index]]['name'] + " المريض "),
                  Text(reservations[keys[index]]['phone']),
                  Text(" من " + reservations[keys[index]]['time']),
                  Text(reservations[keys[index]]['state'] == '0' ? "في الانتظار" : "اكتمل الحجز"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton.icon(
                          onPressed: (){

                            callPhone(reservations[keys[index]]['phone']);
                          },
                          icon: Icon(Icons.call, color: Colors.blue,), label: Text("اتصال")),
                      FlatButton.icon(
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return progress;
                                }
                            );
                            deleteReservation(reservations[keys[index]]);
                          },
                          icon: Icon(Icons.cancel, color: Colors.red,), label: Text("الغاء")),
                      FlatButton.icon(
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return progress;
                                }
                            );
                            confirmReservation(reservations[keys[index]]);
                          },
                          icon: Icon(Icons.done_outline, color: Colors.green,), label: Text("تم")),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {

          },
          child: new Text(
            "الحجوزات",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: resList,
    );
  }

  void callPhone(phone) {
    launch("tel:" + phone);
  }

  void confirmReservation(reservation) {
    usersReservationRef.child(reservation['patient_id']).child(reservation['key']).remove().then((value) => {
      removeFromDocReservations(reservation, 1)
    }).catchError((onError) =>{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("لم يتم تأكيد الحجز"),
      ))
    });
  }

  removeFromDocReservations(reservation, int state) {
    appointmentRef.child(reservation['doctor_id']).child(reservation['day_key']).child(AppConstants.reservations)
        .child(reservation['patient_id']).remove().then((value) => {
      addToHistory(reservation, state)
    }).catchError((onError) =>{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("لم يتم تأكيد الحجز"),
      ))
    });

  }

  addToHistory(reservation, int state) {
    reservation['state'] = state.toString();
    doctorsReservationHistoryRef.child(reservation['doctor_id']).child(reservation['key']).set(reservation).then((value) => {
      usersReservationHistoryRef.child(reservation['patient_id']).child(reservation['key']).set(reservation).then((value) => {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("تم تأكيد الحجز"),)),
        Navigator.pop(context),
        setState(() {
          setState(() {
            reservations.remove(reservation['patient_id']);
          });
          //widget.reservations.remove(reservation);
        }),
      })
    });
  }

  void deleteReservation(reservation) {
    usersReservationRef.child(reservation['patient_id']).child(reservation['key']).remove().then((value) => {
      removeFromDocReservations(reservation, 2)
    }).catchError((onError) =>{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("لم يتم تأكيد الحجز"),
      ))
    });
  }


}