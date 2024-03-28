import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rentmything/view_model/user_view_model.dart';

import '../model/user_model.dart';
import '../repository/auth_repository.dart';
import '../utils/routes/route_names.dart';
import '../utils/utls.dart';


class AuthViewModel with ChangeNotifier {

  final myRepository = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;


  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  bool _signUploading = false;
  bool get signUploading => _signUploading;

  setSignUpLoading(bool value){
    _signUploading = value;
    notifyListeners();
  }


  Future<void>loginApi(dynamic data, BuildContext context)async {

    setLoading(true);
    myRepository.loginApi(data).then((value){

      setLoading(false);
      final userPreference =Provider.of<UserViewModel>(context,listen: false);
      // userPreference.saveUser(
          // UserModel(
          //   token: value['token'].toString(),
          // ));
      print('helo:$value');
      Util.userId = value['login_id'];

      Util.flushBarErrorMessage('Login Successfully',Icons.verified,Colors.green,context);
      Navigator.pushNamed(context,RoutesName.home);
      if(kDebugMode){
        print(value.toString());
      }

    }).onError((error, stackTrace){
      setLoading(false);
      if(kDebugMode){
        Util.flushBarErrorMessage(error.toString(),Icons.sms_failed,Colors.red, context);
      }
    });

  }

  Future<void>signUpApi(dynamic data, BuildContext context)async {

    setSignUpLoading(true);
    myRepository.registerApi(data).then((value){

      setSignUpLoading(false);
      Util.flushBarErrorMessage('SignUp Successfully',Icons.verified,Colors.green, context);
      Navigator.pushNamed(context,RoutesName.home);
      if(kDebugMode){
        print(value.toString());
      }

    }).onError((error, stackTrace){
      setSignUpLoading(false);
      if(kDebugMode){
        Util.flushBarErrorMessage(error.toString(),Icons.sms_failed,Colors.red, context);
      }
    });

  }
}