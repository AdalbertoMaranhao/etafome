import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:lojavirtual/models/stores_manager.dart';
import 'package:lojavirtual/screens/stores/components/store_card.dart';
import 'package:provider/provider.dart';


class StoresCategoryScreen extends StatelessWidget {
  const StoresCategoryScreen({this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 128, 53, 73)),
        title: Text(category.toUpperCase(), style: const TextStyle(color: Color.fromARGB(255, 128, 53, 73)),),
        centerTitle: true,
      ),
      body: Consumer<StoresManager>(
        builder: (_, storesManager, __){
          if(storesManager.stores.isEmpty){
            return const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
              backgroundColor: Colors.transparent,
            );
          }

          return ListView.builder(
            itemCount: storesManager.storesCity.length,
            itemBuilder: (_, index){
              if(category != null) {
                if (storesManager.storesCity[index].category == category) {
                  return StoreCard(storesManager.storesCity[index]);
                } else{
                  return Container();
                }
              } else {
                return StoreCard(storesManager.stores[index]);
              }
            },
          );
        },
      ),
    );
  }
}