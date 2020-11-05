import 'package:flutter/material.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:provider/provider.dart';

class DeleteProductDialog extends StatelessWidget {

  const DeleteProductDialog(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Desativar ${product.name}?',),
      content: const Text('Esse produto não estará visivel para os seus clientes!'),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            context.read<ProductManager>().delete(product);
            Navigator.of(context).pop();
          },
          textColor: Colors.red,
          child: const Text('Desativar Produto'),
        ),
      ],
    );
  }
}