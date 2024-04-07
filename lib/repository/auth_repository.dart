import 'package:rentmything/data/network/base_api_service.dart';
import 'package:rentmything/data/network/network_api_services.dart';

import '../res/app_url.dart';

class AuthRepository{
  BaseApiServices apiServices = NetworkApiServices();

  Future<dynamic> loginApi(dynamic data)async{
    try{
      dynamic response = await apiServices.postAPiResponse(AppUrl.loginApi, data);
      return response;
    }catch(e){
      rethrow;
    }
  }


  Future<dynamic> registerApi(dynamic data)async{
    try{
      dynamic response = await apiServices.postAPiResponse(AppUrl.userAdd, data);
      return response;
    }catch(e){
      rethrow;
    }
  }
}