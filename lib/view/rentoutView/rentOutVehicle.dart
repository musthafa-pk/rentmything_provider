import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';

import 'package:rentmything/res/app_url.dart';


import 'package:http/http.dart' as http;
import 'package:rentmything/res/components/customDropdown.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
import 'package:rentmything/view/splashView/successView.dart';

class RentOutVehicle extends StatefulWidget {
  String category;
  String subcategory;
  RentOutVehicle({required this.category,required this.subcategory,super.key});

  @override
  State<RentOutVehicle> createState() => _RentOutVehicleState();
}

class _RentOutVehicleState extends State<RentOutVehicle> {
  String? image;
  final TextEditingController brand = TextEditingController();
  final TextEditingController year = TextEditingController();
  String fuel = 'Diesel';
  final TextEditingController km_driven = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController discription = TextEditingController();
  String? timePeriod;
  final TextEditingController price = TextEditingController();
  final TextEditingController location = TextEditingController();



  // product adding api calling function
  Future<void> addProduct() async {

    // Prepare the data to be sent in the request body
    Map<String, dynamic> data = {
      "name": title.text,
      "category": widget.category,
      "subcategory": widget.subcategory,
      "contact_number": Util.userPhoneNumber,
      "brand": brand.text,
      "year": year.text,
      "subtype1": "one",
      "subtype2": "two",
      "subtype3": "three",
      "description": discription.text,
      "time_period": timePeriod,
      "location": location.text,
      "rent_status": false,
      "price": price.text,
      "availability": "Sun-Mon",
      "created_by":Util.userId
    };

    // Encode the data into JSON format
    String jsonEncodedData = json.encode(data);

    try {
      // Make the POST request
      http.Response response = await http.post(
        Uri.parse(AppUrl.addProduct),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncodedData,
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        print('product added successfully');
        Util.flushBarErrorMessage('Product added successfully', Icons.verified, Colors.green, context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SuccessView()));
        // Parse the response JSON
        Map<String, dynamic> responseData = json.decode(response.body);

        // Do something with the response data
        print('Response: $responseData');
      } else {
        // If the request was not successful, print the error status code and message
        print('Error: ${response.statusCode}');
        print('Error Message: ${response.body}');
      }
    } catch (e) {
      // Catch any errors that occur during the request
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_circle_left_rounded,color: AppColors.color1,)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 20,),
                Text('Details',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Add Photo',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                ),
                SizedBox(height: 10,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              image: DecorationImage(image: AssetImage('assets/images/redcar.jpg'),fit: BoxFit.cover)
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Color.fromRGBO(7,59, 76, 0.18)
                        ),
                        child: Center(child: Icon(Icons.add,color: Color.fromRGBO(88, 88, 88, 1),)),
                      ),
                    ],
                  ),),
                Text('Brand',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                Container(
                  width: MediaQuery.of(context).size.width/1.1,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(7, 59,76,0.18),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: TextFormField(
                    controller: brand,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),

                Text('Year',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                Container(
                  width: MediaQuery.of(context).size.width/1.1,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(7, 59,76,0.18),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: TextFormField(
                    controller: year,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),

                Text('Fuel'),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 115,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(7, 59, 76, 0.18),
                            borderRadius: BorderRadius.circular(6)
                        ),
                        child: Center(child: Text('Petrol')),
                      ),
                      SizedBox(width: 10,),

                      Container(
                        width: 115,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(7, 59, 76, 0.18),
                            borderRadius: BorderRadius.circular(6)
                        ),
                        child: Center(child: Text('Diesel')),
                      ),

                      SizedBox(width: 10,),

                      Container(
                        width: 115,
                        height: 40,
                        decoration: BoxDecoration(
                            color: AppColors.color1,
                            borderRadius: BorderRadius.circular(6)
                        ),
                        child: Center(child: Text('Electric',style: TextStyle(color: Colors.white),)),
                      ),

                      SizedBox(width: 10,),

                      Container(
                        width: 115,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(7, 59, 76, 0.18),
                            borderRadius: BorderRadius.circular(6)
                        ),
                        child: Center(child: Text('CNG')),
                      ),

                      SizedBox(width: 10,),

                      Container(
                        width: 115,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(7, 59, 76, 0.18),
                            borderRadius: BorderRadius.circular(6)
                        ),
                        child: Center(child: Text('Water')),
                      ),
                    ],
                  ),
                ),

                Text('Km Driven',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                Container(
                  width: MediaQuery.of(context).size.width/1.1,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(7, 59,76,0.18),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: TextFormField(
                    controller: km_driven,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),

                Text('Ad Title',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                Container(
                  width: MediaQuery.of(context).size.width/1.1,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(7, 59,76,0.18),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: TextFormField(
                    controller: title,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),

                Text('Description',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width/1.1,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(7, 59,76, 0.18),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: TextFormField(
                    controller: discription,
                    maxLength: 399,
                    maxLines: 4,
                    decoration    : InputDecoration(
                        border: InputBorder.none
                    ),
                  ),
                ),

                Text('Time Period & Price'),
                SizedBox(
                  width: MediaQuery.of(context).size.width/1.1,
                  child: Row(
                    children: [
                      SizedBox(width: 125,
                        child: Container(
                            width: MediaQuery.of(context).size.width/1.1,
                            decoration: BoxDecoration(
                                color: AppColors.color1,
                                borderRadius: BorderRadius.circular(6)
                            ),
                            child: CustomDropdown(options: ['Daily','Monthly','Hourly'],
                              onChanged: (value) {
                                setState(() {
                                  timePeriod = value.toString();
                                });
                              },)
                        ),),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(7, 59, 76, 0.18)
                          ),
                          child: TextFormField(
                            controller: price,
                            decoration: InputDecoration(
                                border: InputBorder.none
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Text('Location',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                Container(
                  width: MediaQuery.of(context).size.width/1.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromRGBO(7, 59, 76, 0.18),
                  ),
                  child: TextField(
                    controller: location,
                    decoration: InputDecoration(
                        border: InputBorder.none
                    ),
                  ),
                ),

                SizedBox(height: 10,),

                SizedBox(
                    width: MediaQuery.of(context).size.width/1.1,
                    child: MyButton(title: 'Post Now', backgroundColor: AppColors.color1, textColor: Colors.white, clickme: (){
                      addProduct();
                    })),

                SizedBox(height: 10.0,),


              ]),
        ),
      ),
    );
  }
}