class Item{

  Item({this.name, this.price});

  Item.fromMap(Map<String, dynamic> map){
    name = map['name'] as String;
    price = map['price'] as num;
  }


  String name;
  num price;

  Item clone(){
    return Item(
      name: name,
      price: price,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'price': price,
    };
  }

  @override
  String toString() {
    return 'ItemSize{name: $name, price: $price}';
  }
}