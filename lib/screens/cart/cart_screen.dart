import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/common/empty_card.dart';
import 'package:lojavirtual/common/login_card.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/stores_manager.dart';
import 'package:provider/provider.dart';

import '../../common/price_card.dart';
import 'components/cart_tile.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //codigo para mudar o retorno da tela do carrinho para a tela da loja, ao invés da tela do produto
//    final storeId = context.watch<CartManager>().items[0].productStore;
//    final store = context.watch<StoresManager>().findStoreById(storeId);
//    Future<bool> _backScreem(){
//      Navigator.of(context).pushNamed("/productsStore", arguments: store);
//    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          if(cartManager.user == null){
            return LoginCard();
          }

          if(cartManager.items.isEmpty){
            return const EmptyCard(
              iconData: Icons.remove_shopping_cart,
              title: 'Nenhum produto no carrinho!',
            );
          }

          return ListView(
            children: <Widget>[
              Column(
                children: cartManager.items
                    .map((cartProduct) => CartTile(cartProduct))
                    .toList(),
              ),
              PriceCard(
                buttonText: 'Continuar para Entrega',
                onPressed: cartManager.isCartValid ? (){
                  Navigator.of(context).pushNamed('/address');
                } : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
