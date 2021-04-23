import 'package:e_commerce/helpers/user_class.dart';
import 'package:flutter/material.dart';

class HomeAdm extends StatefulWidget {
  User user;
  HomeAdm(this.user);
  @override
  _HomeAdmState createState() => _HomeAdmState();
}

class _HomeAdmState extends State<HomeAdm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(padding: EdgeInsets.all(50)),
    );
  }
}
