import 'package:e_commerce/helpers/products_class.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../helpers/user_class.dart';

class RegisterProduct extends StatefulWidget {
  User _user;
  RegisterProduct(User user) {
    _user = user;
  }

  @override
  _RegisterProduct createState() => _RegisterProduct();
}

class _RegisterProduct extends State<RegisterProduct> {
  var _title;
  var _description;
  var _price;
  var _imagemUrl;
  var _cadastrado = false;

  Product _product = new Product();

  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerImagemUrl = TextEditingController();

  Future<void> _registerProduct(String title, String description, int price,
      String imageUrl, Product prod) async {
    Response response;
    var dio = Dio();
    final url = 'https://restful-ecommerce-ufma.herokuapp.com/api/v1/products';
    Map<String, dynamic> formData = {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl
    };
    print(formData);
    try {
      response = await dio.post(url,
          options: Options(
              headers: {"Authorization": "Bearer " + widget._user.token}),
          data: formData);
      print(response.data);
    } on DioError catch (err) {
      print(err);
    }
  }

  void cadastrarProd(BuildContext context) async {
    _title = _controllerTitle.text;
    _description = _controllerDescription.text;
    _price = int.parse(_controllerPrice.text);
    _imagemUrl = _controllerImagemUrl.text;

    await _registerProduct(_title, _description, _price, _imagemUrl, _product);
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
            "Cadastrar Produto",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _controllerTitle,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black, fontSize: 30),
                    decoration: InputDecoration(
                        labelText: "Nome",
                        labelStyle: TextStyle(color: Colors.black)),
                  ),
                  TextField(
                    controller: _controllerDescription,
                    autofocus: true,
                    obscureText: true,
                    style: TextStyle(color: Colors.black, fontSize: 30),
                    decoration: InputDecoration(
                        labelText: "Descrição",
                        labelStyle: TextStyle(color: Colors.black)),
                  ),
                  TextField(
                    controller: _controllerPrice,
                    autofocus: true,
                    obscureText: true,
                    style: TextStyle(color: Colors.black, fontSize: 30),
                    decoration: InputDecoration(
                        labelText: "valor",
                        labelStyle: TextStyle(color: Colors.black)),
                  ),
                  TextField(
                    controller: _controllerImagemUrl,
                    autofocus: true,
                    obscureText: true,
                    style: TextStyle(color: Colors.black, fontSize: 30),
                    decoration: InputDecoration(
                        labelText: "Url da imagem",
                        labelStyle: TextStyle(color: Colors.black)),
                  ),
                  TextButton(
                    onPressed: () {
                      cadastrarProd(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
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
                            Icons.add,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Cadastrar',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
