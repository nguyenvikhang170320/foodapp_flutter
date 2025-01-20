import 'package:foodapp/widgets/widget_support.dart';
import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String name;
  final Icon icon;
  TextEditingController controllerUser = new TextEditingController();
  MyTextFormField(
      {super.key,
      required this.name,
      required this.icon,
      required this.controllerUser});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllerUser,
      decoration: InputDecoration(
        hintText: name,
        hintStyle: AppWidget.semiBoolTextFeildStyle(),
        prefixIcon: icon,
        border: OutlineInputBorder(),
      ),
    );
  }
}
