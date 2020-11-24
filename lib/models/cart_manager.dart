import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:lojavirtual/models/cart_product.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/stores_manager.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/services/cepaberto_service.dart';
import 'package:lojavirtual/services/location.dart';
import 'package:geocoding/geocoding.dart';

class CartManager extends ChangeNotifier{
  List<CartProduct> items = [];

  String cupomCode;
  int discoutValue = 0;

  bool deliveryType = false;
  String paymentMethod;

  User user;
  Address address;
  final location = Loc();

  num productsPrice = 0.0;
  num deliveryPrice;
  num discount;

  num get totalPrice => (productsPrice /*+ (deliveryPrice ?? 0)*/) - (discount ?? 0.0);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  final Firestore firestore = Firestore.instance;

  void updateUser(UserManager userManager) {
    user = userManager.user;
    productsPrice = 0.0;
    items.clear();
    removeAddress();

    if (user != null) {
      //_loadCartItems();
      _loadUserAddress();
    }
  }

  // Future<void> _loadCartItems() async {
  //   final QuerySnapshot cartSnap = await user.cartReference.getDocuments();
  //
  //   items = cartSnap.documents
  //       .map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdate))
  //       .toList();
  // }

  Future<void> _loadUserAddress() async{
    if(user.address != null){
        // && await location.calculateDelivery(user.address.lat, user.address.long)){
      address = user.address;
      deliveryPrice = 0.0;
      notifyListeners();
    }
  }

  Future<void> setDeliveryType(bool value) async{
    deliveryType = value;
    notifyListeners();
    if(value){
      deliveryPrice = 0.0;
    } else{
      deliveryPrice = null;
       //await calculateDelivery(address.lat, address.long);
    }
    notifyListeners();
  }

  void setPaymentMethod(String value){
    paymentMethod = value;
    notifyListeners();
  }

  void setCoupon(String couponCode, int percent, String type){
    cupomCode = couponCode;
    discoutValue = percent;

    if(type == "percent") {
      discount = productsPrice * discoutValue / 100;
    } else {
      discount = discoutValue;
    }

    notifyListeners();
  }

  void addToCart(Product product) {
     try {
       final e = items.firstWhere((p) => p.stackable(product));
       e.increment();
     } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdate);
      items.add(cartProduct);
      // user.cartReference.add(cartProduct.toCartItemMap())
      //     .then((doc) => cartProduct.id = doc.documentID);
      _onItemUpdate();
    }
    notifyListeners();
  }

  void removeOfCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    user.cartReference.document(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdate);
    notifyListeners();
  }

  void clear() {
    for(final cartProduct in items){
      user.cartReference.document(cartProduct.id).delete();
    }
    items.clear();
    paymentMethod = null;
    deliveryType = false;

    notifyListeners();
  }

  bool verifyCart(String store){
    if(items.isNotEmpty){
      if(items[0].productStore != store){
        return false;
      } else {
        return true;
      }
    }
    return true;
  }


  void _onItemUpdate() {
    productsPrice = 0.0;

    for(int i =0; i<items.length; i++){
      final cartProduct = items[i];
      if(cartProduct.quantity == 0){
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.totalPrice;

      //_updateCartProduct(cartProduct);
    }
    notifyListeners();
  }

  // void _updateCartProduct(CartProduct cartProduct) {
  //   if(cartProduct.id != null) {
  //     user.cartReference
  //         .document(cartProduct.id)
  //         .updateData(cartProduct.toCartItemMap());
  //   }
  // }


  bool get isCartValid {
    if(address != null || deliveryType){
      return true;
    }
    return false;
  }

  bool get isAddressValid => address != null && deliveryPrice != null;

  //ADDRESS

  Future<void> getAddress(Loc location) async{
    loading = true;

    //final cepAbertoService = CepAbertoService();

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
      //final cepAbertoAddress = await cepAbertoService.getAddresFromCep(cep);
      if(placemarks != null){
        address = Address(
          number: placemarks[0].subThoroughfare,
          street:  placemarks[0].thoroughfare,
          district: placemarks[0].subLocality,
          zipCode: placemarks[0].postalCode,
          city: placemarks[0].subAdministrativeArea,
          state: "CE",
          lat: location.latitude,
          long: location.longitude,
        );
      }
      loading = false;
    } catch (e){
      loading = false;
      return Future.error(e.toString());
    }
  }

  Future<void> setAddress(Address address) async {
    if(deliveryType == 1){
      this.address = StoresManager().findStoreById(items[0].productStore).address;
      deliveryPrice = 0.0;
    } else {
      loading = true;

      this.address = address;

      if(await location.calculateDelivery(address.lat, address.long)){
        user.setAddress(address);
        deliveryPrice = 0.0;
        loading = false;
      } else {
        loading = false;
        return Future.error('Endereço fora do raio de entrega :(');
      }
    }
  }

  void removeAddress(){
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  // Future<bool> calculateDelivery(double lat, double long) async{
  //   // final DocumentSnapshot doc = await firestore.document('aux/delivery').get();
  //   //
  //   // final latStore = doc.data['lat'] as double;
  //   // final longStore = doc.data['long'] as double;
  //   // final base = doc.data['base'] as num;
  //   // final km = doc.data['km'] as num;
  //   // final maxkm = doc.data['maxkm'] as num;
  //   //
  //
  //   // double dis = await Geolocator()
  //   //     .distanceBetween(latStore, longStore, lat, long);
  //
  //   // dis /= 1000;
  //   //
  //   //
  //   // if(dis > maxkm){
  //   //   return false;
  //   // }
  //   //
  //   // deliveryPrice = base + dis * km;
  //   deliveryPrice = 0.0;
  //   return true;
  // }


}
