import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/product/components/alert_stores_different.dart';
import 'package:provider/provider.dart';

class ProductListTile extends StatelessWidget {

  const ProductListTile(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed('/product', arguments: product);
      },
      child: Card(
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.2,
              child: Image.network(
                product.images.first,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          product.description,
                        ),
                        Text(
                          product.price > 0 ?'R\$ ${product.price.toStringAsFixed(2)}' : "",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: InkWell(
                    //       onTap: (){
                    //         if(context.read<UserManager>().isLoggedIn){
                    //           if(context.read<CartManager>().verifyCart(product.store)) {
                    //             context.read<CartManager>().addToCart(
                    //                 product);
                    //             // Navigator.of(context).pushNamed("/cart");
                    //             Scaffold.of(context).showSnackBar(
                    //               const SnackBar(
                    //                 content: Text("Produto adicionado ao carrinho!"),
                    //                 backgroundColor: Colors.greenAccent,
                    //               ),
                    //             );
                    //           } else {
                    //             showDialog(context: context,
                    //                 builder: (_) => AlertStoresDifferent(product));
                    //           }
                    //
                    //         } else {
                    //           Navigator.of(context).pushNamed('/login');
                    //         }
                    //       },
                    //     child: SizedBox(
                    //       height: 50,
                    //       width: 50,
                    //       child: Card(
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(50)
                    //         ),
                    //         color: const Color.fromARGB(255, 128, 53, 73),
                    //         child: const Icon(Icons.add, color: Colors.white,),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}