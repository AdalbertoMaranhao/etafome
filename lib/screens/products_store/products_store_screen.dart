import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:lojavirtual/models/admin_orders_manager.dart';
import 'package:lojavirtual/models/avaliation_manager.dart';
import 'package:lojavirtual/models/cepaberto_address.dart';
import 'package:lojavirtual/models/page_manager.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:lojavirtual/models/store.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/products/components/products_list_tile.dart';
import 'package:lojavirtual/screens/stores/stores_screen.dart';
import 'package:lojavirtual/services/cepaberto_service.dart';
import 'package:provider/provider.dart';

import 'components/search_dialog.dart';

class ProductsStoreScreen extends StatelessWidget {

  ProductsStoreScreen(this.store);

  final Store store;
  List<String> emojis = ['😥', '😔', '😐', '😁', '😍',];


  @override
  Widget build(BuildContext context) {

    Future<bool> _backScreem(){
      Navigator.of(context).pop();
      context.read<UserManager>().adminClear();
    }

    return WillPopScope(
      onWillPop: _backScreem,
      child: Scaffold(
        body: Consumer<ProductManager>(
          builder: (_, productManager, __) {
            final filteredProducts = productManager.getStoreProducts(store.id);
            return GridView.builder(
              padding: const EdgeInsets.only(top: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                childAspectRatio: 0.8,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (_, index) {
                if(filteredProducts.isNotEmpty) {
                  return ProductListTile(filteredProducts[index]);
                }
                return Container();
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 128, 53, 73),
          foregroundColor: Colors.white,
          onPressed: () async {
            Navigator.of(context).pushNamed('/cart');
          },
          child: const Icon(Icons.shopping_cart),
        ),
      ),
    );
  }



}


