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
                items.sort((a, b) => a.grade.compareTo(b.grade));
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  reverse: true,
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
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed("/avaliations", arguments: storeId);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}