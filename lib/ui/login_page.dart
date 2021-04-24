import 'package:e_commerce/ui/home_adm.dart';
import 'package:e_commerce/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../helpers/user_class.dart';

class LoginUser extends StatefulWidget {
  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  var _email;
  var _password;
  var isUserSignedIn = false;
  var alertaErr = false;
  User usuario = new User();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> _authenticate(String email, String password, User user) async {
    Response response;
    var dio = Dio();
    final url = 'https://restful-ecommerce-ufma.herokuapp.com/login';
    Map<String, dynamic> formData = {'email': email, 'password': password};
    print(formData);
    try {
      response = await dio.post(url, data: formData);
      setState(() {
        user.firt_name = response.data["data"]["firsName"];
        user.last_name = response.data["data"]["lastName"];
        user.isAdm = response.data["data"]["isAdmin"];
        user.email = response.data["data"]["email"];
        user.token = response.data["data"]["token"];
      });
      if (response.data["success"] == true) {
        isUserSignedIn = true;
        alertaErr = false;
      } else {
        alertaErr = true;
      }
    } on DioError catch (err) {
      print(err.response);
      if (err.response.statusCode == 400) {
        alertaErr = true;
      }
    }
  }

  void onSignIn(BuildContext context) async {
    _email = _controllerEmail.text;
    _password = _controllerPassword.text;
    await _authenticate(_email, _password, usuario);
    if (usuario.isAdm) {
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeAdm(usuario)));
    } else {
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage(usuario)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.red,
          padding: EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(130.0),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100.0)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.asset(
                          'images/carrinho.png',
                          width: 130,
                          height: 130.0,
                        )),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _controllerEmail,
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.white)),
                    ),
                    TextField(
                      controller: _controllerPassword,
                      autofocus: true,
                      obscureText: true,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                      decoration: InputDecoration(
                          labelText: "Senha",
                          labelStyle: TextStyle(color: Colors.white)),
                    ),
                    Divider(),
                    Text((alertaErr) ? 'Email ou senha incorretos' : ' '),
                    Divider(),
                    TextButton(
                      onPressed: () {
                        onSignIn(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            isUserSignedIn ? Colors.green : Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
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
                              isUserSignedIn ? 'Você está logado' : 'Entrar',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
