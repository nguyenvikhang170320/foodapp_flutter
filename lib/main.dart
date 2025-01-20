import 'package:foodapp/pages/bottomnav.dart';
import 'package:foodapp/pages/onboard.dart';
import 'package:foodapp/provider/cartprovider.dart';
import 'package:foodapp/provider/orderprovider.dart';
import 'package:foodapp/provider/productprovider.dart';
import 'package:foodapp/provider/userprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyDJyKKq91oobOR0xMk1HUXutzqRjKAVADk',
    appId: '1:70647042354:android:5b8e363ee4e3a3e727872b',
    messagingSenderId: 'sendid',
    projectId: 'grocery-d28df',
  )); // kết nối firebase
  await FirebaseAppCheck.instance.activate(); //bảo mật firebase app_check
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => ProductProvider()),
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
        ChangeNotifierProvider(create: (ctx) => OrderProvider()),
      ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapShot) =>
              snapShot.hasData ? BottomNav() : Onboard(),
        ),
      ),
    );
  }
}
