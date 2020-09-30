import 'package:flutter/material.dart';
import 'package:lojavirtual/models/item_size.dart';
import 'package:lojavirtual/models/option.dart';
import 'package:lojavirtual/screens/edit_product/components/sizes_form.dart';
import '../../../common/custom_icon_button.dart';

class EditOption extends StatelessWidget {

  const EditOption({Key key, this.option, this.onRemove}) : super(key: key);

  final Option option;
  final VoidCallback onRemove;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10,),
        const Divider(color: Colors.black,),
        Row(
          children: <Widget>[
            Expanded(
              flex: 60,
              child: TextFormField(
                initialValue: option.title,
                decoration: const InputDecoration(
                  labelText: 'Titulo da lista',
                  isDense: true,
                ),
                validator: (name){
                  if(name.isEmpty){
                    return 'Invalido';
                  }
                  return null;
                },
                onChanged: (name) => option.title = name,
              ),
            ),
            const SizedBox(width: 4,),
            Expanded(
              flex: 20,
              child: TextFormField(
                initialValue: option.min == null ? "0" : option.min.toString(),
                decoration: const InputDecoration(
                  labelText: 'Min',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                validator: (min){
                  if(int.tryParse(min) == null){
                    return 'Invalido';
                  }
                  return null;
                },
                onChanged: (min) => option.min = int.tryParse(min),
              ),
            ),
            const SizedBox(width: 4,),
            Expanded(
              flex: 20,
              child: TextFormField(
                initialValue: option.max == null ? "0" : option.max.toString(),
                decoration: const InputDecoration(
                  labelText: 'Max',
                  isDense: true,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (max){
                  if(int.tryParse(max) == null){
                    return 'Invalido';
                  }
                  return null;
                },
                onChanged: (max) => option.max = int.tryParse(max),
              ),
            ),
            const SizedBox(width: 4,),
            CustomIconButton(
              iconData: Icons.remove,
              color: Colors.red,
              onTap: onRemove,
            ),
          ],
        ),
        SizesForm(option),
      ],
    );
  }
}