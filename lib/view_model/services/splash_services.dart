
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
        final useremail = userPrefrences.getString('email');
        print('helooo:$userId');
        print('user email is :${Util.userEmail}');
        await Future.delayed(const Duration(seconds: 3));
        if(userId != null){
          Util.userId = userId;
          Util.userEmail = useremail;
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
        Util.flushBarErrorMessage('${error}', Icons.warning, Colors.red, context);
        print(error.toString());
      }
    });
  }
}