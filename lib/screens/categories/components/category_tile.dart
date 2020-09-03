import 'package:flutter/material.dart';
import 'package:lojavirtual/models/product.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({this.image, this.categoria});

  final String image;
  final String categoria;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed('/stores', arguments: categoria.toLowerCase());
      },
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      categoria,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                      ),
                    ),
                  )
                ],
              ),
            ),
//            Container(
//              height: 70,
//              color: Colors.black,
//              padding: const EdgeInsets.all(16),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Expanded(
//                    child: Text(
//                      categoria,
//                      style: const TextStyle(
//                        color: Colors.white,
//                        fontWeight: FontWeight.w800,
//                        fontSize: 17,
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            )
          ],
        ),
      ),
    );
  }
}