import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class DeliveryPaymentCard extends StatefulWidget {
  @override
  _DeliveryPaymentCardState createState() => _DeliveryPaymentCardState();
}

class _DeliveryPaymentCardState extends State<DeliveryPaymentCard> {
  @override

  String paymentSelect = "card";

  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: const Text(
          "Pagamento na entrega",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),

        leading: const Icon(Icons.home, color: Colors.black,),
        trailing: const Icon(Icons.arrow_drop_down ,color: Colors.black,),
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile<String>(
                  title: const Text('Cartão de Crédito'),
                  value: "card",
                  activeColor: Theme.of(context).primaryColor,
                  groupValue: paymentSelect,
                  onChanged: (val){
                    setState(() {
                      paymentSelect = val;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Dinheiro'),
                  value: "money",
                  activeColor: Theme.of(context).primaryColor,
                  groupValue: paymentSelect,
                  onChanged: (val){
                    setState(() {
                      paymentSelect = val;
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