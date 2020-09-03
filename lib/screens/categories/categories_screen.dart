import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/categories/components/category_tile.dart';
import 'package:lojavirtual/screens/products/components/products_list_tile.dart';
import 'package:provider/provider.dart';


class CategoriesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text("Categorias"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          CategoryTile(
            image: "https://odia.ig.com.br/_midias/jpg/2020/06/24/pizza-17874446.jpg",
            categoria: "Pizzarias",
          ),
          CategoryTile(
            image: "https://www.cobsbread.com/drive/uploads/2018/02/Rainbow-Vegetable-Sandwich-850x630.jpg",
            categoria: "Lanches",
          ),
        ],
      ),
    );
  }
}
