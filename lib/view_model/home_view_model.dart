

import 'package:flutter/cupertino.dart';

import '../data/response/api_response.dart';
import '../model/movei_model.dart';
import '../repository/home_repository.dart';

class HomeViewModel with ChangeNotifier{

  final myRepository = HomeRepository();

  ApiResponse<MovieListModel>moviesList =ApiResponse.loading();

  setMoviesList(ApiResponse<MovieListModel> response){
    moviesList = response;
    notifyListeners();
  }

  Future<void>fetchMovieListApi()async{

    setMoviesList(ApiResponse.loading());

    myRepository.movieList().then((value){
      setMoviesList(ApiResponse.completed(value));
    }).onError((error, stackTrace){
      setMoviesList(ApiResponse.error(error.toString()));
    });
  }
}