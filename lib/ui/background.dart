import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      // Here i can use size.width but use double.infinity because both work as a same
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "images/top.png",
              width: size.width * 0.35,
              color: Colors.blue.shade600,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 300,
            child: Image.asset("images/bottom_corner.png",
                width: size.width * 0.25, color: Colors.blue.shade400),
          ),
          child,
        ],
      ),
    );
  }
}
