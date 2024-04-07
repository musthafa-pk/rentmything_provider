import 'package:flutter/material.dart';
import 'package:rentmything/utils/routes/route_names.dart';
import 'package:rentmything/view/authView/loginScreen.dart';
import 'package:rentmything/view/authView/signup.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
import 'package:rentmything/view/splashView/splashScreen.dart';

class Routes{

  static Route<dynamic> generateRoute(RouteSettings settings){

    switch (settings.name){

      case RoutesName.splash:
        return MaterialPageRoute(builder: (BuildContext context)=>const Splash());

      case RoutesName.home:
        return MaterialPageRoute(builder: (BuildContext context)=> const BottomNavigationPage());

      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context)=>const LoginScreen());

      case RoutesName.signUp:
        return MaterialPageRoute(builder: (BuildContext context)=>const SignUp());


      default:
        return MaterialPageRoute(builder: (_){
          return const Scaffold(
            body: Center(child: Text('No Route defined'),
            ),
          );
        });
    }
  }
}