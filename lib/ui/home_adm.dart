import 'package:e_commerce/helpers/pedidos.dart';
import 'package:e_commerce/helpers/products_class.dart';
import 'package:e_commerce/ui/list_products.dart';
import 'package:e_commerce/ui/my_page.dart';
import 'package:flutter/material.dart';
import '../helpers/user_class.dart';
import 'package:dio/dio.dart';

class HomeAdm extends StatefulWidget {
  User user;
  HomeAdm(this.user);
  @override
  _HomeAdmState createState() => _HomeAdmState();
}

class _HomeAdmState extends State<HomeAdm> with TickerProviderStateMixin {
  var listProducts = new Product();
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

  bool _showFab = true;
  bool _showNotch = true;
  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.centerDocked;

  void _onShowNotchChanged(bool value) {
    setState(() {
      _showNotch = value;
    });
  }

  void _onShowFabChanged(bool value) {
    setState(() {
      _showFab = value;
    });
  }

  void _onFabLocationChanged(FloatingActionButtonLocation value) {
    setState(() {
      _fabLocation = value ?? FloatingActionButtonLocation.centerDocked;
    });
  }

  void _listProduct() async {
    var _token = widget.user.token;
    Response response;
    Dio dio = new Dio();
    response = await dio.get(
        'https://restful-ecommerce-ufma.herokuapp.com/api/v1/products',
        options: Options(headers: {"Authorization": _token}));
  }

  void _listAll() async {
    var _token = widget.user.token;
    Response response;
    Dio dio = new Dio();
    try {
      response = await dio.get(
          'https://restful-ecommerce-ufma.herokuapp.com/api/v1/orders/all',
          options: Options(headers: {"Authorization": "Bearer " + _token}));

      if (response.data["success"] != true) {
        throw Exception("erro na requisição");
      }
    } catch (e) {
      print(e);
    }

    List<dynamic> listaPed = List<dynamic>.from(response.data["data"]);
    listAll.clear();
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

  void registerProduct(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListProducts(
                user: widget.user))); //RegisterProduct(widget.user)));
  }

  Widget _productCardAll(BuildContext context, int index) {
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
                                names[index].grandTotal.toString() ??
                            "",
                        style: TextStyle(
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(names[index].listaProd.isEmpty
                          ? "Quantidade de itens: 0"
                          : "Quantidade de itens: " +
                              names[index].listaProd[0]["qty"].toString()),
                      Text(
                        "Status: " + names[index].status.toString() ?? "",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
              ),
              /* Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 90.0),
                    child: ToggleButtonWidget(
                      id: itens[index],
                      token: widget.user.token,
                      user: widget.user,
                    ),
                  )), */
            ],
          ),
        ),
      ),
      onTap: () {
        //_showOptions(context, index);
      },
    );
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
                //padding: EdgeInsets.only(left: 10.0),
                //flex: 1,
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
              /* Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 90.0),
                    child: ToggleButtonWidget(
                      id: itens[index],
                      token: widget.user.token,
                      user: widget.user,
                    ),
                  )), */
            ],
          ),
        ),
      ),
      onTap: () {
        //_showOptions(context, index);
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
              /* Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 90.0),
                    child: ToggleButtonWidget(
                      id: itens[index],
                      token: widget.user.token,
                      user: widget.user,
                    ),
                  )), */
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
                //padding: EdgeInsets.only(left: 10.0),
                //flex: 1,
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
              /* Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 90.0),
                    child: ToggleButtonWidget(
                      id: itens[index],
                      token: widget.user.token,
                      user: widget.user,
                    ),
                  )), */
            ],
          ),
        ),
      ),
      onTap: () {
        //_showOptions(context, index);
      },
    );
  }

  Widget _buildListAll() {
    _listAll();
    return ListView.builder(
      itemCount: names == null ? 0 : names.length,
      itemBuilder: (BuildContext context, int index) {
        //  return new ListTile(
        //  title: Text(filteredNames[index]['title']),
        //onTap: () => print(filteredNames[index]['title']),
        //);
/*         for (int i = 0; i < names.length; i++) {
          //itens.add(ToggleAdmButtonModel(
          //text: names[i].id.toString(), user: widget.user));
          itens.add(names[i].id.toString());
        } */
        // print("O token" + widget.user.token);
        return _productCardAll(context, index);
      },
    );
  }

  Widget _buildListDone() {
    return ListView.builder(
      itemCount: names2 == null ? 0 : names2.length,
      itemBuilder: (BuildContext context, int index) {
        //  return new ListTile(
        //  title: Text(filteredNames[index]['title']),
        //onTap: () => print(filteredNames[index]['title']),
        //);
        /*  for (int i = 0; i < names2.length; i++) {
          //itens.add(ToggleAdmButtonModel(
          //text: names[i].id.toString(), user: widget.user));
          itens2.add(names2[i].id.toString());
        } */
        // print("O token" + widget.user.token);
        return _productCardDone(context, index);
      },
    );
  }

  Widget _buildListPending() {
    return ListView.builder(
      itemCount: names3 == null ? 0 : names3.length,
      itemBuilder: (BuildContext context, int index) {
        //  return new ListTile(
        //  title: Text(filteredNames[index]['title']),
        //onTap: () => print(filteredNames[index]['title']),
        //);
        /*     for (int i = 0; i < names3.length; i++) {
          //itens.add(ToggleAdmButtonModel(
          //text: names[i].id.toString(), user: widget.user));
          itens3.add(names3[i].id.toString());
        } */
        // print("O token" + widget.user.token);
        return _productCardPending(context, index);
      },
    );
  }

  Widget _buildListCancelled() {
    return ListView.builder(
      itemCount: names4 == null ? 0 : names4.length,
      itemBuilder: (BuildContext context, int index) {
        //  return new ListTile(
        //  title: Text(filteredNames[index]['title']),
        //onTap: () => print(filteredNames[index]['title']),
        //);
        /* for (int i = 0; i < names4.length; i++) {
          //itens.add(ToggleAdmButtonModel(
          //text: names[i].id.toString(), user: widget.user));
          itens4.add(names4[i].id.toString());
        }
 */
        // print("O token" + widget.user.token);
        return _productCardCancelled(context, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  icon: Icon(Icons.all_inbox),
                  text: "TOTAL",
                ),
                Tab(
                  icon: Icon(
                    Icons.done,
                    color: Colors.lightGreenAccent,
                  ),
                  text: "CONCLUÍDOS",
                ),
                Tab(
                  icon: Icon(Icons.warning, color: Colors.yellow),
                  text: "PENDENTES",
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
            // Icon(Icons.all_inbox), Icon(Icons.all_inbox),
            //Icon(Icons.all_inbox),
            _buildListAll(),
            _buildListDone(),
            _buildListPending(),
            _buildListCancelled()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () {
            registerProduct(context);
          },
          child: ImageIcon(
            AssetImage("images/box.png"),
            color: Colors.white,
            size: 43,
          ),
          backgroundColor: Colors.orange,
        ),
        floatingActionButtonLocation: _fabLocation,
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
                tooltip: 'Search',
                icon: const Icon(Icons.search),
                onPressed: () {},
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
