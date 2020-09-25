import 'package:flutter/material.dart';
import 'package:lojavirtual/models/item_size.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:provider/provider.dart';

class SizeWidget extends StatefulWidget {

  const SizeWidget({this.size, this.title});

  final Item size;
  final String title;

  @override
  _SizeWidgetState createState() => _SizeWidgetState();
}

class _SizeWidgetState extends State<SizeWidget> {
  bool select = false;

  @override
  Widget build(BuildContext context) {
    final product = context.watch<Product>();
    // final selected = widget.size == product.selectedSize;


    return CheckboxListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.size.name),
          if(widget.size.price > 0)
            Text("R\$ ${widget.size.price.toStringAsFixed(2)}")
        ],
      ),
      //subtitle: Text(size.price.toStringAsFixed(2)),
      value: select,
      activeColor: Theme.of(context).primaryColor,
      onChanged: (bool val) {
        setState((){
          num price= 0;
          select = val;
          print(product.price);
          if(select) {
            product.listOptions.add("${widget.title} - ${widget.size.name}");
            product.setOrderPriceMais(widget.size.price);

          } else {
            product.listOptions.remove("${widget.title} - ${widget.size.name}");
            product.setOrderPriceMenos(widget.size.price);
          }
        });
        print(product.orderPrice);
        print(product.listOptions);
      },
    );
  }
}