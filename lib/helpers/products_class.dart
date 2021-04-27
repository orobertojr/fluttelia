class Product {
  int id;
  String title;
  String description;
  int price;
  String imagemUrl;

  Product({this.id, this.title, this.description, this.price, this.imagemUrl});

  Product.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        price = json['price'],
        imagemUrl = json['imageUrl'];
}

class ProductUser {
  int id;
  String title;
  String description;
  int price;
  String image;
  int qty;
  ProductUser(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.image,
      this.qty});

  ProductUser.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        price = json['price'],
        image = json['image'],
        qty = json["qty"];
}
