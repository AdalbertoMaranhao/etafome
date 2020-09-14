import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class CupomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
          title: const Text(
            "Cupom de desconto",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),

        leading: const Icon(Icons.card_giftcard),
        trailing: const Icon(Icons.add),
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu Cupom",
              ),
              initialValue: cartManager.cupomCode ?? "",
              onFieldSubmitted: (text){
                Firestore.instance.collection("coupons").document(text).get().then(
                   (docSnap) {
                  if(docSnap.data != null){
                    cartManager.setCoupon(text, docSnap.data["percent"] as int);
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Desconto de ${docSnap.data["percent"]}% aplicada"),
                        backgroundColor: Colors.green,
                      ),
                    );

                  } else {
                    cartManager.setCoupon(null, 0);
                    Scaffold.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Cupom não existente"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}