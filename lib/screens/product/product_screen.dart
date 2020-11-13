import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/product/components/alert_stores_different.dart';
import 'package:lojavirtual/screens/product/components/option_widget.dart';
import 'package:lojavirtual/screens/edit_product/components/active_product_dialog.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {

  const ProductScreen(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Color.fromARGB(255, 128, 53, 73)),
          title: Text(product.name, style: const TextStyle(color: Color.fromARGB(255, 128, 53, 73)),),
          centerTitle: true,
          actions: <Widget>[
            Consumer<UserManager>(
              builder: (_, userManager, __){
                if(userManager.adminEnabled && !product.deleted){
                  return IconButton(
                    icon: Icon(Icons.edit, color: primaryColor,),
                    onPressed: (){
                      Navigator.of(context).pushReplacementNamed(
                          '/edit_product',
                          arguments: product
                      );
                    },
                  );
                } else if(userManager.adminEnabled && product.deleted){
                  return IconButton(
                    icon: Icon(Icons.assignment_turned_in_rounded, color: primaryColor,),
                    onPressed: (){
                      showDialog(context: context,
                          builder: (_) => ActiveProductDialog(product)
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: product.images.map((url){
                  return NetworkImage(url);
                }).toList(),
                dotSize: 0,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: Colors.transparent,
                autoplay: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    product.name,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(
                        fontSize: 16
                    ),
                  ),
                  if(product.price > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                      child: Text(
                      'R\$ ${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  // if(product.deleted)
                  //   const Padding(
                  //     padding: EdgeInsets.only(top: 16, bottom: 8),
                  //     child: Text(
                  //       'Este produto não está mais disponível',
                  //       style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w500,
                  //           color: Colors.red
                  //       ),
                  //     ),
                  //   )
                  // else
                  //   ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: product.options.map((o){
                          return OptionWidget(option: o,);
                        }).toList(),
                      ),
                      const SizedBox(height: 20,),
                      const Text("Observações", style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                      )),
                      TextFormField(
                        minLines: 1,
                        maxLines: 10,
                        decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Ex: retirar cebola."),
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (ob){
                          if(ob.isNotEmpty) {
                            product.listOptions.add("Observações: $ob");
                          } else {
                            product.listOptions.removeWhere((element) => element.contains("Observações"));
                          }
                        },
                        //verificar depois
                        onSaved: (ob){
                          if(ob.isNotEmpty) {
                            product.listOptions.add("Observações: $ob");
                          } else {
                            product.listOptions.removeWhere((element) => element.contains("Observações"));
                          }
                        },
                      ),
                    //],
                  const SizedBox(height: 20,),
                  Consumer2<UserManager, Product>(
                    builder: (_, userManager, product, __) {
                      return SizedBox(
                        height: 44,
                        child: RaisedButton(

                          onPressed: product.listOptions.isNotEmpty || product.price > 0
                              ? () {
                                  if (userManager.isLoggedIn) {
                                    if (context
                                        .read<CartManager>()
                                        .verifyCart(product.store)) {
                                      context
                                          .read<CartManager>()
                                          .addToCart(product);
                                      Navigator.of(context).pushNamed("/cart");
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (_) =>
                                              AlertStoresDifferent(product));
                                    }
                                  } else {
                                    Navigator.of(context).pushNamed('/login');
                                  }
                                }
                              : null,
                          color: primaryColor,
                          textColor: Colors.white,
                          child: Text(
                            userManager.isLoggedIn
                                ? 'Adicionar ao Carrinho'
                                : 'Entre para Comprar',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}