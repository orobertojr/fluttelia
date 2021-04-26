import 'package:e_commerce/ui/login_page.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreenWidget(),
    );
  }
}

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SplashScreen(
            seconds: 4,
            backgroundColor: Colors.blue,
            navigateAfterSeconds: LoginUser()),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    image: DecorationImage(
                        image: AssetImage('images/logoApp.png'),
                        fit: BoxFit.fill)),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(80.0),
                child: SpinKitFadingCube(
                  color: Colors.white,
                  size: 15.0,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
