import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/common/empty_card.dart';
import 'package:lojavirtual/common/login_card.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/screens/address/components/address_card.dart';
import 'package:lojavirtual/screens/address/components/delivery_type.dart';
import 'package:lojavirtual/screens/checkout/components/cupom_card.dart';
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
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 128, 53, 73)),
        title: const Text('Carrinho', style: TextStyle(color: Color.fromARGB(255, 128, 53, 73)),),
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
              AddressCard(),
              DeliveryType(),
              CupomCard(cartManager.items.first),
              PriceCard(
                buttonText: 'Continuar para Pagamento',
                  onPressed: cartManager.isCartValid ? (){
                    Navigator.of(context).pushNamed('/checkout');
                  } : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
