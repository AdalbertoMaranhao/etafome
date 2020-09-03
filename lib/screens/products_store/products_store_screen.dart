import 'package:flutter/material.dart';
import 'package:lojavirtual/models/admin_orders_manager.dart';
import 'package:lojavirtual/models/page_manager.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:lojavirtual/models/store.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/products/components/products_list_tile.dart';
import 'package:lojavirtual/screens/stores/stores_screen.dart';
import 'package:provider/provider.dart';

import 'components/search_dialog.dart';

class ProductsStoreScreen extends StatelessWidget {

  const ProductsStoreScreen(this.store);

  final Store store;

  @override
  Widget build(BuildContext context) {

    Future<bool> _backScreem(){
      Navigator.of(context).pop();
      context.read<UserManager>().adminClear();
    }

    return WillPopScope(
      onWillPop: _backScreem,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<ProductManager>(
            builder: (_, productManager, __){
              if(productManager.search.isEmpty){
                return const Text("Produtos");
              } else {
                return LayoutBuilder(
                  builder: (_, contrains){
                    return GestureDetector(
                      onTap: () async {
                        final search = await showDialog<String>(
                            context: context, builder: (_) => SearchDialog(productManager.search));
                        if(search != null){
                          productManager.search = search;
                        }
                      },
                      child: Container(
                        width: contrains.biggest.width,
                        child: Text(
                          productManager.search,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
          centerTitle: true,
          actions: <Widget>[
            Consumer<ProductManager>(
                builder: (_, productManager, __){
                  if(productManager.search.isEmpty){
                    return IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () async {
                        final search = await showDialog<String>(
                            context: context, builder: (_) => SearchDialog(productManager.search));
                        if(search != null){
                          productManager.search = search;
                        }
                      },
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        productManager.search = '';
                      },
                    );
                  }
                }
            ),
            Consumer<UserManager>(
              builder: (_, userManager, __){
                if(userManager.adminEnabled){
                  return IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: (){
                      Navigator.of(context).pushNamed(
                        '/create_product', arguments: store.id
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
            Consumer<UserManager>(
              builder: (_, userManager, __){
                if(userManager.adminEnabled){
                  return IconButton(
                    icon: const Icon(Icons.playlist_add_check),
                    onPressed: (){
                      context.read<AdminOrdersManager>().setStoreFilter(store);
                      Navigator.of(context).pushNamed(
                        '/orders',
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
        body: Consumer<ProductManager>(
          builder: (_, productManager, __) {
            final filteredProducts = productManager.filteredProducts;
            return ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (_, index) {
                if(filteredProducts[index].store == store.id) {
                  return ProductListTile(filteredProducts[index]);
                }
                return Container();
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).primaryColor,
          onPressed: (){
            Navigator.of(context).pushNamed('/cart');
          },
          child: Icon(Icons.shopping_cart),
        ),
      ),
    );
  }
}
