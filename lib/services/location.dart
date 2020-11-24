import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class Loc {
  double latitude;
  double longitude;
  final Firestore firestore = Firestore.instance;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> calculateDelivery(double lat, double long) async{
    final DocumentSnapshot doc = await firestore.document('aux/delivery').get();

    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;
    final base = doc.data['base'] as num;
    final km = doc.data['km'] as num;
    final maxkm = doc.data['maxkm'] as num;


    double dis = await Geolocator()
        .distanceBetween(latStore, longStore, lat, long);

    dis /= 1000;


    if(dis > maxkm){
      return false;
    }
    final deliveryPrice = base + dis * km;
    return true;
  }

}