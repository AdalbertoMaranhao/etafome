import 'package:flutter/material.dart';
import 'package:lojavirtual/models/admin_orders_manager.dart';
import 'package:lojavirtual/models/avaliation_manager.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/store.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/avaliations/avaliations_screen.dart';
import 'package:lojavirtual/screens/products_store/products_store_screen.dart';
import 'package:provider/provider.dart';

class BodyStoreScreen extends StatelessWidget{
  BodyStoreScreen(this.store);

  final Store store;

  List<String> emojis = ['😥', '😔', '😐', '😁', '😍',];

  @override
  Widget build(BuildContext context) {

    final avaliationManager = context.watch<AvaliationManager>();
    avaliationManager.loadAvaliations(store.id);

    Future<bool> _backScreem(){
      Navigator.of(context).pop();
      if(context.read<UserManager>().adminEnabled){
        context.read<UserManager>().adminClear();
      }
    }

    return WillPopScope(
      onWillPop: _backScreem,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(store.name),
            leading: Container(),
            leadingWidth: 4,
            actions: [
              Center(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: Text(
                      "${emojis[store.media.toInt() - 1]} ${store.media.toStringAsPrecision(2)}"
                  ),
                ),
              ),
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