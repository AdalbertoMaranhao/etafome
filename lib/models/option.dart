import 'item_size.dart';

class Option{

  Option({this.title, this.min, this.max, this.items});

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
  List<Item> itemsTemp = [];
  List<Item> items = [];

  List<Map<String, dynamic>> exportItemList() {
    if(items == null) {
      return itemsTemp.map((i) => i.toMap()).toList();
    }
    return items.map((i) => i.toMap()).toList();
  }
  Map<String, dynamic> toMap(){
    return {
      'title': title,
      'min': min,
      'max': max,
      'items': exportItemList(),
    };
  }
}