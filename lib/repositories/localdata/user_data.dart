

import 'package:doctors/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData{

  static Future saveDoctorData(Map doctor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('dep', doctor[AppConstants.dep]);
    prefs.setString('desc', doctor[AppConstants.desc]);
    prefs.setString('email', doctor[AppConstants.email]);
    prefs.setString('house_visit', doctor[AppConstants.house_visit]);
    prefs.setString('id', doctor[AppConstants.userID]);
    prefs.setString('img', doctor[AppConstants.img]);
    prefs.setDouble('lat', double.parse(doctor[AppConstants.lat].toString()));
    prefs.setDouble('lng', double.parse(doctor[AppConstants.lng].toString()));
    prefs.setString('loc_desc', doctor[AppConstants.loc_desc]);
    prefs.setString('location', doctor[AppConstants.location]);
    prefs.setString('niqabat', doctor[AppConstants.niqabat]);
    prefs.setString('pass', doctor[AppConstants.pass]);
    prefs.setString('phone', doctor[AppConstants.phone]);
    prefs.setString('price', doctor[AppConstants.price]);
    prefs.setString('rate_num', doctor[AppConstants.rate_num]);
    prefs.setDouble('rating', double.parse(doctor[AppConstants.rating].toString()));
    prefs.setString('reservation', doctor[AppConstants.reservation]);
    prefs.setString('show_price', doctor[AppConstants.show_price]);
    prefs.setString('state', doctor[AppConstants.state]);
    prefs.setString('type', doctor[AppConstants.type]);
    prefs.setString('user', doctor[AppConstants.user]);
    prefs.setString('sub_location', doctor[AppConstants.sub_location]);
    prefs.setString('discount', doctor[AppConstants.discount]);
  }

  static Future<Map> getDoctor() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dep = prefs.getString('dep');
    String desc = prefs.getString('desc');
    String email = prefs.getString('email');
    String house_visit = prefs.getString('house_visit');
    String id = prefs.getString('id');
    String img = prefs.getString('img');
    double lat = prefs.getDouble('lat');
    double lng = prefs.getDouble('lng');
    String loc_desc = prefs.getString('loc_desc');
    String location = prefs.getString('location');
    String niqabat = prefs.getString('niqabat');
    String pass = prefs.getString('pass');
    String phone = prefs.getString('phone');
    String price = prefs.getString('price');
    String rate_num = prefs.getString('rate_num');
    double rating = prefs.getDouble('rating');
    String reservation = prefs.getString('reservation');
    String show_price = prefs.getString('show_price');
    String state = prefs.getString('state');
    String type = prefs.getString('type');
    String user = prefs.getString('user');
    String sub_location = prefs.getString('sub_location');
    String discount = prefs.getString('discount');

    Map doctor = new Map();

    doctor['dep'] = dep;
    doctor['desc'] = desc;
    doctor['email'] = email;
    doctor['house_visit'] = house_visit;
    doctor['id'] = id;
    doctor['img'] = img;
    doctor['lat'] = lat;
    doctor['lng'] = lng;
    doctor['loc_desc'] = loc_desc;
    doctor['location'] = location;
    doctor['niqabat'] = niqabat;
    doctor['pass'] = pass;
    doctor['phone'] = phone;
    doctor['price'] = price;
    doctor['rate_num'] = rate_num;
    doctor['rating'] = rating;
    doctor['reservation'] = reservation;
    doctor['show_price'] = show_price;
    doctor['state'] = state;
    doctor['type'] = type;
    doctor['user'] = user;
    doctor['sub_location'] = sub_location;
    doctor['discount'] = discount;
    return doctor;
  }


}