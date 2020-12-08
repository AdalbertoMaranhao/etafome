import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/cart_product.dart';


enum Status {canceled, waiting, preparing, transporting, delivered}

class Order {
  
  Order.fromCartManager(CartManager cartManager){
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    userName = cartManager.user.name;
    userPhone = cartManager.user.phone ?? "";
    address = cartManager.address;
    troco = cartManager.troco;
    status = Status.waiting;
    if(!cartManager.deliveryType) {
      deliveryType = "Receber em Casa";
    } else {
      deliveryType = "Retirar na Loja";
    }
    if(cartManager.paymentMethod == 'card') {
      paymentMethod = "Pagamento na Entrega: cartão";
    } else if(cartManager.paymentMethod == 'money'){
      paymentMethod = "Pagamento na Entrega: dinheiro";
    } else {
      paymentMethod = "Pago no App";
    }
  }

  Order.fromDocument(DocumentSnapshot doc){
    orderId = doc.documentID;
    items = (doc.data['items'] as List<dynamic>).map((e){
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();
    price = doc.data['price'] as num;
    userId = doc.data['user'] as String;
    troco = doc.data['troco'] as String;
    userName = doc.data['userName'] as String;
    userPhone = doc.data['userPhone'] as String;
    address = Address.fromMap(doc.data['address'] as Map<String, dynamic>);
    date = doc.data['date'] as Timestamp;

    status = Status.values[doc.data['status'] as int];
    payId = doc.data['payId'] as String;
    deliveryType = doc.data['deliveryType'] as String;
    paymentMethod = doc.data['paymentMethod'] as String;
  }

  final Firestore firestore = Firestore.instance;
  DocumentReference get firestoreRef =>
      firestore.collection('orders').document(orderId);

  String orderId;
  String payId;
  String deliveryType;
  String paymentMethod;
  String troco;


  List<CartProduct> items;
  num price;
  String userId;
  String userName;
  String userPhone;
  Address address;

  Status status;

  Timestamp date;

  String exibitionOrderId;

  String get formattedId => '#${splitOrderId().padLeft(6, '0')}';

  String get statusText => getStatusText(status);

  String splitOrderId (){
    final List<String> split = orderId.split("@");
    return exibitionOrderId = split[0];
  }

  String storeOrderId (){
    final List<String> split = orderId.split("@");
    return exibitionOrderId = split[1];
  }


  Future<void> save() async {
    firestoreRef.setData(
      {
        'items': items.map((e) => e.toOrderItemMap()).toList(),
        'price': price,
        'user': userId,
        'userName': userName,
        'userPhone': userPhone,
        'address': address.toMap(),
        'status': status.index,
        'date': Timestamp.now(),
        'payId': payId,
        'troco': troco,
        'deliveryType': deliveryType,
        'paymentMethod': paymentMethod,
      }
    );
  }

  void updateFromDocument(DocumentSnapshot doc) {
    status = Status.values[doc.data['status'] as int];
  }

  static String getStatusText(Status status){
    switch(status){
      case Status.canceled:
        return 'Cancelado';
      case Status.waiting:
        return 'Aguardando Vizualização';
      case Status.preparing:
        return 'Em Preparo';
      case Status.transporting:
        return 'Saiu para entrega';
      case Status.delivered:
        return 'Entregue';
      default:
        return '';
    }
  }

  Function() get back {
    if(status.index >= Status.preparing.index){
      return (){
        status = Status.values[status.index - 1];
        firestoreRef.updateData({'status': status.index});
      };
    }
    return null;
  }

  Function() get advance {
    if(status.index <= Status.transporting.index){
      return (){
        status = Status.values[status.index + 1];
        firestoreRef.updateData({'status': status.index});
      };
    }
    return null;
  }

  Future<void> cancel() async {
    try {
      //await CieloPayment().cancel(payId);

      status = Status.canceled;
      firestoreRef.updateData({'status': status.index});
    } catch (e){
      debugPrint('Erro ao cancelar');
      return Future.error('Falha ao cancelar');
    }
  }


}