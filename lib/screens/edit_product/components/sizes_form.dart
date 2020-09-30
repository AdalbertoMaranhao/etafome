import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_icon_button.dart';
import 'package:lojavirtual/models/item_size.dart';
import 'package:lojavirtual/models/option.dart';
import 'package:lojavirtual/models/product.dart';

import 'edit_item_size.dart';

class SizesForm extends StatelessWidget {

  const SizesForm(this.option);

  final Option option;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FormField<List<Item>>(
          initialValue: option.items ?? option.itemsTemp,
          validator: (sizes){
            if(sizes.isEmpty){
              return 'Insira uma opção';
            }
            return null;
          },
          builder: (state){
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        'Opções',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    CustomIconButton(
                      iconData: Icons.add,
                      color: Colors.black,
                      onTap: (){
                        state.value.add(Item());
                        state.didChange(state.value);
                      },
                    ),
                  ],
                ),
                Column(
                  children: state.value.map((size){
                    return EditItemSize(
                      key: ObjectKey(size),
                      item: size,
                      onRemove: () {
                        state.value.remove(size);
                        state.didChange(state.value);
                      },
                      onMoveUp: size != state.value.first ? (){
                        final index = state.value.indexOf(size);
                        state.value.remove(size);
                        state.value.insert(index-1, size);
                        state.didChange(state.value);
                      } : null,
                      onMoveDown: size != state.value.last ? (){
                        final index = state.value.indexOf(size);
                        state.value.remove(size);
                        state.value.insert(index+1, size);
                        state.didChange(state.value);
                      } : null,
                    );
                  }).toList(),
                ),
                if(state.hasError)
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      state.errorText,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}