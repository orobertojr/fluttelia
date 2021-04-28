import 'package:e_commerce/helpers/pedidos.dart';
import 'package:e_commerce/helpers/products_class.dart';
import 'package:e_commerce/ui/home_page.dart';
import 'package:e_commerce/ui/list_Product_pedido.dart';
import 'package:e_commerce/ui/my_page.dart';
import 'package:e_commerce/ui/show_description.dart';
import 'package:flutter/material.dart';
import '../helpers/user_class.dart';
import 'package:dio/dio.dart';

class ListPedido extends StatefulWidget {
  User user;
  ListPedido(this.user);
  @override
  _ListPedidoState createState() => _ListPedidoState();
}

class _ListPedidoState extends State<ListPedido> with TickerProviderStateMixin {
  var listProducts = new Product();
  Dio dio = new Dio();
  List<Pedidos> listAll = [];
  List<Pedidos> listPending = [];
  List<Pedidos> listCancelled = [];
  List<Pedidos> listDone = [];
  List itens = [];
  List itens2 = [];
  List itens3 = [];
  List itens4 = [];
  List<Pedidos> names = new List.empty();
  List<Pedidos> names2 = new List.empty();
  List<Pedidos> names3 = new List.empty();
  List<Pedidos> names4 = new List.empty();
  Map<String, dynamic> names3Map;
  Response response;
  bool _showNotch = true;
  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.centerDocked;

  void _listAll() async {
    var _token = widget.user.token;

    try {
      response = await dio.get(
          'https://restful-ecommerce-ufma.herokuapp.com/api/v1/orders',
          options: Options(headers: {"Authorization": "Bearer " + _token}));

      if (response.data["success"] != true) {
        throw Exception("erro na requisição");
      }
    } catch (e) {
      print(e);
    }

    List<dynamic> listaPed = List<dynamic>.from(response.data["data"]);
    listAll.clear();
    listPending.clear();
    listDone.clear();
    listCancelled.clear();

    for (var i in listaPed) {
      listAll.add(Pedidos.fromJson(i));
      if (i["status"].toString() == "pending") {
        listPending.add(Pedidos.fromJson(i));
      } else if (i["status"].toString() == "completed") {
        listDone.add(Pedidos.fromJson(i));
      } else if (i["status"].toString() == "cancelled") {
        listCancelled.add(Pedidos.fromJson(i));
      }
    }

    setState(() {
      names = listAll;
      names2 = listDone;
      names3 = listPending;
      names4 = listCancelled;
    });
  }

  Future<bool> pagarPedido(String idPedido, BuildContext context) async {
    var id = int.parse(idPedido);
    final url =
        'https://restful-ecommerce-ufma.herokuapp.com/api/v1/orders/$id/pay';

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            title: Text("Confirme o pagamento"),
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

  Future<bool> cancelarPedido(String idPedido, BuildContext context) async {
    var id = int.parse(idPedido);
    final url =
        'https://restful-ecommerce-ufma.herokuapp.com/api/v1/orders/$id/cancel';

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            title: Text("Tem certeza que deseja cancelar?"),
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

  void _showOptions(BuildContext context, List<dynamic> produtos) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListPedidoProduct(widget.user, produtos)));
  }

  Widget _productCardDone(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("images/fruitBasket.png"),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Valor do pedido: R\$ " +
                                names2[index].grandTotal.toString() ??
                            "",
                        style: TextStyle(
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      Text(names2[index].listaProd.isEmpty
                          ? "Quantidade de itens: 0"
                          : "Quantidade de itens: " +
                              names2[index].listaProd[0]["qty"].toString()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, names2[index].listaProd);
      },
    );
  }

  Widget _productCardPending(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("images/fruitBasket.png"),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Container(
                //padding: EdgeInsets.only(left: 10.0),
                //flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Valor do pedido: R\$ " +
                                names3[index].grandTotal.toString() ??
                            "",
                        style: TextStyle(
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                      Text(names3[index].listaProd.isEmpty
                          ? "Quantidade de itens: 0"
                          : "Quantidade de itens: " +
                              names3[index].listaProd[0]["qty"].toString()),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              child: Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                pagarPedido(
                                    names3[index].id.toString(), context);
                              },
                            ),
                            FlatButton(
                              child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                cancelarPedido(
                                    names3[index].id.toString(), context);
                              },
                            ),
                          ]))),
            ],
          ),
        ),
      ),
      onTap: () {
        //_showOptions(context, index);
      },
    );
  }

  Widget _productCardCancelled(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("images/fruitBasket.png"),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Valor do pedido: R\$ " +
                                names4[index].grandTotal.toString() ??
                            "",
                        style: TextStyle(
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent.shade400),
                      ),
                      Text(names4[index].listaProd.isEmpty
                          ? "Quantidade de itens: 0"
                          : "Quantidade de itens: " +
                              names4[index].listaProd[0]["qty"].toString()),
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

  Widget _buildListDone() {
    _listAll();
    return ListView.builder(
      itemCount: names2 == null ? 0 : names2.length,
      itemBuilder: (BuildContext context, int index) {
        return _productCardDone(context, index);
      },
    );
  }

  Widget _buildListPending() {
    _listAll();
    return ListView.builder(
      itemCount: names3 == null ? 0 : names3.length,
      itemBuilder: (BuildContext context, int index) {
        return _productCardPending(context, index);
      },
    );
  }

  Widget _buildListCancelled() {
    _listAll();
    return ListView.builder(
      itemCount: names4 == null ? 0 : names4.length,
      itemBuilder: (BuildContext context, int index) {
        return _productCardCancelled(context, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  icon: Icon(Icons.warning, color: Colors.yellow),
                  text: "PENDENTES",
                ),
                Tab(
                  icon: Icon(
                    Icons.done,
                    color: Colors.lightGreenAccent,
                  ),
                  text: "PAGOS",
                ),
                Tab(
                  icon: Icon(
                    Icons.close,
                    color: Colors.redAccent.shade400,
                  ),
                  text: "CANCELADOS",
                )
              ],
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blue,
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Lista de Pedidos",
              style: TextStyle(
                color: Colors.white,
              ),
            )),
        body: TabBarView(
          children: [
            // Icon(Icons.all_inbox),
            //Icon(Icons.all_inbox),
            _buildListPending(),
            _buildListDone(),
            _buildListCancelled()
          ],
        ),
        bottomNavigationBar: _DemoBottomAppBar(
          fabLocation: _fabLocation,
          shape: _showNotch ? const CircularNotchedRectangle() : null,
          user: widget.user,
        ),
      ),
    );
  }
}

class _DemoBottomAppBar extends StatelessWidget {
  const _DemoBottomAppBar(
      {this.fabLocation = FloatingActionButtonLocation.centerDocked,
      this.shape = const CircularNotchedRectangle(),
      this.user});

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape shape;
  final User user;
  static final List<FloatingActionButtonLocation> centerLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: Colors.blue,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: IconButton(
                tooltip: 'List Product',
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage(user)));
                },
              ),
            ),
            if (centerLocations.contains(fabLocation)) const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                tooltip: 'Conta',
                icon: const Icon(Icons.account_circle_outlined),
                iconSize: 30,
                onPressed: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyPage(user)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
