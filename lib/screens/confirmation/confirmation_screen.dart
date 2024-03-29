import 'package:flutter/material.dart';
import 'package:lojavirtual/common/order_tile/order_product_tile.dart';
import 'package:lojavirtual/models/order.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class ConfirmationScreen extends StatelessWidget {

  const ConfirmationScreen(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedido Confirmado'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          margin: const EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Número do Pedido: ${order.formattedId}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Column(
                      children: order.items.map((e){
                        return OrderProductTile(e);
                      }).toList(),
                    ),
                    Text(
                      'Valor Total: R\$ ${order.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8,),
                    FlatButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: (){
                        context.read<UserManager>().adminClear();
                        Navigator.of(context).pushNamed("/");
                      },
                      child: const Text("Tudo certo, agora é só aguardar!"),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}