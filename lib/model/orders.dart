import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodapp/model/products.dart';

class Orders {
  final String idHD;
  final String maHD;
  final String userId;
  final double totalAmount;
  final int soluongdadat;
  final String giamphantram;
  final String nameNM;
  final String emailNM;
  final String sdtNM;
  final String addressNM;
  final double phivanchuyen;
  final Timestamp createdAt;
  final Timestamp updateAt;
  final String status;
  final List<Products> products; // Thay đổi thành List<Product>

  Orders({
    required this.idHD,
    required this.maHD,
    required this.userId,
    required this.totalAmount,
    required this.soluongdadat,
    required this.giamphantram,
    required this.nameNM,
    required this.emailNM,
    required this.sdtNM,
    required this.addressNM,
    required this.phivanchuyen,
    required this.createdAt,
    required this.updateAt,
    required this.status,
    required this.products,
  });

  factory Orders.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<Products> products = (data['products'] as List<dynamic>).map((e) => Products.fromFirestore(e)).toList();

    return Orders(
      idHD: doc.id,
      userId: data['userId'],
      totalAmount: data['totalAmount'],
      products: products,
      maHD: data['maHD'],
      soluongdadat: data['soluongdadat'],
      updateAt: data['updateAt'],
      createdAt: data['createdAt'],
      status: data['status'],
      emailNM: data['emailNM'],
      nameNM: data['nameNM'],
      sdtNM: data['sdtNM'],
      addressNM: data['addressNM'],
      giamphantram: data['giamphantram'],
      phivanchuyen: data['phivanchuyen'],


    );
  }
}