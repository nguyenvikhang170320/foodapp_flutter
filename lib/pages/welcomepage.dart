import 'package:foodapp/pages/login.dart';
import 'package:foodapp/pages/signup.dart';
import 'package:foodapp/widgets/changescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: Color.fromARGB(255, 240, 225, 15),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/shopping.jpg"),
                  ),
                ),
              ),
              Text(
                "Chào mừng",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Container(
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Sẵn sàng bắt đầu mua sắm, đăng ký",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Bắt đầu sử dụng app của chúng tôi",
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                      height: 50,
                      width: 300,
                      child: ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) => SignUp()));
                        },
                        child: Text('Đăng ký'),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChangeScreen(
                          name: "Đăng nhập",
                          whichAccount: "Bạn đã có tài khoản?",
                          onTap: () {
                            isChecked = false;
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (ctx) => Login()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
