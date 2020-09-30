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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(store.name,
                style: const TextStyle(color: Color.fromARGB(255, 128, 53, 73)),),
              Text(store.statusText, style: TextStyle(color: Colors.black, fontSize: 14),),
            ],
          ),
          leading: Container(),
          leadingWidth: 4,
          actions: [
            Center(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: Text(
                    "${emojis[store.media.toInt() - 1]} ${store.media.toStringAsPrecision(2)}",
                  style: const TextStyle(color: const Color.fromARGB(255, 128, 53, 73)),
                ),
              ),
            ),
            Consumer<UserManager>(
              builder: (_, userManager, __){
                if(userManager.adminEnabled){
                  return IconButton(
                    icon: const Icon(Icons.add, color: Color.fromARGB(255, 128, 53, 73),),
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
          ],
          bottom: const TabBar(
            indicatorColor: Color.fromARGB(255, 128, 53, 73),
            tabs: <Widget>[
              Tab(child: Text("Produtos", style: TextStyle(color: Color.fromARGB(255, 128, 53, 73))),),
              Tab(child: Text("Avaliações", style: TextStyle(color: Color.fromARGB(255, 128, 53, 73))),),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ProductsStoreScreen(store),
            AvaliationsScreen(avaliationManager.avaliations, store.id)
          ],
        ),
      ),
    );
  }
}