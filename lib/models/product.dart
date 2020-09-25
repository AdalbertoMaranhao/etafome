import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/item_size.dart';
import 'package:uuid/uuid.dart';

import 'option.dart';

class Product extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.document('products/$id');

  StorageReference get storageRef => storage.ref().child('products').child(id);

  Product({this.id, this.name, this.price, this.description, this.images, this.options, this.deleted = false, this.store,}) {
    images = images ?? [];
    options = options ?? [];
  }

  Product.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document['name'] as String;
    price = document['price'] as num;
    store = document['store'] as String;
    description = document['description'] as String;
    images = List<String>.from(document.data['images'] as List<dynamic> ?? []);
    options = (document.data['options'] as List<dynamic>)
        .map((s) => Option.fromMap(s as Map<String, dynamic>))
        .toList();

    deleted = (document.data['deleted'] ?? false) as bool;
  }

  String id;
  String name;
  num price;
  String description;
  String store;
  List<String> images;
  List<Option> options;

  num orderPrice = 0;

  bool deleted;
  List<dynamic> newImages;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }


  List<String> listOptions = [];



  num get basePrice {
    num lowest;
    if(orderPrice == 0) {
      lowest = price;
    } else {
      lowest = orderPrice;
    }

    return lowest;
  }

  void setOrderPriceMais(num value){
    orderPrice += value;
    notifyListeners();
  }

  void setOrderPriceMenos(num value){
    orderPrice -= value;
    notifyListeners();
  }

  List<Map<String, dynamic>> exportOptionList() {
    return options.map((size) => size.toMap()).toList();
  }

  Future<void> save() async {
    loading = true;

    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'store': store,
      'options': exportOptionList(),
      'deleted': deleted,
    };

    if (id == null) {
      final doc = await firestore.collection('products').add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
    }

    final List<String> updateImages = [];

    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final StorageUploadTask task =
            storageRef.child(Uuid().v1()).putFile(newImage as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;

        updateImages.add(url);
      }
    }

    for(final image in images){
      if(!newImages.contains(image) && image.contains('firebase')){
        try {
          final ref = await storage.getReferenceFromUrl(image);
          await ref.delete();
        } catch (e){
          debugPrint('Falha ao deletar $image');
        }
      }
    }

    await firestoreRef.updateData({'images': updateImages});
    images = updateImages;

    loading = false;
  }

  void delete() {
    firestoreRef.updateData({'deleted': true});
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      store: store,
      images: List.from(images),
      options: options,
      deleted: deleted,
    );
  }

}
