import 'package:flutter/material.dart';

import '../../view_model/services/splash_services.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  SplashService splashService = SplashService();

  @override
  void initState() {
    super.initState();
    splashService.checkAuthentication(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: SizedBox(
            child: Image(
              image: AssetImage('assets/images/LOGO 2.png'),
            ),
          ),
        ),),
    );
  }
}