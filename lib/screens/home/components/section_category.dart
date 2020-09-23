import 'package:flutter/material.dart';
import 'package:lojavirtual/models/home_manager.dart';
import 'package:lojavirtual/models/section.dart';
import 'package:lojavirtual/screens/home/components/item_tile.dart';
import 'package:lojavirtual/screens/home/components/item_tile_category.dart';
import 'package:lojavirtual/screens/home/components/section_header.dart';
import 'package:provider/provider.dart';

import 'add_tile_widget.dart';

class SectionCategory extends StatelessWidget {
  const SectionCategory(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "CATEGORIAS",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color.fromARGB(255, 128, 53, 73),),
            ),
            SizedBox(
              height: 100,
              child: Consumer<Section>(
                builder: (_, section, __){
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      if(index < section.items.length){
                        return ItemTileCategory(section.items[index]);
                      } else {
                        return AddTileWidget();
                      }
                    },
                    separatorBuilder: (_, __) => const SizedBox(
                      width: 4,
                    ),
                    itemCount: homeManager.editing
                        ? section.items.length + 1
                        : section.items.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
