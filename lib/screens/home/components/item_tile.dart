import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lojavirtual/models/home_manager.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:lojavirtual/models/section.dart';
import 'package:lojavirtual/models/section_item.dart';
import 'package:lojavirtual/models/store.dart';
import 'package:lojavirtual/models/stores_manager.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemTile extends StatelessWidget {
  const ItemTile(this.item);

  final SectionItem item;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return GestureDetector(
      onTap: () {
        if (item.store != null) {
          final store = context.read<StoresManager>().findStoreById(item.store);
          context.read<UserManager>().adminStore(store);
          if (store != null /*&& store.status == StoreStatus.open*/) {
            Navigator.of(context).pushNamed('/productsStore', arguments: store);
          }
        }
      },
      onLongPress: homeManager.editing
          ? () {
              showDialog(
                  context: context,
                  builder: (_) {
                    final store = context
                        .read<StoresManager>()
                        .findStoreById(item.store);
                    return AlertDialog(
                      title: const Text('Editar Item'),
                      content: store != null
                          ? ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Image.network(store.image),
                              title: Text(store.name),
//                              subtitle: Text(
//                                  'R\$ ${store.basePrice.toStringAsFixed(2)}'),
                            )
                          : null,
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            context.read<Section>().removeItem(item);
                            Navigator.of(context).pop();
                          },
                          textColor: Colors.red,
                          child: const Text('Excluir'),
                        ),
                        FlatButton(
                          onPressed: () async {
                            if (store != null) {
                              item.store = null;
                            } else {
                              final Store store =
                                  await Navigator.of(context)
                                      .pushNamed('/select_product') as Store;
                              item.store = store?.id;
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text(
                              store != null ? 'Desvincular' : 'Vincular'),
                        ),
                      ],
                    );
                  });
            }
          : null,
      child: Card(
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 1,
          child: item.image is String
              ? FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: item.image as String,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  item.image as File,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
