import 'item_size.dart';

class Option{

  Option.fromMap(Map<String, dynamic> map){
    title = map['title'] as String;
    min = map['min'] as int;
    max = map['max'] as int;
    items = (map['items'] as List)
        .map((s) => Item.fromMap(s as Map<String, dynamic>))
        .toList();
  }


  String title;
  int min;
  int max;
  List<Item> items;

  Map<String, dynamic> toMap(){
    return {
      'title': title,
      'min': min,
      'max': max,
      'items': items.map((i) => i.toMap()).toList(),
    };
  }
}