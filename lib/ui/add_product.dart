import 'package:e_commerce/helpers/products_class.dart';
import 'package:e_commerce/helpers/rounded_input_field.dart';
import 'package:e_commerce/ui/background.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../helpers/user_class.dart';

class AddProduct extends StatefulWidget {
  User _user;
  AddProduct(User user) {
    _user = user;
  }

  @override
  _AddProduct createState() => _AddProduct();
}

class _AddProduct extends State<AddProduct> {
  var _title;
  var _description;
  var _price;
  var _imageUrl;
  var _cadastrado = false;

  Product _product = new Product();

  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerImageUrl = TextEditingController();

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
    _imageUrl = _controllerImageUrl.text;

    await _registerProduct(_title, _description, _price, _imageUrl, _product);
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Cadastrar Produto",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, bottom: 20.0, top: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/fruitBasket5.png",
                  height: 180,
                ),
                RoundedInputField(
                  controller: _controllerTitle,
                  hintText: "Nome",
                  icon: "images/fruitBasket.png",
                ),
                RoundedInputField(
                  controller: _controllerDescription,
                  hintText: "Descrição",
                  icon: "images/fruitBasket2.png",
                ),
                RoundedInputField(
                  controller: _controllerPrice,
                  hintText: "Preço (apenas números)",
                  icon: "images/fruitBasket3.png",
                ),
                RoundedInputField(
                  controller: _controllerImageUrl,
                  hintText: "URL da imagem",
                  icon: "images/fruitBasket4.png",
                ),
                SizedBox(
                  width: 20,
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    cadastrarProd(context);
                    setState(() {});
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
          ),
        ),
      ),
    );
  }
}
