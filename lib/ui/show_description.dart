import 'package:flutter/material.dart';

class ShowDescription extends StatefulWidget {
  Map<String, dynamic> data;
  ShowDescription(this.data);
  @override
  _ShowDescriptionState createState() => _ShowDescriptionState();
}

class _ShowDescriptionState extends State<ShowDescription> {
  @override
  Widget build(BuildContext context) {
    List<String> dataCriacao =
        widget.data["createdAt"].toString().split("T")[0].split("-");
    List<String> dataUpdate =
        widget.data["updatedAt"].toString().split("T")[0].split("-");

    return Scaffold(
        appBar: AppBar(
          title: Text("Detalhes de " + widget.data["title"]),
          centerTitle: true,
        ),
        body: Stack(children: [
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
                padding: const EdgeInsets.only(top: 60.0),
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
              padding: const EdgeInsets.only(top: 350.0),
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
              padding: const EdgeInsets.only(top: 390.0),
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
              padding: const EdgeInsets.only(top: 450.0),
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
              padding: const EdgeInsets.only(top: 500.0),
              child: Text(
                "R\$" + widget.data["price"].toString(),
                style: TextStyle(color: Colors.green, fontSize: 35.0),
              ),
            ),
          )),
          Positioned(
              child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 580.0),
              child: Text(
                "Data de inclusão do produto: " +
                    dataCriacao[2] +
                    "-" +
                    dataCriacao[1] +
                    "-" +
                    dataCriacao[0],
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ),
          )),
          Positioned(
              child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 610.0),
              child: Text(
                "Data de atualização do produto: " +
                    dataUpdate[2] +
                    "-" +
                    dataUpdate[1] +
                    "-" +
                    dataUpdate[0],
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ),
          )),
        ]));
  }
}
