import 'package:e_commerce/helpers/products_class.dart';
import 'package:e_commerce/ui/cadastrar_Product.dart';
import 'package:flutter/material.dart';
import '../helpers/user_class.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  User user;
  HomePage(this.user);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var listProducts = new Product();
  void _listProduct() async {
    var _token = widget.user.token;
    Response response;
    Dio dio = new Dio();
    response = await dio.get(
        'https://restful-ecommerce-ufma.herokuapp.com/api/v1/products',
        options: Options(headers: {"Authorization": _token}));
    print(response.data);
  }

  void registerProduct(BuildContext context) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => RegisterProduct(widget.user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Produtos",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      body: (widget.user.isAdm)
          ? TextButton(
              onPressed: () {
                registerProduct(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                      'Cadastrar produtos',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}
