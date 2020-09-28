import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_icon_button.dart';
import 'package:lojavirtual/models/item_size.dart';
import 'package:lojavirtual/models/option.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/screens/edit_product/components/edit_option.dart';

import 'edit_item_size.dart';

class OptionsForm extends StatelessWidget {

  const OptionsForm(this.product);

  final Product product;
  //final Option option;
  //final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FormField<List<Option>>(
          initialValue: product.options,
          validator: (items){
            if(items.isEmpty){
              return 'Insira um tamanho';
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
                        "Lista de opções",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),

                    CustomIconButton(
                      iconData: Icons.add,
                      color: Colors.black,
                      onTap: (){
                        state.value.add(Option());
                        state.didChange(state.value);
                      },
                    ),
                  ],
                ),
                Column(
                  children: state.value.map((option){
                    return EditOption(
                      key: ObjectKey(option),
                      option: option,
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