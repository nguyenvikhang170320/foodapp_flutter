import 'package:foodapp/model/products.dart';
import 'package:foodapp/provider/cartprovider.dart';
import 'package:foodapp/provider/productprovider.dart';
import 'package:foodapp/widgets/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchProduct extends SearchDelegate<void> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    // Ensure searchList is initialized with data
    if (productProvider.searchList.isEmpty) {
      return Center(child: Text('Không có dữ liệu'));
    }

    List<Products> searchCategory = productProvider.searchListProducts(query);
    return GridView.count(
        childAspectRatio: 0.87,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: searchCategory
            .map(
              (e) => Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        e.image,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: Text(
                        e.name,
                        style: AppWidget.semiBoolTextFeildStyle(),
                        textAlign: TextAlign.center,
                        overflow:
                            TextOverflow.ellipsis, // nếu quá dài sẽ hiện "..."
                        maxLines: 2, // cho phép 2 dòng
                      ),
                    ),
                    Text(
                      "${e.price.toString()} đ",
                      style: AppWidget.semiBoolTextFeildStyle(),
                    ),
                  ],
                ),
              ),
            )
            .toList());
  }

  void getProduct() {}
  @override
  Widget buildSuggestions(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: true);
    // Ensure searchList is initialized with data
    if (productProvider.searchListProduct.isEmpty) {
      return Center(child: Text('Không có dữ liệu'));
    }

    List<Products> searchListProduct =
        productProvider.searchListProducts(query);
    return GridView.count(
        childAspectRatio: 0.87,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: searchListProduct
            .map(
              (e) => Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        e.image,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: Text(
                        e.name,
                        style: AppWidget.semiBoolTextFeildStyle(),
                        textAlign: TextAlign.center,
                        overflow:
                            TextOverflow.ellipsis, // nếu quá dài sẽ hiện "..."
                        maxLines: 2, // cho phép 2 dòng
                      ),
                    ),
                    Text(
                      "${e.price.toString()} đ",
                      style: AppWidget.semiBoolTextFeildStyle(),
                    ),
                  ],
                ),
              ),
            )
            .toList());
  }
}
