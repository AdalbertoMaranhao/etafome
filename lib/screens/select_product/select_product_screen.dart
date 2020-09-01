import 'package:flutter/material.dart';
import 'package:lojavirtual/models/stores_manager.dart';
import 'package:provider/provider.dart';

class SelectProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vincular Produto'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Consumer<StoresManager>(
        builder: (_, storesManager, __){
          return ListView.builder(
            itemCount: storesManager.stores.length,
            itemBuilder: (_, index){
              final store = storesManager.stores[index];
              return ListTile(
                leading: Image.network(store.image),
                title: Text(store.name),
                //subtitle: Text('R\$ ${product.basePrice.toStringAsFixed(2)}'),
                onTap: (){
                  Navigator.of(context).pop(store);
                },
              );
            }
          );
        },
      ),
    );
  }
}