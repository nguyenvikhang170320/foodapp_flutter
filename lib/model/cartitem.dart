import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodapp/model/colorsize.dart';
import 'package:foodapp/model/products.dart';

class CartItem {
  final Products products;
  final String size;
  final String color;
  final int quantity;
  final String idCart;


  CartItem({
    required this.idCart,
    required this.products,
    required this.size,
    required this.color,
    required this.quantity,
  });

}
