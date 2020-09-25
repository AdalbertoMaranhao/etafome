import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/credit_card.dart';
import 'package:lojavirtual/models/order.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/services/cielo_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutManager extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;
  final CieloPayment cieloPayment = CieloPayment();

  CartManager cartManager;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  // ignore: use_setters_to_change_properties
  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  Future<void> checkout({CreditCard creditCard,Function onStockFail, Function onSuccess, Function onPayFail}) async {
    loading = true;

    final orderId = await _getOrderId();
    String payId;

    if(cartManager.paymentMethod == null) {
      try {
        payId = await cieloPayment.authorize(
          creditCard: creditCard,
          price: cartManager.totalPrice,
          orderId: orderId.toString(),
          user: cartManager.user,
        );
      } catch (e) {
        onPayFail(e);
        loading = false;
        return;
      }
    }

    if(payId != null) {
      try {
        await cieloPayment.capture(payId);
        //save Credit Card
        saveCreditCard(creditCard);
      } catch (e) {
        onPayFail(e);
        loading = false;
        return;
      }
    }

    final order = Order.fromCartManager(cartManager);
    order.orderId = "${orderId.toString()}@${order.items[0].productStore}";
    order.payId = payId;

    order.save();


    cartManager.clear();

    onSuccess(order);
    loading = false;
  }

  Future<int> _getOrderId() async {
    final ref = firestore.document('aux/ordercounter');
    try {
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final orderId = doc.data['current'] as int;
        await tx.update(ref, {'current': orderId + 1});
        return {'orderId': orderId};
      });
      return result['orderId'] as int;
    } catch (e){
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }

  Future<void> saveCreditCard(CreditCard creditCard) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cardName', creditCard.holder);
    await prefs.setString('cardNumber', creditCard.number);
    await prefs.setString('cardDate', creditCard.expirationDate);
    await prefs.setString('cardCVV', creditCard.securityCode);
  }
}
