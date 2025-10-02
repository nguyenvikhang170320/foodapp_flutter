import 'package:foodapp/model/products.dart';
import 'package:foodapp/pages/bottomnav.dart';
import 'package:foodapp/pages/detailpage.dart';
import 'package:foodapp/pages/search_product.dart';
import 'package:foodapp/provider/productprovider.dart';
import 'package:foodapp/services/database/databasemethod.dart';
import 'package:foodapp/widgets/notificationbutton.dart';
import 'package:foodapp/widgets/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListProduct extends StatefulWidget {
  const ListProduct({super.key});
  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  Stream? fooditemStream;

  ontheload() async {
    print("product");
    fooditemStream = await DatabaseMethods().getProductItem();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget _loadProduct() {
    return StreamBuilder(
      stream: fooditemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75, // điều chỉnh tỷ lệ ngang/dọc của card
          ),
          padding: EdgeInsets.all(12),
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            final Products products = Products.fromFirestore(ds);

            final locale = 'vi_VN';
            final formatter = NumberFormat.currency(name: "đ", locale: locale);
            formatter.maximumFractionDigits = 0;
            String price = formatter.format(ds["Price"]);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(products: products),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        ds["Image"],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      ds["Name"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      price,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Danh sách sản phẩm",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.grey,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => BottomNav(),
              ),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              try {
                final productProvider =
                    Provider.of<ProductProvider>(context, listen: false);
                final categories = await DatabaseMethods().fetchProducts();
                await productProvider.getSearchListProduct(
                    listproduct: categories);
                showSearch(context: context, delegate: SearchProduct());
                print("SearchProduct");
              } catch (e) {
                // Xử lý lỗi khi fetch dữ liệu
                print('Lỗi load sản phẩm: $e');
              }
            },
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          NotificationButton(),
        ],
      ),
      body: _loadProduct(),
    );
  }
}
