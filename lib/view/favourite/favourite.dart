import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';

import 'package:rentmything/res/app_url.dart';

import 'package:http/http.dart' as http;
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
import 'package:rentmything/view/productDetailsView/productdetailsView.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {

  Map<String,dynamic> favoritelist = {};

  //api calling for get wishlist
  Future<dynamic> getfavourite() async {
    print('just called get fav');
    String url = AppUrl.getwishlist;

    Map<String, dynamic> postData = {
      "user_id":Util.userId
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        print('get favourite is success....');
        var responseData = jsonDecode(response.body);
        print('wish list is:$responseData');
        favoritelist.clear();
        favoritelist.addAll(responseData);
        return responseData;
      } else {
        print('failed get fav');
        var responseData = jsonDecode(response.body);
        print("API request failed with status code: ${response.statusCode}");
        print(responseData);
      }
    } catch (e) {
      print("Error making POST request: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(onTap: (){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>BottomNavigationPage()));
        },child: Icon(Icons.arrow_circle_left,color: AppColors.color1,size: 24,)),
        title: Text('Favourites'),
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: FutureBuilder(
                future: getfavourite(),
                builder: (context,snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  }else if(snapshot.hasError){
                    return Center(child: Text('Some error occured....!'),);
                  }else{
                    return Center(
                      child: ListView.builder(
                          itemCount: favoritelist['data'].length,
                          itemBuilder: (context,index) {
                            return Padding(
                              padding: const EdgeInsets.all(2.5),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                                    productId: '${favoritelist['data'][index]['prod_id']['_id']}',
                                    createdUserId: '${favoritelist['data'][index]['user_id']['_id']}',
                                  )));
                                },
                                child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(19),
                                        border: Border.all(
                                            width: 0.5,
                                            color: Color.fromRGBO(167, 167, 167, 0.51))),
                                    width: MediaQuery.of(context).size.width / 1.1,
                                    child: Row(
                                      children: [
                                        Padding(padding: EdgeInsets.only(left: 10),
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(15),
                                                image: DecorationImage(
                                                    image: AssetImage('assets/images/van.jpg'),
                                                    fit: BoxFit.cover)),
                                          ),),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '₹ ${favoritelist['data'][index]['prod_id']['price']}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        letterSpacing: 1),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: AppColors.color1,
                                                        borderRadius: BorderRadius.circular(18)),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 9, top: 2, bottom: 2, right: 9),
                                                      child: Text(
                                                        'Daily',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            color:
                                                            Color.fromRGBO(255, 255, 255, 0.66),
                                                            letterSpacing: 2),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 60,
                                                  ),
                                                  Icon(
                                                    Icons.favorite,
                                                    color: Colors.pink,
                                                  )
                                                ],
                                              ),
                                              Padding(padding: EdgeInsets.all(4),
                                                child: Text('Van for rent 2018 Model',style: TextStyle(fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    color: Color.fromRGBO(0, 0, 0, 0.66)),),),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_pin,
                                                    color: Colors.blue,
                                                    size: 16,
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Text('Kozhikode, West hill',style: TextStyle(fontWeight: FontWeight.w400,
                                                      fontSize: 10,
                                                      color: Color.fromRGBO(0, 0, 0, 0.66)),)
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            );
                          }
                      ),
                    );
                  }
                }
            ),
          )
        ]),
      ),
    );
  }
}