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

  int select;

  Address _address = Address();

  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: const Text(
          "Tipo de entrega",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),

        leading: const Icon(Icons.delivery_dining, color: Colors.black,),
        trailing: const Icon(Icons.arrow_drop_down ,color: Colors.black,),
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile(
                  title: const Text('Receber em casa'),
                  value: 0,
                  activeColor: Theme.of(context).primaryColor,
                  groupValue: select,
                  onChanged: (int val){
                    cartManager.setDeliveryType(val);
                    setState(() {
                      select = val;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('Retirar na loja'),
                  value: 1,
                  activeColor: Theme.of(context).primaryColor,
                  groupValue: select,
                  onChanged: (int val){
                    cartManager.setDeliveryType(val);
                    setState(() {
                      select = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}