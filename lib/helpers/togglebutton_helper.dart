import 'dart:async';

import 'package:dio/dio.dart';
import 'package:e_commerce/helpers/user_class.dart';
import 'package:e_commerce/ui/list_products.dart';
import 'package:flutter/material.dart';

class ToggleButtonModel {
  ToggleButtonModel({this.text, this.situation, this.user, this.isDelete});
  String text;
  int situation;
  User user;
  bool isDelete;
  StreamController controller;
}

class ToggleButtonWidget extends StatefulWidget {
  const ToggleButtonWidget(
      {Key key, this.id, this.token, this.user, this.botao})
      : super(key: key);
  final ToggleButtonModel id;
  final bool botao;
  final String token;
  final User user;
  @override
  _ToggleButtonWidgetState createState() => _ToggleButtonWidgetState();
}

class _ToggleButtonWidgetState extends State<ToggleButtonWidget> {
  List<bool> isSelected = [false];

  Future<bool> deleteProd(String id, BuildContext context) async {
    var dio = Dio();
    final url =
        'https://restful-ecommerce-ufma.herokuapp.com/api/v1/products/$id';

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            title: Text("Tem certeza que deseja excluir?"),
            content: Text("O processo não pode ser desfeito."),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  widget.id.isDelete = false;
                  Navigator.pop(context, widget.id.isDelete);
                  //Navigator.of(context).dispose();
                  //Navigator.of(context).initState();
                  //ListProducts().getProduct();
                  //ListProducts().buildList();
                },
              ),
              TextButton(
                child: Text(
                  "Sim",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () async {
                  print(widget.token);
                  try {
                    await dio.delete(url,
                        options: Options(headers: {
                          "Authorization": "Bearer " + widget.token
                        }));
                    widget.id.isDelete = true;
                    widget.id.controller.add(widget.id.isDelete);
                    Navigator.pop(context);
                    // Navigator.of(context).setState(() {});
                    // Navigator.pop(context, widget.id.isDelete);
                    //ListProducts().initState();
                    /*  Navigator.pop(context);
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListProducts(widget.user)));*/
                  } catch (err) {
                    print(err);
                  }
                  //Navigator.pop(context);
                },
              ),
            ],
          );
        });
    return Future.value(false);
    // } catch (err) {
    // print(err);
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
        borderRadius: BorderRadius.circular(12.0),
        children: [
          Icon(
            Icons.delete_rounded,
            color: Colors.red,
          ),
          // Padding(padding: EdgeInsets.only(left: 0.0),
          //   child: Icon(Icons.warning_amber_rounded, color: Colors.yellow,)),
        ],
        onPressed: (int value) async {
          await deleteProd(widget.id.text, context)
              .then((value) => setState(() {}));

          //setState(() {
          /*  for (int i = 0; i < isSelected.length; i++) {
              if (i != value) {
                print(isSelected[i]);
                isSelected[i] = false;
              } else {
                isSelected[i] = true;
                widget.id.situation = i; */
        }
        //}
        //);
        ,
        isSelected: isSelected);
  }
}
