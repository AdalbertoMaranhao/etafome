import 'package:flutter/material.dart';
import 'package:lojavirtual/models/avaliation_manager.dart';
import 'package:lojavirtual/models/avalition.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

import 'components/avaliation_tile.dart';

class AvaliationsScreen extends StatelessWidget {

  AvaliationsScreen(this.items, this.storeId);

  final List<Avaliation> items;
  final String storeId;
  Avaliation aval = Avaliation();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        child: Container(
          child: Consumer<AvaliationManager>(
            builder: (_, avaliationManager, __) {
              if(items.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    return AvaliationTile(items[index]);
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 128, 53, 73),
        foregroundColor: Colors.white,
        onPressed: () {
          if(context.read<UserManager>().isLoggedIn) {
            Navigator.of(context).pushNamed("/avaliations", arguments: storeId);
          }else {
            Navigator.of(context).pushNamed('/login');
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}