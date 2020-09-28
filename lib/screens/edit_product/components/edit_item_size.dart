import 'package:flutter/material.dart';
import 'package:lojavirtual/models/item_size.dart';
import '../../../common/custom_icon_button.dart';

class EditItemSize extends StatelessWidget {

  const EditItemSize({Key key, this.item, this.onRemove,
    this.onMoveUp, this.onMoveDown}) : super(key: key);

  final Item item;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 60,
          child: TextFormField(
            initialValue: item.name,
            decoration: const InputDecoration(
              labelText: 'Titulo da opção',
              isDense: true,
            ),
            validator: (name){
              if(name.isEmpty){
                return 'Invalido';
              }
              return null;
            },
            onChanged: (name) => item.name = name,
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: item.price?.toStringAsFixed(2),
            decoration: const InputDecoration(
              labelText: 'Preço',
              isDense: true,
              prefixText: 'R\$ ',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (price){
              if(num.tryParse(price) == null){
                return 'Invalido';
              }
              return null;
            },
            onChanged: (price) => item.price = num.tryParse(price),
          ),
        ),
        CustomIconButton(
          iconData: Icons.remove,
          color: Colors.red,
          onTap: onRemove,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
          onTap: onMoveUp,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          onTap: onMoveDown,
        ),
      ],
    );
  }
}