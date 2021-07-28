import 'dart:io';

import 'package:doctors/utils/app_constants.dart';
import 'package:doctors/utils/progress.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCertificate extends StatefulWidget {

  @override
  _AddCertificateState createState() => _AddCertificateState();
}

class _AddCertificateState extends State<AddCertificate> {

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;

  File imgCertificate;
  final picker = ImagePicker();
  final txtNameController = TextEditingController();
  var certificatesRef = FirebaseDatabase.instance
      .reference()
      .child(AppConstants.certificates);

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: Colors.blue,
    borderRadius: 5.0,
    text: 'Saving Please wait...',
  );


  @override
  Widget build(BuildContext context) {
    this.context = context;

    final txtName = TextFormField(
      textAlign: TextAlign.end,
      controller: txtNameController,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'وصف الشهاده',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );



    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("اضافه شهاده"),
        actions: [
          FlatButton.icon(
              onPressed: (){
                validateData();
              },
              icon: Icon(Icons.save, color: Colors.white,),
              label: Text("حفظ", style: TextStyle(color: Colors.white),)
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: 20,),

            Card(
              elevation: 5,
              shadowColor: Colors.blue,
              margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: txtName,
            ),
            GestureDetector(
              onTap: (){
                selectImage();
              },
              child: Card(
                elevation: 5,
                shadowColor: Colors.blue,
                margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
                child: Container(
                  child: imgCertificate == null ? new Container(
                    width: double.maxFinite,
                    height: 300,
                    child: Icon(Icons.add_photo_alternate, size: 100,),
                  ):new Image.file(new File(
                    imgCertificate.path,
                  ),
                    width: 160.0,
                    height: 160.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  Future selectImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imgCertificate = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

  }

  Future<void> validateData() async {

    if (txtNameController.text == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("Enter Some description"),));
      return;
    }
    
    if(imgCertificate == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("Please Select an Image"),));
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

    String key = certificatesRef.child(AppConstants.currentUserId).push().key;
    String imgUrl = "";
    if(imgCertificate != null){

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(AppConstants.certificates)
          .child(AppConstants.currentUserId)
          .child(key + ".jpg");

      var uploadTask = await ref.putFile(imgCertificate);
      imgUrl = await ref.getDownloadURL();
    }

    setState(() {
      certificatesRef.child(AppConstants.currentUserId).child(key).set({
        "desc": txtNameController.text,
        "imgUrl": imgUrl,
        "key": key
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Upload"),));
        Navigator.pop(context);
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Uploaded Successfully"),));
    });


  }



}
