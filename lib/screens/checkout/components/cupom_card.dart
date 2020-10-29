import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/cart_product.dart';
import 'package:provider/provider.dart';

class CupomCard extends StatelessWidget {
  CupomCard(this.cartProduct);

  final CartProduct cartProduct;
  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: const Text(
            "Cupom de desconto",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),

        leading: const Icon(Icons.card_giftcard, color: Colors.black,),
        trailing: const Icon(Icons.add, color: Colors.black,),
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
                  if(docSnap.data != null && (docSnap.data["store"] as String == cartProduct.productStore || docSnap.data["store"] as String == null)){
                    cartManager.setCoupon(text, docSnap.data["value"] as int, docSnap.data["type"] as String);
                    if(docSnap.data["type"] as String == "percent"){
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Desconto de ${docSnap.data["value"]}% aplicado"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Desconto de R\$ ${docSnap.data["value"]} aplicado"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }

                  } else {
                    cartManager.setCoupon(null, 0, "value");
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