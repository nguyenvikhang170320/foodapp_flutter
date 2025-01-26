import 'package:foodapp/pages/bottomnav.dart';
import 'package:foodapp/services/database/databasemethod.dart';
import 'package:foodapp/widgets/widget_support.dart';
import 'package:foodapp/widgets/notificationbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
 // ID của người dùng
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  Stream? hoaDonStream;

  ontheload() async {
    print(10);
    hoaDonStream = await DatabaseMethods().getAllHoaDonStream();
    setState(() {});
  }

  @override
  void initState() {
    FirebaseFirestore.instance.collectionGroup("orders").snapshots().listen((snapshot) {
      print("Firestore update: ${snapshot.docs.length} documents");
    });
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tin nhắn Chats",
          style: AppWidget.boldTextFeildStyle(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => BottomNav(),
              ),
            );
          },
        ),
        actions: <Widget>[
          NotificationButton(),
        ],
      ),
      body: Container(child: Text("Chưa có code gì hết"),),
    );
  }
}
