import 'dart:io';
import 'package:foodapp/services/cloudinary_service.dart';
import 'package:foodapp/services/database/databasemethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/widgets/widget_support.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

class AddFeatureProduct extends StatefulWidget {
  const AddFeatureProduct({super.key});

  @override
  State<AddFeatureProduct> createState() => _AddFeatureProductState();
}

class _AddFeatureProductState extends State<AddFeatureProduct> {
  final List<String> fooditems = [
    'Đồ uống',
    'Kem',
    'Đồ ăn',
    'Thực phẩm tươi sống',
  ];
  String? valueCategory;
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController pricecontroller = new TextEditingController();
  TextEditingController detailcontroller = new TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  //chọn option : camera hay thư viện ảnh
  void showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Chọn từ thư viện'),
                onTap: () {
                  Navigator.pop(context);
                  getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Chụp ảnh'),
                onTap: () {
                  Navigator.pop(context);
                  getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //xét dữ liệu
  Future getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  //upload lên cơ sở dữ liệu
  uploadItem() async {
    if (selectedImage != null &&
        namecontroller.text != "" &&
        pricecontroller.text != "" &&
        detailcontroller.text != "") {
      try {
        // Upload ảnh lên Cloudinary
        String? uploadedUrl = await CloudinaryService().uploadImage(selectedImage!);

        if(uploadedUrl != null){
          Map<String, dynamic> addItem = {
            "Image": uploadedUrl,
            "Name": namecontroller.text,
            "Price":
            double.tryParse(pricecontroller.text) ?? 0.0, // Convert to double
            "Description": detailcontroller.text,
            "Category": valueCategory,
          };
          DocumentReference docRef =
          await DatabaseMethods().productFeatureDetail(addItem);
          String documentId = docRef.id;

          addItem['idProduct'] = documentId;

          await docRef.update({'idProduct': documentId});

          ToastService.showSuccessToast(context,
              length: ToastLength.medium,
              expandedHeight: 100,
              message: "Thêm sản phẩm nỗi bật thành công");
        } else {
          ToastService.showErrorToast(
            context,
            message: "Upload ảnh thất bại!",
          );
        }
      } catch (e) {
        print("UploadItem error: $e");
        ToastService.showErrorToast(
          context,
          message: "Có lỗi xảy ra khi upload",
        );
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Color(0xFF373866),
            )),
        centerTitle: true,
        title: Text(
          "Thêm sản phẩm nỗi bật",
          style: AppWidget.HeadlineTextFeildStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tải lên hình ảnh sản phẩm",
                style: AppWidget.semiBoolTextFeildStyle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              selectedImage == null
                  ? GestureDetector(
                      onTap: () {
                        showImagePickerOptions(); //chọn camera hay thư viện ảnh
                      },
                      child: Center(
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Tên sản phẩm",
                style: AppWidget.semiBoolTextFeildStyle(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Nhập tên sản phẩm",
                      hintStyle: AppWidget.LightTextFeildStyle()),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Giá",
                style: AppWidget.semiBoolTextFeildStyle(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: pricecontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Nhập giá",
                      hintStyle: AppWidget.LightTextFeildStyle()),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Mô tả sản phẩm",
                style: AppWidget.semiBoolTextFeildStyle(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  maxLines: 6,
                  controller: detailcontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Nhập mô tả",
                      hintStyle: AppWidget.LightTextFeildStyle()),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Select Category",
                style: AppWidget.semiBoolTextFeildStyle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                  items: fooditems
                      .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                          )))
                      .toList(),
                  onChanged: ((value) => setState(() {
                        this.valueCategory = value;
                      })),
                  dropdownColor: Colors.white,
                  hint: Text("Chọn danh mục"),
                  iconSize: 36,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  value:
                      valueCategory, // hiện danh mục đã chọn lên DropdownButton
                )),
              ),
              SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                onTap: () {
                  uploadItem();
                },
                child: Center(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Thêm",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
