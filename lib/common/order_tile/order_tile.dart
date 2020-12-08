import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_icon_button.dart';
import 'package:lojavirtual/models/order.dart';
import 'package:lojavirtual/models/store.dart';
import 'package:lojavirtual/models/stores_manager.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:map_launcher/map_launcher.dart';

import 'cancel_order_dialog.dart';
import 'export_address_dialog.dart';
import 'order_product_tile.dart';
import 'package:provider/provider.dart';

class OrderTile extends StatelessWidget {

  OrderTile(this.order,{this.showControls = false});

  final Order order;
  final bool showControls;
  Store store;
  @override
  Widget build(BuildContext context) {

    Future<void> openMap() async{
      try {
        final availableMaps = await MapLauncher.installedMaps;

        showModalBottomSheet(
            context: context,
            builder: (_) {
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for(final map in availableMaps)
                      ListTile(
                        onTap: (){
                          map.showMarker(
                            coords: Coords(order.address.lat, order.address.long),
                            title: order.userName,
                            description: order.userName,
                          );
                          Navigator.of(context).pop();
                        },
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          width: 30,
                          height: 30,
                        ),
                      ),
                  ],
                ),
              );
            }
        );
      } catch(e){
        debugPrint(e.toString());
      }
    }



    store = context.watch<StoresManager>().findStoreById(order.storeOrderId());
    final primaryColor = Theme.of(context).primaryColor;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      order.formattedId,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'R\$ ${order.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                order.statusText,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: order.status == Status.canceled
                      ? Colors.red
                      : primaryColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        children: <Widget>[
          if(showControls)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cliente: ${order.userName}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.black),),
                      Text(order.paymentMethod,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.black),
                      ) ,
                      Text(order.deliveryType, style: const TextStyle(color: Colors.black)),
                      if(order.troco != null)
                        Text("Troco: ${order.troco}"),
                    ],
                  ),
                  if(order.status == Status.transporting)
                  CustomIconButton(
                    size: 40,
                    iconData: Icons.map,
                    color: primaryColor,
                    onTap: openMap,
                  ),
                ],
              ),
            ),
          if(!showControls && store != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Restaurante: ${store.name}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.black),),
                  Text("Telefone: ${store.phone}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.black),
                  ) ,
                ],
              ),
            ),
          Column(
            children: order.items.map((e){
              return OrderProductTile(e);
            }).toList(),
          ),
          if(showControls && order.status != Status.canceled)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FlatButton(
                    onPressed: (){
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => CancelOrderDialog(order)
                      );
                    },
                    textColor: Colors.red,
                    child: const Text('Cancelar'),
                  ),
                  FlatButton(
                    onPressed: order.back,
                    child: const Text('Recuar'),
                  ),
                  FlatButton(
                    onPressed: order.advance,
                    child: const Text('Avançar'),
                  ),
                  FlatButton(
                    onPressed: (){
                      showDialog(context: context,
                          builder: (_) => ExportAddressDialog(
                            address: order.address,
                            deliveryMethod: order.deliveryType,
                            payment: order.paymentMethod,
                            user: order.userName,
                            numOrder: order.splitOrderId()
                          )
                      );
                    },
                    textColor: primaryColor,
                    child: const Text('Entrega'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}