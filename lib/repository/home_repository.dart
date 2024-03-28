

import '../data/network/base_api_service.dart';
import '../data/network/network_api_services.dart';
import '../model/movei_model.dart';
import '../res/app_url.dart';

class HomeRepository{


  BaseApiServices apiServices = NetworkApiServices();

  Future<MovieListModel>movieList()async{

    try{
      dynamic response = await apiServices.getAPiResponse(AppUrl.listPopular);
      return response = MovieListModel.fromJson(response);

    }catch(e){
      throw e;
    }
  }
}