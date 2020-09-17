import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class DeliveryType extends StatefulWidget {
  @override
  _DeliveryTypeState createState() => _DeliveryTypeState();
}

class _DeliveryTypeState extends State<DeliveryType> {
  @override

  bool select = false;

  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            title: const Text('Retirar na loja'),
            value: select,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (bool val){
              setState(() {
                select = val;
                cartManager.setDeliveryType(val);
              });
            },
          ),
        ],
      ),
    );
  }
}