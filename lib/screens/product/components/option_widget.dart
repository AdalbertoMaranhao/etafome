import 'package:flutter/material.dart';
import 'package:lojavirtual/models/option.dart';
import 'package:lojavirtual/screens/product/components/size_widget.dart';

class OptionWidget extends StatelessWidget{

  const OptionWidget({this.option});

  final Option option;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            option.title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
        Wrap(
          spacing: 1,
          runSpacing: 1,
          children: option.items.map((s){
            return SizeWidget(size: s, option: option,);
          }).toList(),
        ),
      ],
    );
  }
}