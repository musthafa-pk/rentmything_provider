import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';

import 'package:rentmything/res/app_url.dart';


import 'package:http/http.dart' as http;
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/rentoutView/rentOutVehicle.dart';

class RentOut2 extends StatefulWidget {
  String itemName;
  RentOut2({required this.itemName,super.key});

  @override
  State<RentOut2> createState() => _RentOut2State();
}

class _RentOut2State extends State<RentOut2> {

  //function for get all sub categories....

  Map<String,dynamic> allSubCategories = {};

  Future<dynamic> getSubcategory() async {
    String url = AppUrl.getSubCategory;
    var data ={
      "type":widget.itemName
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        // headers: {},
        body: data,
      );

      if (response.statusCode == 200) {
        print('getting all subcategories...');
        // Successful API call
        var responseData = jsonDecode(response.body);
        print(responseData);
        allSubCategories.clear();
        allSubCategories.addAll(responseData);
        print(allSubCategories);
        print('length:${allSubCategories.length}');
        return jsonDecode(response.body);
      } else {
        // API call failed
        print("API request failed with status code: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      Util.flushBarErrorMessage('Some error occured',Icons.sms_failed,Colors.red,context,);
      // Exception occurred during API call
      print("Error making Post request: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(onTap: (){
          Navigator.pop(context);
        },child: Icon(Icons.arrow_circle_left,color: AppColors.color1,)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('${widget.itemName}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16 ),),
                ),
                const SizedBox(height: 20,),
                FutureBuilder(
                    future: getSubcategory(),
                    builder: (context,snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator(),);
                      }else if(snapshot.hasError){
                        return Center(child: Text('Some error occured'),);
                      }else
                        return Expanded(
                          child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  crossAxisCount:(Orientation == Orientation.portrait) ? 2 : 3),
                              itemCount:allSubCategories['data'].length,
                              itemBuilder: (BuildContext context,int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: InkWell(onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>RentOutVehicle(category:widget.itemName,subcategory:' ${allSubCategories['data'][index]['name']}',)));
                                  },
                                    child: Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(width: 0.5,color: Color.fromRGBO(167,167,167, 0.51)),
                                          boxShadow: const[
                                            BoxShadow(
                                              offset: Offset(2,2),
                                              blurRadius: 10,
                                              color: Color.fromRGBO(0, 106, 152,0.25),
                                            )
                                          ]
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 24,width: 24,child: Image.network('${allSubCategories['data'][index]['icon']}'),),
                                            Text('${allSubCategories['data'][0]['name']}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400,color: AppColors.color1),)
                                          ],
                                        ),
                                      ),
                                    ),),
                                );
                              }
                          ),
                        );
                    }
                )
              ]),
        ),
      ),
    );
  }
}