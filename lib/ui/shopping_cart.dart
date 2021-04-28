import 'dart:io';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/helpers/products_class.dart';
import 'package:e_commerce/helpers/user_class.dart';
import 'package:e_commerce/ui/list_pedido.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'showDescriptionUser.dart';
import 'showDescriptionUser.dart';

class Shopping_cart extends StatefulWidget {
  User user;

  Shopping_cart(this.user);
  @override
  _Shopping_cart createState() => _Shopping_cart();
}

class _Shopping_cart extends State<Shopping_cart> {
  List<ProductUser> list = [];
  Response response;
  Dio dio = new Dio();
  var amount = 0;
  Future<List<ProductUser>> listPedidos() async {
    var _token = widget.user.token;
    response = await dio.get(
        'https://restful-ecommerce-ufma.herokuapp.com/api/v1/cart',
        options: Options(headers: {"Authorization": "Bearer " + _token}));
    if (response.data["success"] != true) {
      throw Exception("erro na requisição");
    } else {
      amount = response.data["data"]["cartItem"]["totalAmount"];
      List<dynamic> lista =
          List<dynamic>.from(response.data["data"]["cartItem"]["items"]);
      list.clear();
      for (var i in lista) {
        list.add(ProductUser.fromJson(i));
      }
    }
    return list;
  }

  Future<bool> removerCard(ProductUser prod) async {
    var id = prod.id;
    final url =
        'https://restful-ecommerce-ufma.herokuapp.com/api/v1/cart/remove/$id';

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            title: Text("Tem certeza que deseja remover do carrinho?"),
            content: Text("O processo não pode ser desfeito."),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  "Sim",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () async {
                  try {
                    await dio.post(url,
                        options: Options(headers: {
                          "Authorization": "Bearer " + widget.user.token
                        }));
                    setState(() {
                      listPedidos();
                    });
                    Navigator.pop(context);
                  } catch (err) {
                    print(err);
                  }
                },
              ),
            ],
          );
        });
    return Future.value(false);
  }

  Future<void> finalizarPedido() async {
    final url = 'https://restful-ecommerce-ufma.herokuapp.com/api/v1/orders';
    try {
      await dio.post(url,
          options: Options(
              headers: {"Authorization": "Bearer " + widget.user.token}));
      await Navigator.push(context,
          MaterialPageRoute(builder: (context) => ListPedido(widget.user)));
    } catch (err) {
      print(err);
    }
  }

  void _showOptions(BuildContext context, ProductUser prod) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ShowDescriptionUser(widget.user, prod.toJson())));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue,
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0,
            centerTitle: true,
            leading: new IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(widget.user)));
              },
            ),
            title: Text(
              "Carrinho",
              style: TextStyle(
                color: Colors.white,
              ),
            )),
        body: Column(children: [
          FutureBuilder(
              future: listPedidos(),
              builder: (context, AsyncSnapshot<List<ProductUser>> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.hasError);
                  return Text("Erro");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: snapshot.data
                        .map((e) => GestureDetector(
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Container(
                                          width: 65.0,
                                          height: 65.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: e.image != null
                                                    ? NetworkImage(e.image)
                                                    : FileImage(
                                                        File("images/box.png")),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        //padding: EdgeInsets.only(left: 10.0),
                                        flex: 1,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                e.title ?? "",
                                                style: TextStyle(
                                                    fontSize: 21.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "R\$ " +
                                                            e.price
                                                                .toString() ??
                                                        "",
                                                    style: TextStyle(
                                                        fontSize: 19.0),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 50.0),
                                                    child: Text(
                                                      "Qtd: " +
                                                              e.qty
                                                                  .toString() ??
                                                          "",
                                                      style: TextStyle(
                                                          fontSize: 19.0),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 70.0),
                                            child: FloatingActionButton(
                                              heroTag: null,
                                              onPressed: () {
                                                removerCard(e);
                                              },
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              backgroundColor: Colors.white,
                                              mini: true,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                _showOptions(context, e);
                              },
                            ))
                        .toList(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 300.0),
                  child: Center(child: RefreshProgressIndicator()),
                );
              }),
        ]),
        floatingActionButton: FloatingActionButton.extended(
            heroTag: null,
            backgroundColor: Colors.green,
            icon: Icon(Icons.done),
            onPressed: () {
              finalizarPedido();
            },
            label: Text("Finalizar pedido"))
        //child: const Icon(
        // Icons.add_box,
        //color: Colors.white,
        //),
        //backgroundColor: Colors.blue,

        );
  }
}
