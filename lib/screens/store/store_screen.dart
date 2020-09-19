import 'package:flutter/material.dart';
import 'package:lojavirtual/models/admin_orders_manager.dart';
import 'package:lojavirtual/models/avaliation_manager.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:lojavirtual/models/store.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/avaliations/avaliations_screen.dart';
import 'package:lojavirtual/screens/products/components/products_list_tile.dart';
import 'package:lojavirtual/screens/products_store/products_store_screen.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatelessWidget{
  StoreScreen(this.store);

  final Store store;


  @override
  Widget build(BuildContext context) {

    final avaliationManager = context.watch<AvaliationManager>();
    avaliationManager.loadAvaliations(store.id);

    List<Product> productsList;

    Future<bool> _backScreem(){
      Navigator.of(context).pop();
      context.read<UserManager>().adminClear();
    }

    return WillPopScope(
      onWillPop: _backScreem,
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(store.name),
              centerTitle: true,
              flexibleSpace: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.network(store.image)
                ],
              ),
              actions: [
                Consumer<UserManager>(
                  builder: (_, userManager, __){
                    if(userManager.adminEnabled){
                      return IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
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
                builder: (_, userManager, __) {
                  if (userManager.adminEnabled) {
                    return IconButton(
                      icon: const Icon(Icons.playlist_add_check),
                      onPressed: () {
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
              bottom: const TabBar(
                indicatorColor: Colors.white,
                tabs: <Widget>[
                  Tab(text: "Produtos",),
                  Tab(text: "Avaliações",),
                ],
              ),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                ProductsStoreScreen(store),
                AvaliationsScreen(avaliationManager.avaliations, store.id)
              ],
            ),
          ),
      ),
    );
  }
}