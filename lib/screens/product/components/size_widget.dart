import 'package:flutter/material.dart';
import 'package:lojavirtual/models/item_size.dart';
import 'package:lojavirtual/models/option.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:provider/provider.dart';

class SizeWidget extends StatefulWidget {

  SizeWidget({this.size, this.option});

  final Item size;
  final Option option;

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
      value: select,
      activeColor: Theme.of(context).primaryColor,
      onChanged: (bool val) {
        if(!product.listItems.contains(widget.size.name)){
          if((product.listOptionsTitle.where((element) => element.contains(widget.option.title)).length ) < widget.option.max) {
            setState(() {
               select = val;
               product.listOptionsTitle.add(widget.option.title);
               product.listItems.add(widget.size.name);
               product.listOptions.add("${widget.option.title}: ${widget.size.name}");
               product.setOrderPriceMais(widget.size.price);
             });
          } else{
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Máximo = ${widget.option.max}"),
                backgroundColor: Theme.of(context).primaryColor,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else{
          setState(() {
            select = val;
            product.listOptionsTitle.remove(widget.option.title);
            product.listItems.remove(widget.size.name);
            product.listOptions.remove("${widget.option.title}: ${widget.size.name}");
          });
        }
      },
    );
  }
}