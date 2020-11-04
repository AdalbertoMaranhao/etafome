import 'package:flutter/material.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:provider/provider.dart';

class ActiveProductDialog extends StatelessWidget {

  const ActiveProductDialog(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ativar ${product.name}?',),
      content: const Text('Esse produto vai ser listado novamente para os seus clientes!'),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            context.read<ProductManager>().active(product);
            Navigator.of(context).pop();
          },
          textColor: Colors.green,
          child: const Text('Ativar Produto'),
        ),
      ],
    );
  }
}