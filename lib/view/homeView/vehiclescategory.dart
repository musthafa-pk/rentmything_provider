import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/productDetailsView/productdetailsView.dart';
import 'package:http/http.dart' as http;

class VehiclesCategory extends StatefulWidget {
  String category;
  VehiclesCategory({required this.category,super.key});

  @override
  State<VehiclesCategory> createState() => _VehiclesCategoryState();
}

class _VehiclesCategoryState extends State<VehiclesCategory> {


  List<dynamic> vehiclescategory = [];

  Future<dynamic> getvehicles() async {
    Map<String, dynamic> data = {
      "category":widget.category
    };
    // Define your endpoint URL
    String url = AppUrl.getProductbycatego;

    try {
      // Make the POST request
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the response body from JSON
        var responseData = jsonDecode(response.body);
        print(responseData);
        vehiclescategory.clear();
        vehiclescategory.addAll(responseData['data']);
        // Return the decoded response data
        return responseData;
      } else {
        // If the request was not successful, throw an exception
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Catch any errors that occur during the request
      print('Error: $e');
      // Throw an exception with the error message
      throw Exception('Error making POST request: $e');
    }
  }
  Future<dynamic> addtofavourite(String productID, context) async {
    Map<String, dynamic> postData = {
      "user_id": Util.userId,
      "prod_id": productID
    };
    String url = AppUrl.wishlistAdd;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        print('adding to fav success');
        var responseData = jsonDecode(response.body);
        Util.flushBarErrorMessage('${responseData['message']}',
            Icons.verified, Colors.green, context);
        return responseData;
      } else {
        var responseData = jsonDecode(response.body);
        print('failed response:${responseData}');
        Util.flushBarErrorMessage('${responseData['message']}',
            Icons.sms_failed, Colors.red, context);
        print("API request failed with status code: ${response.statusCode}");
        print(responseData);
      }
    } catch (e) {
      print("Error making POST request: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getvehicles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Text('${vehiclescategory}'),
          Expanded(
            child: FutureBuilder(
              future: getvehicles(),
              builder: (context,snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }if(snapshot.hasError){
                  return Center(child: Text('Some error happened'),);
                }if(snapshot.hasData){
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                              productId: '${snapshot.data['data'][index]['_id']}',
                              createdUserId: '${snapshot.data['data'][index]['created_by']}',)));
                          },
                          child: Stack(
                            children: [
                              Container(
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
                                                  '₹ ${snapshot.data['data'][index]['price']}',
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
                                                      '${snapshot.data['data'][index]['subtype1']}',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 10,
                                                          color:
                                                          Color.fromRGBO(255, 255, 255, 0.66),
                                                          letterSpacing: 1.6),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(padding: EdgeInsets.all(4),
                                              child: Text('${snapshot.data['data'][index]['name']}',style: TextStyle(fontWeight: FontWeight.w400,
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
                                                Text('${snapshot.data['data'][index]['location']}',style: TextStyle(fontWeight: FontWeight.w400,
                                                    fontSize: 10,
                                                    color: Color.fromRGBO(0, 0, 0, 0.66)),)
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              Positioned(
                                  top: 10,
                                  right: 10,
                                  child:snapshot.data['data'][index]['rent_status'] == false ? InkWell(
                                    onTap: (){
                                      addtofavourite('${snapshot.data['data'][index]['_id']}', context);
                                    },
                                    child: SizedBox(height: 24,width: 24,child: Image(
                                      image: AssetImage('assets/icons/unfavourite.png'),),
                                    ),
                                  ):InkWell(
                                  onTap: (){
                                    addtofavourite('${snapshot.data['data'][index]['_id']}', context);
                        },
                          child: SizedBox(height: 24,width: 24,child: Image(
                            image: AssetImage('assets/icons/favourite.png'),),
                          ),
                        )
                              )
                            ],
                          ),
                        ),
                      );
                    },);
                }else{
                  return Center(child: Text('Please restart your application'),);
                }
              }
            ),
          )
        ],
      ),
    );
  }
}