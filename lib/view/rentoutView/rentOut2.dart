import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';

import 'package:rentmything/res/app_url.dart';


import 'package:http/http.dart' as http;
import 'package:rentmything/res/components/AppBarBackButton.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/rentoutView/rentOutTools.dart';
import 'package:rentmything/view/rentoutView/rentOutVehicle.dart';
import 'package:rentmything/view/rentoutView/rentoutElectronics.dart';
import 'package:rentmything/view/rentoutView/rentoutFurniture.dart';
import 'package:rentmything/view/rentoutView/rentoutLandBuilding.dart';
import 'package:rentmything/view/rentoutView/rentoutOther.dart';

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
        leading: AppBarBackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(widget.itemName,style: const TextStyle(
                    color: AppColors.color1,
                      fontWeight: FontWeight.w600,fontSize: 16 ),),
                ),
                const SizedBox(height: 20,),
                FutureBuilder(
                    future: getSubcategory(),
                    builder: (context,snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Center(child: CircularProgressIndicator(),);
                      }else if(snapshot.hasError){
                        return const Center(child: Text('Some error occured'),);
                      }else
                        return Expanded(
                          child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  crossAxisCount:(Orientation == Orientation.portrait) ? 2 : 3),
                              itemCount:allSubCategories['data'].length,
                              itemBuilder: (BuildContext context,int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: InkWell(
                                    onTap: (){
                                      switch (widget.itemName) {
                                        case 'Vehicles':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => RentOutVehicle(category: widget.itemName, subcategory: '${allSubCategories['data'][index]['name']}')),
                                          );
                                          break;
                                        case 'Electronics':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => RentOutElectronics(category: widget.itemName, subcategory: '${allSubCategories['data'][index]['name']}')),
                                          );
                                          break;
                                        case 'Appliances':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => RentOutElectronics(category: widget.itemName, subcategory: '${allSubCategories['data'][index]['name']}')),
                                          );
                                          break;
                                        case 'Machineries':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => RentOutElectronics(category: widget.itemName, subcategory: '${allSubCategories['data'][index]['name']}')),
                                          );
                                          break;
                                        case 'Tools':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => RentOutTools(category: widget.itemName, subcategory: '${allSubCategories['data'][index]['name']}')),
                                          );
                                          break;
                                        case 'Furnitures':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => RentOutFurniture(category: widget.itemName, subcategory: '${allSubCategories['data'][index]['name']}')),
                                          );
                                          break;
                                        case 'Cloth':
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) => RentOutElectronics(category: widget.itemName, subcategory: '${allSubCategories['data'][index]['name']}')),
                                        // );
                                          break;
                                        case 'Land & Building':
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => RentOutLandBuilding(category: widget.itemName, subcategory: '${allSubCategories['data'][index]['name']}')),
                                        );
                                          break;
                                        default:
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>  RentOutOther(category: widget.itemName, subCategory: 'other',),)
                                          );
                                      }
                                    },
                                    child: Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(width: 0.5,color: const Color.fromRGBO(167,167,167, 0.51)),
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
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('${allSubCategories['data'][index]['name']}',
                                              overflow: TextOverflow.fade,
                                              style: const TextStyle(fontSize: 8,fontWeight: FontWeight.w400,color: AppColors.color1),)
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