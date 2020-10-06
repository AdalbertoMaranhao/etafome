import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lojavirtual/models/store.dart';
import 'package:lojavirtual/services/cepaberto_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoresManager extends ChangeNotifier {

  StoresManager(){
    _loadStoreList();
    //_startTimer();
    setCity("Mauriti");
  }



  List<Store> stores = [];
  List<Store> storesCity = [];
  Timer _timer;

  String _city;
  String get city => _city;
  void setCity (String value) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _city = value;
    await prefs.setString('city', _city);
    notifyListeners();
  }

  final Firestore firestore = Firestore.instance;

  Future<void> _loadStoreList() async {
    final snapshot = await firestore.collection('stores').getDocuments();

    stores = snapshot.documents.map((doc) => Store.fromDocument(doc)).toList();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _city = prefs.getString('city') ?? "";

    getStoresCity(_city);

    //await getLocation();
    //getStoresCity(_city);

    notifyListeners();
  }

  // Future<void> getLocation() async{
  //   final loc = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
  //   double lat = loc.latitude;
  //   double long = loc.longitude;
  //
  //   final a = await CepAbertoService().getAddressFromLatAndLong(lat, long);
  //   city = a.cidade.nome;
  //   notifyListeners();
  //
  // }

  Future<void> getStoresCity(String cidade) async {
    storesCity.clear();
    setCity(cidade);

    for(final store in stores){
      if(store.address.city.toLowerCase() == cidade.toLowerCase()){
        storesCity.add(store);
      }
    }

    notifyListeners();
  }

  Store findStoreById(String id) {
    try {
      return stores.firstWhere((p) => p.id == id);
    } catch(e) {
      return null;
    }
  }

  // void _startTimer(){
  //   _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
  //     _checkOpening();
  //   });
  // }

  // void _checkOpening() {
  //   for(final store in stores){
  //     store.updateStatus();
  //   }
  //   notifyListeners();
  // }

  void updateStatusStore(StoreStatus status, Store store){
    store.status = status;
    store.updateStatusStore(status);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }


}