import 'dart:io';
import 'package:dio/dio.dart';
import 'package:e_commerce/helpers/togglebutton_helper.dart';
import 'package:e_commerce/helpers/user_class.dart';
import 'package:e_commerce/ui/add_product.dart';
import 'package:e_commerce/ui/shopping_cart.dart';
import 'package:e_commerce/ui/showDescriptionUser.dart';
import 'package:e_commerce/ui/show_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'list_pedido.dart';
import 'my_page.dart';

class HomePage extends StatefulWidget {
  User user;
  HomePage(this.user);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio(); // for http requests
  String _searchText = "";
  List names = new List.empty(); // names we get from API
  List filteredNames = new List.empty(); // names filtered by search text
  Icon _searchIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget _appBarTitle = new Text('Lista de Produtos');

  void initState() {
    super.initState();
    this._getProducts();
    this._buildList();
  }

  void _getProducts() async {
    //dio.close();

    Response response;
    var _token = widget.user.token;
    print(_token);
    try {
      response = await dio.get(
          'https://restful-ecommerce-ufma.herokuapp.com/api/v1/products',
          options: Options(headers: {"Authorization": _token}));

      if (response.data["success"] != true) {
        throw Exception("erro na requisição");
      }
    } catch (e) {
      print(e);
    }
    List tempList = [];
    for (int i = 0; i < response.data['data'].length; i++) {
      tempList.add(response.data['data'][i]);
      //print(tempList);
    }

    setState(() {
      names = tempList;
      filteredNames = names;
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          style: TextStyle(color: Colors.white, fontSize: 20),
          cursorColor: Colors.white,
          textAlign: TextAlign.left,
          controller: _filter,
          decoration: new InputDecoration(
              hoverColor: Colors.white,
              focusColor: Colors.white,
              fillColor: Colors.white,
              alignLabelWithHint: true,
              prefixIcon: new Icon(
                Icons.search,
                color: Colors.white,
              ),
              prefixStyle: TextStyle(color: Colors.white),
              hintText: 'Procurar produtos...',
              hintStyle: TextStyle(
                color: Colors.white,
              )),
        );
      } else {
        this._searchIcon = new Icon(
          Icons.search,
          color: Colors.white,
        );
        this._appBarTitle = new Text('Lista de Produtos');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  _ListProductsState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  //Widget _buildList() {
  Widget _buildList() {
    setState(() {});
    if (_searchText.isNotEmpty) {
      List tempList = [];
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['title']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        //  return new ListTile(
        //  title: Text(filteredNames[index]['title']),
        //onTap: () => print(filteredNames[index]['title']),
        //);
        // for (int i = 0; i < filteredNames.length; i++) {
        // itens.add(ToggleButtonModel(
        //   text: filteredNames[i]['id'].toString(), user: widget.user));
        //}
        // print("O token" + widget.user.token);
        return _productCard(context, index);
      },
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        color: Colors.white,
        onPressed: _searchPressed,
      ),
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
        _showOptions(context, index);
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
        floatingActionButton: SpeedDial(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            overlayOpacity: 0.2,
            overlayColor: Colors.cyan,
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  label: "Meu carrinho",
                  labelBackgroundColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.black),
                  backgroundColor: Colors.orange,
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Shopping_cart(widget.user)),
                      ).then((value) => setState(() {
                            _getProducts();
                            _buildList();
                          }))),
              SpeedDialChild(
                  child: Icon(
                    Icons.list_outlined,
                    color: Colors.white,
                  ),
                  label: "Meus pedidos",
                  labelBackgroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  labelStyle: TextStyle(color: Colors.black),
                  onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListPedido(widget.user)))
                      }),
              SpeedDialChild(
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.blue,
                  label: "Minha conta",
                  labelBackgroundColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.black),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyPage(widget.user))))
            ]),

        /* FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.orange,
          child: Icon(
            Icons.shopping_cart,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Shopping_cart(widget.user)),
            ).then((value) => setState(() {
                  _getProducts();
                  _buildList();
                }));
          },
        ) */
        body: Container(
          child: _buildList(),
        ));
  }
}
