import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';

import 'package:rentmything/res/app_url.dart';

import 'package:http/http.dart' as http;
import 'package:rentmything/view/rentoutView/rentOut2.dart';

class RentOut1 extends StatefulWidget {
  const RentOut1({super.key});

  @override
  State<RentOut1> createState() => _RentOut1State();
}

class _RentOut1State extends State<RentOut1> {

  //function for get all categories....

  List<dynamic> allCategories = [];

  Future<dynamic> getCategory() async {
    String url = AppUrl.getallCategory;

    try {
      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        print('geting all categories...');
        // Successful API call
        var responseData = jsonDecode(response.body);
        print(responseData);
        allCategories.clear();
        allCategories.addAll(responseData['data']);
        print(" All category : $allCategories");
        return jsonDecode(response.body);
      } else {
        // API call failed
        print("API request failed with status code: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      // Exception occurred during API call
      print("Error making GET request: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(onTap: (){
          Navigator.pop(context);
        },child: const Icon(Icons.arrow_circle_left_rounded,color: AppColors.color1,)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text('Rent Your Product',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16 ),),
                  ),),
                const SizedBox(height: 20,),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Select Category',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                ),
                const SizedBox(height: 20.0,),
                FutureBuilder(
                    future:getCategory(),
                    builder: (context,snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Center(child: CircularProgressIndicator(),);
                      }else if(snapshot.hasError){
                        return const Center(child: Text('Error'),);
                      }
                      return Expanded(
                        child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                crossAxisCount:(Orientation == Orientation.portrait) ? 2 : 3),
                            itemCount: allCategories.length,
                            itemBuilder: (BuildContext context,int index) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> RentOut2(itemName: allCategories[index]['name'].toString())));
                                  },
                                  child: Container(
                                    height: 90,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(width: 0.5,color: const Color.fromRGBO(167,167,167, 0.51)),
                                        boxShadow: const [
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
                                          // Image.network('${allCategories['data'][index]['icon'].toString()}'),
                                          Text(allCategories[index]['name'].toString(),style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400,color: AppColors.color1),),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                      );
                    }
                ),
              ]),
        ),
      ),
    );
  }
}