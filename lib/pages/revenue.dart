import 'package:flutter/material.dart';
import 'package:foodapp/pages/bottomnav.dart';
import 'package:foodapp/widgets/notificationbutton.dart';
import 'package:foodapp/widgets/widget_support.dart';
class Revenue extends StatefulWidget {
  const Revenue({super.key});

  @override
  State<Revenue> createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(
          "Doanh thu",
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
      body: Container(),
    );
  }
}
