import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  final String idProduct;
  final String name;
  final double price;
  final String image;
  final String category;
  final String description;

  Products({
    required this.idProduct,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
  });

  factory Products.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Products(
      idProduct: data['idProduct'],
      name: data['Name'],
      price: data['Price'],
      image: data['Image'],
      category: data['Category'],
      description: data['Description'],
    );
  }
}
