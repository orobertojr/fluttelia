import 'dart:io';
import 'package:dio/dio.dart';
import 'package:e_commerce/helpers/togglebutton_helper.dart';
import 'package:e_commerce/helpers/user_class.dart';
import 'package:e_commerce/ui/add_product.dart';
import 'package:e_commerce/ui/show_description.dart';
import 'package:flutter/material.dart';

class ListProducts extends StatefulWidget {
  User user;
  ListProducts(this.user);
  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
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
  List<ToggleButtonModel> itens = [];

  void initState() {
    super.initState();
    this._getProducts();
    this._buildList();
  }

  _getProducts() async {
    var _token = widget.user.token;
    final response = await dio.get(
        'https://restful-ecommerce-ufma.herokuapp.com/api/v1/products',
        options: Options(headers: {"Authorization": _token}));
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
        for (int i = 0; i < filteredNames.length; i++) {
          itens.add(ToggleButtonModel(
              text: filteredNames[i]['id'].toString(), user: widget.user));
        }
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
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 90.0),
                    child: ToggleButtonWidget(
                      id: itens[index],
                      token: widget.user.token,
                      user: widget.user,
                    ),
                  )),
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
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ShowDescription(names[index])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildBar(context),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProduct(widget.user)),
            ).then((value) => setState(() {
                  _getProducts();
                  _buildList();
                }));
          },
        ),
        body: Container(
          child: _buildList(),
        ));
  }
}
