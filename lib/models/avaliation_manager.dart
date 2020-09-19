import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'avalition.dart';

class AvaliationManager extends ChangeNotifier {

  final Firestore firestore = Firestore.instance;

  List<Avaliation> avaliations;

  Avaliation avaliation;


  Future<void> loadAvaliations(String storeId) async {
    final QuerySnapshot avaliationSnap = await firestore.collection('stores/$storeId/avaliations').getDocuments();

    avaliations = avaliationSnap.documents
        .map((d) => Avaliation.fromDocument(d))
        .toList();

    notifyListeners();
  }

  void save(String storeId, Avaliation avaliation){

    avaliation.save(storeId, avaliation);
    loadAvaliations(storeId);
    notifyListeners();
  }


}