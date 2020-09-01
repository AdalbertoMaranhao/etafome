import 'package:flutter/material.dart';

class AlertProductAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return AlertDialog(
      title: const Text('Produto adicionado ao carrinho!'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            //final store = context.read<StoresManager>().findStoreById(product.store);
            Navigator.of(context).pushNamed('/',);
          },
          textColor: primaryColor,
          child: const Text('Continuar Comprando'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/cart');
          },
          textColor: primaryColor,
          child: const Text('Finalizar compra'),
        )
      ],
    );
  }
}