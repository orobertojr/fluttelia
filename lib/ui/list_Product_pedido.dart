import 'dart:io';
import 'package:dio/dio.dart';
import 'package:e_commerce/helpers/user_class.dart';
import 'package:e_commerce/ui/shopping_cart.dart';
import 'package:e_commerce/ui/showDescriptionUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'list_pedido.dart';
import 'my_page.dart';

class ListPedidoProduct extends StatefulWidget {
  User user;
  List<dynamic> produtos;
  ListPedidoProduct(this.user, this.produtos);
  @override
  _ListPedidoProductState createState() => _ListPedidoProductState();
}

class _ListPedidoProductState extends State<ListPedidoProduct> {
  List names = new List.empty(); // names we get from API
  List filteredNames = new List.empty(); // names filtered by search text
  Widget _appBarTitle = new Text('Lista de Produtos');
  void initState() {
    super.initState();
    this._buildList();
    this.filteredNames = widget.produtos;
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      // leading: new IconButton(  //falta arrumar busca pra atualizar lista - PENDENTE!
      // icon: _searchIcon,
      //color: Colors.white,
      //onPressed: _searchPressed,
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return _productCard(context, index);
      },
    );
  }

  Widget _productCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  width: 65.0,
                  height: 65.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: filteredNames[index] != null
                            ? NetworkImage(filteredNames[index]["imageUrl"])
                            : FileImage(File("images/box.png")),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(
                //padding: EdgeInsets.only(left: 10.0),
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        filteredNames[index]['title'] ?? "",
                        style: TextStyle(
                            fontSize: 21.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "R\$ " + filteredNames[index]['price'].toString() ?? "",
                        style: TextStyle(fontSize: 19.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        //_showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ShowDescriptionUser(widget.user, names[index])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildBar(context),
        body: Container(
          child: _buildList(),
        ));
  }
}
