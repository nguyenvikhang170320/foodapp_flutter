import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String image;
  final String accountstatus;
  final String isMale;
  final String address;
  final String role;

  Users(
      {required this.uid,
      required this.name,
      required this.image,
      required this.email,
      required this.phone,
      required this.accountstatus,
      required this.isMale,
      required this.address,
      required this.role,});
  factory Users.fromFirestore(DocumentSnapshot doc) {
    return Users(
      uid: doc['uid'] as String,
      name: doc['name'] as String,
      image: doc['image'] as String,
      email: doc['email'] as String,
      phone: doc['phone'] as String,
      accountstatus: doc['accountstatus'] as String,
      isMale: doc['isMale'] as String,
      address: doc['address'] as String,
      role: doc['role'] as String,
    );
  }
}
