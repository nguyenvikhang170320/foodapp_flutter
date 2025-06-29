import 'package:foodapp/pages/bottomnav.dart';
import 'package:foodapp/pages/chats.dart';
import 'package:foodapp/pages/contactus.dart';
import 'package:foodapp/pages/welcomepage.dart';
import 'package:foodapp/pages/listcategory.dart';
import 'package:foodapp/provider/userprovider.dart';
import 'package:foodapp/services/auth/auth.dart';
import 'package:foodapp/widgets/carouselview.dart';
import 'package:foodapp/widgets/loadproducthortical.dart';
import 'package:foodapp/widgets/loadproductvertical.dart';
import 'package:foodapp/widgets/notificationbutton.dart';
import 'package:flutter/material.dart' hide CarouselView;
import 'package:provider/provider.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final AuthMethods authMethods = AuthMethods();

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getUserData();
    //được gọi trước khi build widget
  }

  //UI load hình ảnh danh mục
  Widget _buildImageCategory(String image) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => ListCategory()));
      },
      child: Container(
        width: 30, // Set a fixed width for the images
        height: 30, // Set a fixed height for the images
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(60), // Adjust radius for perfect circle
          child: Image.asset(
            "assets/images/$image",
            fit: BoxFit.cover, // Ensure image fills the circular area
          ),
        ),
      ),
    );
  }

  //load hình ảnh và tên profile
  Widget _buildUserAccountsDrawerHeader() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    // Handle empty user list gracefully
    return UserAccountsDrawerHeader(
      accountName: Text(
        userProvider.getNameData(),
        style: TextStyle(color: Colors.black),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: userProvider.getImageData() == null ||
                userProvider.getImageData().isEmpty
            ? AssetImage("assets/images/users.jpg") as ImageProvider
            : NetworkImage(userProvider.getImageData()),
      ),
      decoration: BoxDecoration(color: Color(0xfff2f2f2)),
      accountEmail: Text(userProvider.getEmailData(),
          style: TextStyle(color: Colors.black)),
    );
  }

  Widget _buildMyDrawer() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    print(userProvider.toString());
    return Drawer(
      child: ListView(
        children: <Widget>[
          _buildUserAccountsDrawerHeader(),
          ListTile(
            onTap: () {
              setState(() {
                homeColor = true;
                cartColor = false;
                billColor = false;
                doanhthuColor = false;
                walletColor = false;
                aboutColor = false;
                callColor = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => BottomNav(),
                ),
              );
            },
            title: Text("Trang chủ"),
            leading: Icon(Icons.home),
            selected: homeColor,
          ),
          ListTile(
            onTap: () {
              //mục yêu thích
              setState(() {
                homeColor = false;
                cartColor = true;
                billColor = false;
                doanhthuColor = false;
                walletColor = false;
                aboutColor = false;
                callColor = false;
              });
              // Navigator.of(context).pushReplacement(
              //   MaterialPageRoute(
              //     builder: (ctx) => Favorites(),
              //   ),
              // );
              ToastService.showToast(context,
                  length: ToastLength.medium,
                  expandedHeight: 100,
                  message: "Chức năng đang phát triển");
            },
            title: Text("Mục yêu thích"),
            leading: Icon(Icons.favorite_border_outlined),
            selected: cartColor,
          ),
          ListTile(
            onTap: () {
              //chat
              setState(() {
                homeColor = false;
                cartColor = false;
                billColor = true;
                doanhthuColor = false;
                walletColor = false;
                aboutColor = false;
                callColor = false;
              });
              // Navigator.of(context).pushReplacement(
              //   MaterialPageRoute(
              //     builder: (ctx) => Chats(),
              //   ),
              // );
              ToastService.showToast(context,
                  length: ToastLength.medium,
                  expandedHeight: 100,
                  message: "Chức năng đang phát triển");
            },
            title: Text("Nhắn tin"),
            leading: Icon(Icons.chat_outlined),
            selected: billColor,
          ),
          ListTile(
            onTap: () {
              //gọi điện
              setState(() {
                homeColor = false;
                cartColor = false;
                billColor = false;
                doanhthuColor = false;
                walletColor = false;
                aboutColor = false;
                callColor = true;
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => ContactUs()));
            },
            title: Text("Liên hệ"),
            leading: Icon(Icons.contact_emergency),
            selected: callColor,
          ),
          ListTile(
            onTap: () {
              //đăng xuất
              authMethods.SignOut();
              //xóa sạch provider
              userProvider.signOut();
              //show thông báo dạng toasty
              ToastService.showSuccessToast(context,
                  length: ToastLength.medium,
                  expandedHeight: 100,
                  message: "Đăng xuất thành công");
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => WelcomePage()));
            },
            title: Text("Đăng xuất"),
            leading: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderDanhmuc() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Danh mục",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              //Xem danh mục
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => ListCategory(),
                ),
              );
            },
            child: Text(
              "Xem thêm",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDanhmuc() {
    return Container(
      height: 50,
      child: GridView.count(
        crossAxisCount: 1,
        crossAxisSpacing: 5,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildImageCategory("traidau.png"),
          _buildImageCategory("kem.jpg"),
          _buildImageCategory("banhuot.jpg"),
          _buildImageCategory("nuoccam.jpg"),
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  bool homeColor = true;

  bool cartColor = false;

  bool billColor = false;

  bool doanhthuColor = false;

  bool walletColor = false;

  bool aboutColor = false;

  bool callColor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      drawer: _buildMyDrawer(),
      appBar: AppBar(
        title: Text(
          "FOOD APP",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            _globalKey.currentState!.openDrawer();
          },
        ),
        actions: <Widget>[
          NotificationButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselView(),
              SizedBox(
                height: 10,
              ),
              _buildHeaderDanhmuc(),
              SizedBox(
                height: 10,
              ),
              _buildDanhmuc(),
              SizedBox(
                height: 10,
              ),
              LoadProductHortical(),
              SizedBox(
                height: 10,
              ),
              LoadProductVertical(),
            ],
          ),
        ),
      ),
    );
  }
}
