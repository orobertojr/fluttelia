import 'package:dio/dio.dart';
import 'package:e_commerce/helpers/user_class.dart';
import 'package:e_commerce/ui/shopping_cart.dart';
import 'package:flutter/material.dart';

class ShowDescriptionUser extends StatefulWidget {
  User user;
  Map<String, dynamic> data;

  ShowDescriptionUser(this.user, this.data);
  @override
  _ShowDescriptionUserState createState() => _ShowDescriptionUserState();
}

class _ShowDescriptionUserState extends State<ShowDescriptionUser> {
  Response response;
  Dio dio = new Dio();
  int _n = 1;

  final TextEditingController _controllerQuantidade = TextEditingController();

  void add() {
    setState(() {
      _n++;
    });
  }

  void minus() {
    setState(() {
      if (_n != 1) _n--;
    });
  }

  Future<void> adicionarCarrinho(
      BuildContext context, String prodId, int quantidade) async {
    print(prodId);
    print(quantidade);
    final url = 'https://restful-ecommerce-ufma.herokuapp.com/api/v1/cart/add';
    Map<String, dynamic> formData = {'productId': prodId, 'qty': quantidade};
    try {
      response = await dio.post(url,
          options: Options(
              headers: {"Authorization": "Bearer " + widget.user.token}),
          data: formData);
      if (response.data["success"] == true) {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Shopping_cart(widget.user)));
      }
    } on DioError catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (widget.data["qty"] != null && widget.data["qty"] != 1) {
        _n = widget.data["qty"];
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes de " + widget.data["title"]),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        child: Stack(children: [
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
                padding: const EdgeInsets.only(top: 40.0),
                child: ClipOval(
                    child: Image.network(widget.data["imageUrl"],
                        width: 200, height: 200, fit: BoxFit.cover)),
              ),
            ),
          ),
          Positioned(
              child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 300.0),
              child: Text(
                "Descrição:",
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ),
          )),
          Positioned(
              child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 335.0),
              child: Text(
                widget.data["description"],
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ),
          )),
          Positioned(
              child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 380.0),
              child: Text(
                "Preço:",
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ),
          )),
          Positioned(
              child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 415.0),
              child: Text(
                "R\$" + (widget.data["price"] * _n).toString(),
                style: TextStyle(color: Colors.green, fontSize: 35.0),
              ),
            ),
          )),
          Positioned(
              child: Padding(
            padding: const EdgeInsets.only(top: 465.0, left: 175),
            child: Text(
              "Quantidade:",
              style: TextStyle(fontSize: 12),
            ),
          )),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(top: 490, left: 169),
              child: Row(
                children: [
                  SizedBox(
                    width: 23,
                    height: 23,
                    child: FloatingActionButton(
                        heroTag: null,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.remove,
                          color: Colors.black,
                          size: 15,
                        ),
                        onPressed: minus),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "$_n",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 23,
                    height: 23,
                    child: FloatingActionButton(
                        heroTag: null,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 15,
                        ),
                        onPressed: add),
                  )
                ],
              ),
            ),
          )
          /* Positioned(
              child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding:
                    const EdgeInsets.only(top: 500.0, left: 150, right: 120),
                child: TextField(
                  controller: _controllerQuantidade,
                  decoration: InputDecoration(
                    labelText: "Quantidade",
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                )),
          )) */
          ,
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        backgroundColor: Colors.orange,
        label: Row(children: <Widget>[
          Text("Adicionar ao carrinho "),
          Icon(Icons.add_shopping_cart)
        ]),
        onPressed: () {
          adicionarCarrinho(context, widget.data["id"].toString(), _n);
        },
      ),
    );
  }
}
