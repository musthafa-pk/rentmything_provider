
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user_model.dart';
import '../../utils/routes/route_names.dart';
import '../user_view_model.dart';

class SplashService{

  Future<UserModel>getUserData() =>UserViewModel().getUser();

  void checkAuthentication(BuildContext context)async{

    getUserData().then((value)async{

      if(value.token.toString() == 'null' || value.token.toString() == ''){
        final userPrefrences = await SharedPreferences.getInstance();
        final userId = userPrefrences.getString('userId');
        print('helooo:$userId');
        await Future.delayed(const Duration(seconds: 3));
        if(userId != null){
          Util.userId = userId;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BottomNavigationPage()), (route) => false);
        }else
          {
            Navigator.pushNamed(context, RoutesName.login);
          }
      }else{
        await Future.delayed(const Duration(seconds: 3));
        Navigator.pushNamed(context, RoutesName.home);
      }

    }).onError((error, stackTrace){
      if(kDebugMode){
        print(error.toString());
      }
    });
  }
}