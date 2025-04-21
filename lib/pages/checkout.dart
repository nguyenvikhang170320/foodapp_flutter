import 'package:flutter/widgets.dart';
import 'package:foodapp/pages/bottomnav.dart';
import 'package:foodapp/pages/homepages.dart';
import 'package:foodapp/pages/listproduct.dart';
import 'package:foodapp/provider/cartprovider.dart';
import 'package:foodapp/provider/productprovider.dart';
import 'package:foodapp/provider/userprovider.dart';
import 'package:foodapp/services/database/databasemethod.dart';
import 'package:foodapp/services/sharedpreferences/userpreferences.dart';
import 'package:foodapp/widgets/notificationbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

class CheckOut extends StatefulWidget {
  CheckOut({super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  //text style
  final TextStyle myStyle = TextStyle(fontSize: 18);
  bool orderConfirmed = false;
  String confirmedOrderId = '';
  Map<String, dynamic> confirmedOrderData = {};
  DocumentReference? orderRef;

  //build bottom giá
  Widget _buildBottomDetail(String name, String priceName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          name,
          style: myStyle,
        ),
        Text(
          priceName,
          style: myStyle,
        ),
      ],
    );
  }

  //style button
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: Color.fromARGB(255, 11, 226, 154),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );
  // button thanh toán

  Widget _buildCheckOut() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String cartId = cartProvider.idCart;
    print(cartId);
    // Your existing checkout logic here
    double totalPrice = cartProvider.calculateTotalPrice();
    print(totalPrice);
    String reduce = cartProvider.discounts();
    print(reduce);
    double ship = cartProvider.ship();
    print(ship);
    int quantitys = cartProvider.quantitys;
    print(quantitys);
    String name = userProvider.getNameData();
    print(name);
    String email = userProvider.getEmailData();
    print(email);
    String sdt = userProvider.getPhoneData();
    print(sdt);
    String address = userProvider.getAddressData();
    print(address);
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: ElevatedButton(
        style: raisedButtonStyle,
        onPressed: cartProvider.items.isEmpty
            ? null // Disable the button if the cart is empty
            : () async {
                try {
                  await DatabaseMethods().addOrder(
                      cartId,
                      cartProvider.items
                          .map((cartItem) => cartItem.products)
                          .toList(),
                      totalPrice,
                      quantitys,
                      reduce,
                      ship,
                      name,
                      email,
                      sdt,
                      address);
                  print('Thanh toán đơn hàng thành công');
                  ToastService.showSuccessToast(context,
                      length: ToastLength.medium,
                      expandedHeight: 100,
                      message: "Thanh toán thành công");
                  productProvider.addNotification("Notification");
                  cartProvider
                      .clearCart(); //xóa sạch đơn hàng sau khi thanh toán thành công
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => BottomNav(),
                    ),
                  );
                } catch (e) {
                  print('Lỗi khi thanh toán đơn hàng: $e');
                }
              },
        child: Text('Thanh toán'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        width: 100,
        padding: EdgeInsets.only(bottom: 10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: _buildCheckOut(),
      ),
      appBar: AppBar(
        title: Text(
          "Đơn hàng",
          style: myStyle,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('Trang chủ'),
                      onTap: () {
                        Navigator.pop(context); // Đóng dialog
                        //chuyển về trang chủ
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (ctx) => BottomNav()));
                      },
                    ),
                    ListTile(
                      title: Text('Thêm sản phẩm mới'),
                      onTap: () {
                        Navigator.pop(context); // Đóng dialog
                        //chuyển trang danh sách sản phẩm
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (ctx) => ListProduct()));
                      },
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          NotificationButton(),
        ],
      ),
      body: Consumer<CartProvider>(builder: (context, cart, child) {
        if (cart.items.isEmpty) {
          return Center(
            child: Text('Giỏ hàng trống'),
          );
        }
        return ListView.builder(
          itemCount: cart.items.length,
          itemBuilder: (context, index) {
            final item = cart.items[index];
            //chuyển đổi giá trị tiền tệ
            final locale = 'vi_VN';
            final formatter = NumberFormat.currency(name: "đ", locale: locale);
            formatter.maximumFractionDigits = 0;
            String price = formatter.format(item.products.price);
            return Container(
              child: Column(
                children: <Widget>[
                  Card(
                    color: Colors.greenAccent,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 60,
                              width: 60,
                              child: Image.network(item.products.image),
                            ),
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        item.products.name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "Số lượng: ${item.quantity}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "Giá: " + price.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            IconButton(
                              onPressed: () {
                                final cartProvider = Provider.of<CartProvider>(
                                    context,
                                    listen: false);
                                print("delete");
                                cart.removeItem(item);
                                setState(() {
                                  cartProvider.items.isEmpty;
                                });
                              },
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
      bottomSheet: Consumer<CartProvider>(builder: (context, cart, child) {
        return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          height: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildBottomDetail("Tổng cộng:", cart.formattedPrice.toString()),
              _buildBottomDetail("Giảm %: ", cart.discountPercentage),
              _buildBottomDetail(
                  "Phí vận chuyển:", cart.formattedShip.toString()),
              _buildBottomDetail(
                  "Thành tiền:", cart.formattedTotalPrice.toString()),
            ],
          ),
        );
      }),
    );
  }
}
