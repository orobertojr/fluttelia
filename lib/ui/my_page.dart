import 'package:e_commerce/helpers/user_class.dart';
import 'package:e_commerce/ui/login_page.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  User user;
  MyPage(this.user);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Minha Conta"),
          centerTitle: true,
        ),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 330.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              //color: Colors.green,
            ),
          ),
          Positioned(
            //top: 110.0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: ClipOval(
                    child: Icon(
                  Icons.account_box,
                  size: 200,
                  color: Colors.white,
                )),
              ),
            ),
          ),
          Positioned(
              child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 250.0),
              child: Text(
                widget.user.firstName + " " + widget.user.lastName,
                style: TextStyle(color: Colors.white, fontSize: 30.0),
              ),
            ),
          )),
          Positioned(
              child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 380.0),
              child: Text(
                "Email:",
                style: TextStyle(color: Colors.black, fontSize: 25.0),
              ),
            ),
          )),
          Positioned(
              child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 430.0),
              child: Text(
                widget.user.email,
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            ),
          )),
          Positioned(
              child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 490.0),
              child: Text(
                widget.user.isAdm ? "Administrador (a)" : "Cliente",
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(
                right: 20.0, bottom: 8.0, left: 20.0, top: 530.0),
            child: Align(
              alignment: Alignment.center,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.redAccent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginUser()));
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Sair",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]));
  }
}
