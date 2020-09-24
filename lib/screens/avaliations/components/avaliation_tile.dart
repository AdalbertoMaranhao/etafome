import 'package:flutter/material.dart';
import 'package:lojavirtual/models/avalition.dart';

class AvaliationTile extends StatelessWidget{

  AvaliationTile(this.item);

  final Avaliation item;
  List<String> emojis = ['😥', '😔', '😐', '😁', '😍',];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              item.text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.user,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 128, 53, 73)
                  ),
                ),

                if(item.grade == 1)
                  Text(
                    emojis[(item.grade - 1)],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                if(item.grade == 2)
                  Text(
                    emojis[(item.grade - 1)],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                if(item.grade == 3)
                  Text(
                    emojis[(item.grade - 1)],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                if(item.grade == 4)
                  Text(
                    emojis[(item.grade - 1)],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                if(item.grade == 5)
                  Text(
                    emojis[(item.grade - 1)],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}