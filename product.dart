import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));
String productToJson(Product data) => json.encode(data.toJson());
ProductElement productElementFromJson(String str) => ProductElement.fromJson(json.decode(str));
String productElementToJson(ProductElement data) => json.encode(data.toJson());

class Product {
  List<ProductElement>? product;

  Product({this.product});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        product: json["product"] == null
            ? []
            : List<ProductElement>.from(
                json["product"]!.map((x) => ProductElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product": product == null
            ? []
            : List<dynamic>.from(product!.map((x) => x.toJson())),
      };


  void updateProduct(ProductElement updatedProduct) {
    int index = product!.indexWhere((element) => element.id == updatedProduct.id);
    if (index != -1) {
      product![index] = updatedProduct; 
    }
  }
}

class ProductElement {
  String id; 
  String name;
  double price;
  String description;
  String color;
  String imageUrl;

  ProductElement({
    required this.id, 
    required this.name,
    required this.price,
    required this.description,
    required this.color,
    required this.imageUrl,
  });

  factory ProductElement.fromJson(Map<String, dynamic> json) {
    return ProductElement(
      id: json['id'] , 
      name: json['name'] as String,
      price: json['price'] is double
          ? json['price']
          : double.parse(json['price'].toString()),
      description: json['description'] as String,
      color: json['color'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id, 
        "name": name,
        "price": price,
        "description": description,
        "color": color,
        "imageUrl": imageUrl,
      };
}
