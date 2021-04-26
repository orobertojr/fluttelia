import 'package:e_commerce/helpers/products_class.dart';
import 'package:e_commerce/ui/add_product.dart';
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

class _HomeAdmState extends State<HomeAdm> {
  var listProducts = new Product();
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
    print(response.data);
  }

  void registerProduct(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ListProducts(widget.user))); //RegisterProduct(widget.user)));
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
                  ),
                  text: "CONCLUÍDAS",
                ),
                Tab(
                  icon: Icon(Icons.warning),
                  text: "PENDENTES",
                ),
                Tab(
                  icon: Icon(
                    Icons.close,
                  ),
                  text: "CANCELADAS",
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
            Icon(Icons.all_inbox),
            Icon(Icons.done),
            Icon(Icons.warning),
            Icon(Icons.close)
          ],
        ),
        floatingActionButton: FloatingActionButton(
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
