import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:provider/provider.dart';

class AlertStoresDifferent extends StatelessWidget {
  const AlertStoresDifferent(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return AlertDialog(
      title: const Text('Você já tem itens no seu carrinho: deseja limpar o carrnho?'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            context.read<CartManager>().clear();
            context.read<CartManager>().addToCart(product);
            Navigator.of(context).pushNamed("/cart");
          },
          textColor: primaryColor,
          child: const Text('sim'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: primaryColor,
          child: const Text('não'),
        )
      ],
    );
  }
}