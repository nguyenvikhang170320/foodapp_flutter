import 'package:foodapp/model/colorsize.dart';
import 'package:foodapp/pages/bottomnav.dart';
import 'package:foodapp/pages/checkout.dart';
import 'package:foodapp/provider/cartprovider.dart';
import 'package:foodapp/services/database/databasemethod.dart';
import 'package:foodapp/widgets/notificationbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodapp/widgets/widget_support.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

import '../model/products.dart';

class DetailPage extends StatefulWidget {
  final Products products;

  DetailPage({required this.products});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int count = 1; //tăng-giảm số lượng
  String _selectedSize = ""; // Selected size
  //text style
  final TextStyle myStyle = TextStyle(fontSize: 18);
  String selectedColor = '';



  //load hình ảnh
  Widget _buildImage() {
    return Container(
      width: 320,
      child: Card(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Container(
            height: 220,
            child: Image.network(widget.products.image),
          ),
        ),
      ),
    );
  }

  //tên sản phẩm and chữ mô tả
  Widget _buildNameAndDescription() {
    //chuyển đổi giá trị tiền tệ
    final locale = 'vi_VN';
    final formatter = NumberFormat.currency(name:"đ",locale: locale);
    formatter.maximumFractionDigits = 0;
    String price = formatter.format(widget.products.price);
    return Container(
      height: 150,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Sản phẩm: "+widget.products.name, style: myStyle),
              Text(
                "Giá: "+ price.toString(),
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              Text(
                "Mô tả",
                style: myStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  //mô tả sản phẩm
  Widget _buildDescription() {
    return Container(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          Text(
            widget.products.description,
            style: AppWidget.LightTextFeildStyle(),
          ),
        ],
      ),
    );
  }

  //số lượng tăng giảm
  Widget _buildQuantity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Số lượng",
          style: myStyle,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                child: Icon(Icons.remove),
                onTap: () {
                  setState(() {
                    if (count > 1) {
                      count--;
                    }
                  });
                },
              ),
              Text(
                count.toString(),
                style: myStyle,
              ),
              GestureDetector(
                child: Icon(Icons.add),
                onTap: () {
                  setState(() {
                    count++;
                  });
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  //style button
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: Colors.grey[300],
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        width: 100,
        padding: EdgeInsets.only(bottom: 10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 60,
          width: 100,
          padding: EdgeInsets.only(bottom: 10),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 60,
            width: 150,
            margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () async {
                // print(1);
                final ColorSize colorSize;

                cart.addItem(widget.products, _selectedSize,selectedColor, count);
                try {
                  await DatabaseMethods().addQuantityProduct(widget.products, count);
                  print('Thêm đơn hàng thành công');
                  ToastService.showSuccessToast(context,
                      length: ToastLength.medium,
                      expandedHeight: 100,
                      message: "Thêm sản phẩm vào giỏ hàng thành công");

                } catch (e) {
                  print('Lỗi khi thêm sản phẩm: $e');
                }

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CheckOut(),
                  ),
                );
              },
              child: Text('Thêm vào giỏ hàng'),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Chi tiết sản phẩm",
          style: myStyle,
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
      body: Container(
        child: ListView(
          children: [
            _buildImage(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildNameAndDescription(), // tên sản phẩm and chữ mô tả
                  _buildDescription(), // mô tả sản phẩm
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuantity(), // số lượng tăng giảm sản phẩm
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
