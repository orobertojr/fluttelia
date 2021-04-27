import 'package:e_commerce/helpers/user_class.dart';
import 'package:flutter/material.dart';

class ToggleAdmButtonModel {
  ToggleAdmButtonModel({this.text, this.situation, User user});
  String text;
  int situation;
  User user;
}

class ToggleButtonAdm extends StatefulWidget {
  @override
  _ToggleButtonAdmState createState() => _ToggleButtonAdmState();
}

class _ToggleButtonAdmState extends State<ToggleButtonAdm> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
