import 'dart:convert';
import 'dart:io';
import 'package:e_commerce/ui/home_adm.dart';
import 'package:e_commerce/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../helpers/user_class.dart';
import 'package:http/http.dart' as http;

class LoginUser extends StatefulWidget {
  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  bool visible = false;
  User usuario = new User();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void login(String email, String password, User user) async {
    setState(() {
      visible = true;
    });
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        visible = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Por favor, preencha os campos email e senha!"),
        backgroundColor: Colors.red,
      ));
    } else {
      try {
        http.Response response = await http.post(
            Uri.parse('https://restful-ecommerce-ufma.herokuapp.com/login'),
            body: {
              'email': email,
              'password': password,
            },
            headers: {
              HttpHeaders.contentTypeHeader:
                  "application/x-www-form-urlencoded",
            });

        Map<String, dynamic> resultMap =
            Map<String, dynamic>.from(jsonDecode(response.body));

        if (resultMap["success"] == true) {
          setState(() {
            visible = false;
          });
          user.firstName = resultMap["data"]["firstName"];
          user.lastName = resultMap["data"]["lastName"];
          user.isAdm = resultMap["data"]["isAdmin"];
          user.email = resultMap["data"]["email"];
          user.token = resultMap["data"]["token"];
          if (user.isAdm) {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeAdm(user)));
          } else {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePage(user)));
          }
        } else {
          setState(() {
            visible = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("As credenciais não conferem! Tente novamente."),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        print("Erro no acesso!");
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.blue,
        body: SingleChildScrollView(
            reverse: true,
            child: Center(
              child: Stack(
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    widthFactor: 0.6,
                    heightFactor: 0.6,
                    child: Material(
                      borderRadius: BorderRadius.circular(200.0),
                      color: Color.fromRGBO(255, 255, 255, 0.4),
                      child: Container(
                        height: 380,
                        width: 380,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 100.0),
                      width: 300,
                      height: 500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Material(
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(150.0),
                            child: Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(75.0)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Image.asset('images/logoApp.png',
                                      width: 95, height: 95),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Fluttelia',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    key: ValueKey('senha'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor preencha a senha!';
                                      }
                                      return null;
                                    },
                                    controller: _controllerEmail,
                                    autocorrect: true,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.cyan),
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.cyan),
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        prefixIcon: Icon(Icons.person,
                                            color: Colors.blue),
                                        hintText: "E-mail",
                                        filled: true,
                                        fillColor: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                    height: 15.0,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Por favor preencha a senha!';
                                      }
                                      return null;
                                    },
                                    controller: _controllerPassword,
                                    autocorrect: true,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.cyan),
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.cyan),
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        prefixIcon: Icon(Icons.lock,
                                            color: Colors.blue),
                                        hintText: "Senha",
                                        filled: true,
                                        fillColor: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                    height: 15.0,
                                  ),
                                  OutlinedButton(
                                      onPressed: () {
                                        login(_controllerEmail.text,
                                            _controllerPassword.text, usuario);
                                      },
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          primary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          padding: EdgeInsets.only(
                                              right: 40.0, left: 40.0)),
                                      child: Text(
                                        "Entrar",
                                        style: TextStyle(fontSize: 12.0),
                                      ))
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                      visible: visible,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(top: 500),
                        child: SpinKitFadingCube(
                          color: Colors.white,
                          size: 15.0,
                        ),
                      )),
                ],
              ),
            )));
  }
}
