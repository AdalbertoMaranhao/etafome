class SectionItem {

  SectionItem({this.image, this.store});

  SectionItem.fromMap(Map<String, dynamic> map){
    image = map['image'] as String;
    store = map['store'] as String;
  }

  dynamic image;
  String store;

  SectionItem clone() {
    return SectionItem(
      image: image,
      store: store
    );
  }

  @override
  String toString() {
    return 'SectionItems{image: $image, store: $store}';
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'store': store
    };
  }

}