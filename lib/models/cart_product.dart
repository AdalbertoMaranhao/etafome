import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/item_size.dart';
import 'package:lojavirtual/models/product.dart';

class CartProduct extends ChangeNotifier{

  CartProduct.fromProduct(this._product){
    productID = product.id;
    productStore = product.store;
    quantity = 1;
    options.addAll(product.listOptions);
  }

  CartProduct.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    productID = document.data['pid'] as String;
    productStore = document.data['pst'] as String;
    quantity = document.data['quantity'] as int;
    options = List<String>.from(document.data['options'] as List<dynamic> ?? []);
    firestore.document('products/$productID').get().then(
            (doc) {
              product = Product.fromDocument(doc);
            }
    );
  }


  CartProduct.fromMap(Map<String, dynamic> map){
    productID = map['pid'] as String;
    productStore = map['pst'] as String;
    quantity = map['quantity'] as int;
    options = List<String>.from(map['options'] as List<dynamic> ?? []);
    fixedPrice = map['fixedPrice'] as num;

    firestore.document('products/$productID').get().then(
        (doc) {
          product = Product.fromDocument(doc);
        }
    );
  }

  final Firestore firestore = Firestore.instance;

  String id;
  String productID;
  String productStore;
  int quantity;
  List<String> options = [];
  num fixedPrice;

  Product _product;
  Product get product => _product;
  set product(Product value){
    _product = value;
    notifyListeners();
  }

  num get unitPrice {
    if(product == null) return 0;
    return product.basePrice + product.price ?? 0;
  }

  num get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productID,
      'pst': productStore,
      'quantity': quantity,
      'options': options,
    };
  }

  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': productID,
      'pst': productStore,
      'quantity': quantity,
      'options': options,
      'fixedPrice': fixedPrice ?? unitPrice,
    };
  }


  bool stackable(Product product){
    return product.id == productID;
  }

  void increment(){
    quantity++;
    notifyListeners();
  }

  void decrement(){
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    if(product != null && product.deleted) return false;
  }


}