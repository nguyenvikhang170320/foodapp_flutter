import 'package:foodapp/pages/bottomnav.dart';
import 'package:foodapp/pages/signup.dart';
import 'package:foodapp/pages/welcomepage.dart';
import 'package:foodapp/widgets/changescreen.dart';
import 'package:foodapp/widgets/mybuttonuser.dart';
import 'package:foodapp/widgets/emailtextformfield.dart';
import 'package:foodapp/widgets/passwordTextformfield.dart';
import 'package:foodapp/widgets/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

import '../services/sharedpreferences/userpreferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
final _messangerKey = GlobalKey<ScaffoldMessengerState>();

final RegExp nameRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

bool obserText = true;
String email = "";
String password = "";
bool isChecked = false;

TextEditingController emailController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();



class _LoginState extends State<Login> {

  void validation() async {
    if (_formkey.currentState!.validate()) {
      try {
        setState(() {
          email = emailController.text;
          password = passwordController.text;
        });
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((userCredential) async {
          // Lấy userId từ userCredential
          String userId = userCredential.user!.uid;
          // Lưu userId vào SharedPreferences
          await UserPreferences.setUid(userId);
          print("UserID đã được lưu: $userId");
        });
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        //show thông báo dạng toasty
        ToastService.showSuccessToast(context,
            length: ToastLength.medium,
            expandedHeight: 100,
            message: "Đăng nhập thành công");
        //chuyển màn hình
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNav()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ToastService.showWarningToast(context,
              length: ToastLength.medium,
              expandedHeight: 100,
              message: "Không tìm thấy người dùng nào cho email đó");
        } else if (e.code == 'wrong-password') {
          ToastService.showErrorToast(
            context,
            length: ToastLength.medium,
            expandedHeight: 100,
            message: "Sai mật khẩu",
          );
        }
      }
    } else {
      ToastService.showWarningToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "Vui lòng kiểm tra lại thông tin!! Bạn chưa nhập thông tin",
      );
    }
  }

  //form đăng nhập
  Widget _buildAllTextFormField() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          width: MediaQuery.of(context).size.width,
          height: 250,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Container(
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 20,),
                EmailTextFormField(
                  controllerUser:
                      emailController, //liên quan đến file mytextformfield.dart
                  name: "Nhập email",
                  onChanged: (value) {
                    setState(() {
                      email = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập email";
                    } else if (!emailRegExp.hasMatch(value)) {
                      return "Vui lòng nhập email hợp lệ";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10,),
                PasswordTextFormField(
                  passwordController: passwordController,
                  name: "Mật khẩu",
                  obserText: obserText,
                  onChanged: (value) {
                    setState(() {
                      password = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập mật khẩu";
                    }
                    return null;
                  },
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      obserText = !obserText;
                    });
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPart() {
    return Container(
      margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
      child: Column(
        children: [
          _buildAllTextFormField(),
          SizedBox(height: 20,),
          MyButtonUser(
            name: "Đăng nhập",
            onPressed: () {
              validation();
            },
          ),
          SizedBox(height: 80,),
          ChangeScreen(
            name: "Đăng ký",
            whichAccount: "Bạn chưa có tài khoản?",
            onTap: () {
              isChecked = false;
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => SignUp()));
            },
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _messangerKey, // dùng message scaffold
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Trang đăng nhập",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>WelcomePage()));
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 380,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color.fromARGB(255, 11, 226, 154),
                    Color.fromARGB(255, 11, 226, 154),
                  ])),
            ),
            Container(
              child: Form(
                key: _formkey,
                child: Container(
                  child: Column(
                    children: [
                      _buildBottomPart(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
