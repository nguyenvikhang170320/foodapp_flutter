import 'dart:io';

import 'package:foodapp/pages/bottomnav.dart';
import 'package:foodapp/provider/userprovider.dart';
import 'package:foodapp/services/sharedpreferences/userpreferences.dart';
import 'package:foodapp/widgets/mybuttonprofile.dart';
import 'package:foodapp/widgets/mytextformfield.dart';
import 'package:foodapp/widgets/widget_support.dart';
import 'package:foodapp/widgets/notificationbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController phoneNumber;
  late TextEditingController address;
  late TextEditingController userName;
  bool isMale = false;
  bool isEditImage = false;

  void vaildation() async {
    if (userName.text.isEmpty && phoneNumber.text.isEmpty) {
      ToastService.showToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Trường không được bỏ trống");
    } else if (userName.text.isEmpty) {
      ToastService.showToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Vui lòng nhập tên mới");
    } else if (userName.text.length < 3) {
      ToastService.showWarningToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Tên quá ngắn");
    } else if (phoneNumber.text.length < 10 || phoneNumber.text.length > 10) {
      ToastService.showToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Vui lòng nhập SĐT mới");
    } else {
      if (imageUri == null) {
        print("null");
        uploadImageDetail();
        uploadUserDetail();
      } else if (imageUri != null) {
        print("not null");
        uploadImageDetail();
        uploadUserDetail();
      }
    }
  }

  Widget _buildContainerPart() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    address = TextEditingController(text: userProvider.getAddressData());
    userName = TextEditingController(text: userProvider.getNameData());
    phoneNumber = TextEditingController(text: userProvider.getPhoneData());
    if (userProvider.getIsMaleData() == "Nam") {
      isMale = true;
    } else {
      isMale = false;
    }
    return Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSingleProfile(
                name: "Tên: ", value: userProvider.getNameData()),
            _buildSingleProfile(
                name: "Email: ", value: userProvider.getEmailData()),
            _buildSingleProfile(
                name: "SĐT: ", value: userProvider.getPhoneData()),
            _buildSingleProfile(
                name: "Giới tính: ", value: userProvider.getIsMaleData()),
            _buildSingleProfile(
                name: "Địa chỉ: ", value: userProvider.getAddressData()),
            _buildSingleProfile(
                name: "Trạng thái tài khoản: ",
                value: userProvider.getAccountStatusData()),
          ],
        ));
  }

  Widget _buildTextFormPart() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MyTextFormField(
            name: "UserName",
            controllerUser: userName,
            icon: Icon(Icons.person),
          ),
          _buildSingleProfile(
            value: userProvider.getEmailData(),
            name: "Email",
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isMale = !isMale;
              });
            },
            child: _buildSingleProfile(
              value: isMale == true ? "Nam" : "Nữ",
              name: "Giới tính",
            ),
          ),
          MyTextFormField(
            name: "Phone Number",
            controllerUser: phoneNumber,
            icon: Icon(Icons.phone),
          ),
          MyTextFormField(
            name: "Address",
            controllerUser: address,
            icon: Icon(Icons.person_pin_circle_sharp),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleProfile({required String name, required String value}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        height: 50,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: AppWidget.boldTextFeildStyle(),
            ),
            Text(
              value,
              style: AppWidget.boldTextFeildStyle(),
            ),
          ],
        ),
      ),
    );
  }

  //hình ảnh
  // ImagePicker _pickerImage = ImagePicker();
  //hình ảnh

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  Future<void> getImage({required ImageSource imageSource}) async {
    var image = await _picker.pickImage(source: imageSource);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  // bool centerCircle = false;
  bool edit = false;
  bool isImageUpdated = false;
  void uploadUserDetail() async {
    print("users");
    final uid = await UserPreferences.getUid();
    print("uid: $uid");
    // Kiểm tra UID
    if (uid == null) {
      // Hiển thị thông báo lỗi: UID không hợp lệ
      ToastService.showErrorToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Thất bại, lỗi hệ thống");
      return;
    }

    // Cập nhật dữ liệu
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': userName.text,
        'isMale': isMale ? 'Nam' : 'Nữ',
        'phone': phoneNumber.text,
        'address': address.text,
      });

      // Cập nhật thành công
      ToastService.showSuccessToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Cập nhật thông tin thành công");
    } catch (e) {
      // Xử lý lỗi
      print('Error updating user data: $e');
      ToastService.showErrorToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Cập nhật thất bại");
    }
    setState(() {
      edit = false;
    });
  }

  void uploadImageDetail() async {
    print("image");
    final uid = await UserPreferences.getUid();
    print("image_uid: $uid");
    // Kiểm tra UID
    if (uid == null) {
      // Hiển thị thông báo lỗi: UID không hợp lệ
      ToastService.showErrorToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Thất bại, không có uid");
      return;
    }

    // Cập nhật dữ liệu
    try {
      // Tạo một biến để lưu trữ URL ảnh mới (nếu có)
      String? newImageUrl;
      String? imageUrl = "";
      // Chỉ upload ảnh mới nếu có ảnh được chọn
      if (selectedImage != null) {
        newImageUrl = await _uploadImage(image: selectedImage!);
      }
      // selectedImage != null
      //     ? imageUrl = await _uploadImage(image: selectedImage!)
      //     : Container();
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'image': newImageUrl ?? imageUrl,
      });

      // Cập nhật thành công
      ToastService.showSuccessToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Cập nhật hình ảnh thành công");
    } catch (e) {
      // Xử lý lỗi
      print('Error updating user data: $e');
      ToastService.showErrorToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Cập nhật thất bại");
    }
    setState(() {
      edit = false;
    });
  }

  //tùy chọn camera hay thư viện ảnh
  Future<void> myDialogBox(context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text("Chụp ảnh"),
                    onTap: () {
                      getImage(imageSource: ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text("Chọn hình ảnh từ thư viện"),
                    onTap: () {
                      getImage(imageSource: ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  //upload lên firebase storage
  String? imageUri;
  Future<String?> _uploadImage({required File image}) async {
    final uid = await UserPreferences.getUid();
    print("uid load ảnh: $uid");
    // Generate a unique file name
    final photoName = "${DateTime.now().millisecondsSinceEpoch}-${uid}.jpg";
    Reference storageReference =
        FirebaseStorage.instance.ref().child("userImageProfile/$photoName");
    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    imageUri = await snapshot.ref.getDownloadURL();
    print("hình ảnh $imageUri");
    return imageUri;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: edit == true
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      edit = false;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) => BottomNav(),
                        ),
                      );
                    });
                  },
                ),
          actions: [
            edit == false
                ? NotificationButton()
                : IconButton(
                    onPressed: () {
                      vaildation();
                    },
                    icon: Icon(
                      Icons.check,
                      size: 30,
                      color: Colors.green,
                    ))
          ],
        ),
        body: ListView(
          children: [
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("users").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  UserProvider userProvider =
                      Provider.of<UserProvider>(context, listen: false);
                  userProvider.getUserData();
                  return Container(
                    height: 800,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    maxRadius: 65,
                                    backgroundImage: selectedImage == null
                                        ? userProvider.getImageData() == null ||
                                                userProvider
                                                    .getImageData()
                                                    .isEmpty
                                            ? AssetImage(
                                                    "assets/images/users.jpg")
                                                as ImageProvider
                                            : NetworkImage(
                                                userProvider.getImageData())
                                        : FileImage(selectedImage!),
                                  ),
                                ],
                              ),
                            ),
                            edit == true
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 220, top: 100, right: 2),
                                    child: GestureDetector(
                                      onTap: () {
                                        myDialogBox(context);
                                      },
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        Container(
                          height: 350,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  child: edit == true
                                      ? _buildTextFormPart()
                                      : _buildContainerPart(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: edit == false
                              ? MyButtonProfile(
                                  name: "Chỉnh sửa",
                                  onPressed: () {
                                    setState(() {
                                      edit = true;
                                    });
                                  },
                                )
                              : Container(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //xác minh tài khoản
                        edit == true
                            ? MyButtonProfile(
                                onPressed: () {},
                                name: "Xác minh tài khoản",
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        //xoá tài khoản
                        edit == false
                            ? MyButtonProfile(
                                onPressed: () {},
                                name: "Xóa tài khoản",
                              )
                            : SizedBox(),
                      ],
                    ),
                  );
                }),
          ],
        ));
  }
}
