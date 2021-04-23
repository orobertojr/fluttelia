import 'dart:ffi';

class Product {
  int id;
  String title;
  String description;
  Float price;
  String imagemUrl;

  Product({this.id, this.title, this.description, this.price, this.imagemUrl});

  Product.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        price = json['price'],
        imagemUrl = json['imageUrl'];
}
