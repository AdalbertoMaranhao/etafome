import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:lojavirtual/models/store.dart';
import 'package:lojavirtual/models/stores_manager.dart';
import 'package:lojavirtual/services/cepaberto_service.dart';
import 'package:provider/provider.dart';

import 'components/store_card.dart';

class StoresScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Lojas'),
        centerTitle: true,
      ),
      body: Consumer<StoresManager>(
        builder: (_, storesManager, __){
          if(storesManager.storesCity.isEmpty){
            return const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
              backgroundColor: Colors.transparent,
            );
          }
          
          return ListView.builder(
            itemCount: storesManager.storesCity.length,
            itemBuilder: (_, index){
              return StoreCard(storesManager.storesCity[index]);
            },
          );
        },
      ),
    );
  }


}