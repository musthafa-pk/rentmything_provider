import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/res/components/customDropdown.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/rentoutView/rentOutVehicle.dart';
import 'package:rentmything/view/splashView/successView.dart';

class RentOutOther extends StatefulWidget {
  String category;
  String? subCategory;
  RentOutOther({required this.category,required this.subCategory,super.key});

  @override
  State<RentOutOther> createState() => _RentOutOtherState();
}

class _RentOutOtherState extends State<RentOutOther> {

  String? image;
  final TextEditingController brand = TextEditingController();
  final TextEditingController year = TextEditingController();
  String? selectedFuelType;
  final TextEditingController km_driven = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  String? timePeriod;
  final TextEditingController price = TextEditingController();
  final TextEditingController location = TextEditingController();

  final FocusNode brandNode = FocusNode();
  final FocusNode yearNode = FocusNode();
  final FocusNode km_drivernNode = FocusNode();
  final FocusNode titleNode = FocusNode();
  final FocusNode descriptionNode = FocusNode();
  final FocusNode priceNode = FocusNode();
  final FocusNode locaitonNode = FocusNode();

  Future<void> addProduct() async {

    // Prepare the data to be sent in the request body
    Map<String, dynamic> data = {
      "name": title.text,
      "category": widget.category,
      "subcategory": widget.subCategory,
      "contact_number": Util.userPhoneNumber,
      "brand": brand.text.toUpperCase(),
      "year": year.text,
      "subtype1": "one",
      "subtype2": km_driven.text,
      "subtype3": selectedFuelType,
      "description": description.text,
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SuccessView()));
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


  final GlobalKey<FormState> _otherFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_circle_left_rounded,color: AppColors.color1,)),
          title: const Text('Details',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
        ),
        body: Center(child: Text('heloo'),),
        // body: SafeArea(
        //   child: SingleChildScrollView(
        //     child: Padding(
        //       padding: const EdgeInsets.all(15.0),
        //       child: Form(
        //         key:_otherFormKey ,
        //         child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             mainAxisAlignment: MainAxisAlignment.spaceAround,
        //             children: [
        //               const SizedBox(height: 10,),
        //               const Padding(
        //                 padding: EdgeInsets.all(8.0),
        //                 child: Text('Add Photo',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
        //               ),
        //               SingleChildScrollView(
        //                 scrollDirection: Axis.horizontal,
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                   children: [
        //                     Padding(
        //                       padding: const EdgeInsets.all(10.0),
        //                       child: Container(
        //                         height: 100,
        //                         width: 100,
        //                         decoration: BoxDecoration(
        //                             borderRadius: BorderRadius.circular(14),
        //                             image: const DecorationImage(image: AssetImage('assets/images/redcar.jpg'),fit: BoxFit.cover)
        //                         ),
        //                       ),
        //                     ),
        //                     Container(
        //                       height: 100,
        //                       width: 100,
        //                       decoration: BoxDecoration(
        //                           borderRadius: BorderRadius.circular(14),
        //                           color: const Color.fromRGBO(7,59, 76, 0.18)
        //                       ),
        //                       child: const Center(child: Icon(Icons.add,color: Color.fromRGBO(88, 88, 88, 1),)),
        //                     ),
        //                   ],
        //                 ),),
        //               const Text('Brand',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
        //               SizedBox(height: 10,),
        //               Container(
        //                 width: MediaQuery.of(context).size.width/1.1,
        //                 decoration: BoxDecoration(
        //                     color: const Color.fromRGBO(7, 59,76,0.18),
        //                     borderRadius: BorderRadius.circular(5)
        //                 ),
        //
        //                 child: TextFormField(
        //                   controller: brand,
        //                   focusNode: brandNode,
        //                   onFieldSubmitted: (v){
        //                     Util.fieldFocusChange(context, brandNode, yearNode);
        //                   },
        //                   decoration: const InputDecoration(
        //                     contentPadding: EdgeInsets.only(left: 10),
        //                     border: InputBorder.none,
        //                   ),
        //                   validator: (value) {
        //                     if (value == null || value.isEmpty) {
        //                       return 'Please enter the brand';
        //                     }
        //                     return null;
        //                   },
        //                 ),
        //               ),
        //
        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: const Text('Year',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
        //               ),
        //               Container(
        //                 width: MediaQuery.of(context).size.width/1.1,
        //                 decoration: BoxDecoration(
        //                     color: const Color.fromRGBO(7, 59,76,0.18),
        //                     borderRadius: BorderRadius.circular(5)
        //                 ),
        //                 child: TextFormField(
        //                   controller: year,
        //                   focusNode: yearNode,
        //                   validator: (v){
        //                     Util.fieldFocusChange(context, yearNode,km_drivernNode);
        //                   },
        //                   onFieldSubmitted: (v){
        //                     Util.fieldFocusChange(context, yearNode, km_drivernNode);
        //                   },
        //                   decoration: const InputDecoration(
        //                       border: InputBorder.none,
        //                       contentPadding: EdgeInsets.only(left: 10)
        //                   ),
        //                 ),
        //               ),
        //
        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: const Text('Fuel Type'),
        //               ),
        //               FuelType(onFuelTypeSelected: (fuelType){
        //                 setState(() {
        //                   selectedFuelType = fuelType;
        //                 });
        //               },),
        //               // SingleChildScrollView(
        //               //   scrollDirection: Axis.horizontal,
        //               //   child: Row(
        //               //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               //     children: [
        //               //       Container(
        //               //         width: 115,
        //               //         height: 40,
        //               //         decoration: BoxDecoration(
        //               //             color: const Color.fromRGBO(7, 59, 76, 0.18),
        //               //             borderRadius: BorderRadius.circular(6)
        //               //         ),
        //               //         child: const Center(child: Text('Petrol')),
        //               //       ),
        //               //       const SizedBox(width: 10,),
        //               //
        //               //       Container(
        //               //         width: 115,
        //               //         height: 40,
        //               //         decoration: BoxDecoration(
        //               //             color: const Color.fromRGBO(7, 59, 76, 0.18),
        //               //             borderRadius: BorderRadius.circular(6)
        //               //         ),
        //               //         child: const Center(child: Text('Diesel')),
        //               //       ),
        //               //
        //               //       const SizedBox(width: 10,),
        //               //
        //               //       Container(
        //               //         width: 115,
        //               //         height: 40,
        //               //         decoration: BoxDecoration(
        //               //             color: AppColors.color1,
        //               //             borderRadius: BorderRadius.circular(6)
        //               //         ),
        //               //         child: const Center(child: Text('Electric',style: TextStyle(color: Colors.white),)),
        //               //       ),
        //               //
        //               //       const SizedBox(width: 10,),
        //               //
        //               //       Container(
        //               //         width: 115,
        //               //         height: 40,
        //               //         decoration: BoxDecoration(
        //               //             color: const Color.fromRGBO(7, 59, 76, 0.18),
        //               //             borderRadius: BorderRadius.circular(6)
        //               //         ),
        //               //         child: const Center(child: Text('CNG')),
        //               //       ),
        //               //
        //               //       const SizedBox(width: 10,),
        //               //
        //               //       Container(
        //               //         width: 115,
        //               //         height: 40,
        //               //         decoration: BoxDecoration(
        //               //             color: const Color.fromRGBO(7, 59, 76, 0.18),
        //               //             borderRadius: BorderRadius.circular(6)
        //               //         ),
        //               //         child: const Center(child: Text('Water')),
        //               //       ),
        //               //     ],
        //               //   ),
        //               // ),
        //
        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: const Text('Km Driven',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
        //               ),
        //               Container(
        //                 width: MediaQuery.of(context).size.width/1.1,
        //                 decoration: BoxDecoration(
        //                     color: const Color.fromRGBO(7, 59,76,0.18),
        //                     borderRadius: BorderRadius.circular(5)
        //                 ),
        //                 child: TextFormField(
        //                   controller: km_driven,
        //                   focusNode: km_drivernNode,
        //                   validator: (v){
        //                     if(v == null || v.isEmpty){
        //                       return 'Please enter the kelometer driven';
        //                     }
        //                   },
        //                   onFieldSubmitted: (v){
        //                     Util.fieldFocusChange(context, km_drivernNode, titleNode);
        //                   },
        //                   decoration: const InputDecoration(
        //                       border: InputBorder.none,
        //                       contentPadding: EdgeInsets.only(left: 10)
        //                   ),
        //                 ),
        //               ),
        //
        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: const Text('Ad Title',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
        //               ),
        //               Container(
        //                 width: MediaQuery.of(context).size.width/1.1,
        //                 decoration: BoxDecoration(
        //                     color: const Color.fromRGBO(7, 59,76,0.18),
        //                     borderRadius: BorderRadius.circular(5)
        //                 ),
        //                 child: TextFormField(
        //                   controller: title,
        //                   focusNode: titleNode,
        //                   validator: (v){},
        //                   onFieldSubmitted: (v){
        //                     Util.fieldFocusChange(context, titleNode, descriptionNode);
        //                   },
        //                   decoration: const InputDecoration(
        //                       border: InputBorder.none,
        //                       contentPadding: EdgeInsets.only(left: 10)
        //                   ),
        //                 ),
        //               ),
        //
        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: const Text('Description',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
        //               ),
        //               Container(
        //                 height: 90,
        //                 width: MediaQuery.of(context).size.width/1.1,
        //                 decoration: BoxDecoration(
        //                     color: const Color.fromRGBO(7, 59,76, 0.18),
        //                     borderRadius: BorderRadius.circular(5)
        //                 ),
        //                 child: TextFormField(
        //                   controller: description,
        //                   focusNode: descriptionNode,
        //                   maxLength: 399,
        //                   maxLines: 4,
        //                   onFieldSubmitted: (v){
        //                     Util.fieldFocusChange(context, descriptionNode, priceNode);
        //                   },
        //                   decoration    : const InputDecoration(
        //                     border: InputBorder.none,
        //                     contentPadding: EdgeInsets.only(left: 10),
        //                   ),
        //                 ),
        //               ),
        //
        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: const Text('Time Period & Price'),
        //               ),
        //               SizedBox(
        //                 width: MediaQuery.of(context).size.width/1.1,
        //                 child: Row(
        //                   children: [
        //                     SizedBox(width: 125,
        //                       child: Container(
        //                           width: MediaQuery.of(context).size.width/1.1,
        //                           decoration: BoxDecoration(
        //                               color: AppColors.color1,
        //                               borderRadius: BorderRadius.circular(6)
        //                           ),
        //                           child: CustomDropdown(options: const ['Daily','Monthly','Hourly'],
        //                             onChanged: (value) {
        //                               setState(() {
        //                                 timePeriod = value.toString();
        //                               });
        //                             },)
        //                       ),),
        //                     const SizedBox(width: 20,),
        //                     Expanded(
        //                       child: Column(
        //                         children: [
        //                           Container(
        //                             decoration: const BoxDecoration(
        //                                 color: Color.fromRGBO(7, 59, 76, 0.18)
        //                             ),
        //                             child: TextFormField(
        //                               controller: price,
        //                               focusNode: priceNode,
        //                               keyboardType: TextInputType.number,
        //                               validator: (value) {
        //                                 if (value == null || value.isEmpty) {
        //                                   return 'Please enter the price';
        //                                 }
        //                                 return null;
        //                               },
        //                               onFieldSubmitted: (v){
        //                                 Util.fieldFocusChange(context, priceNode, locaitonNode);
        //                               },
        //                               decoration: const InputDecoration(
        //                                   border: InputBorder.none,
        //                                   contentPadding: EdgeInsets.only(left: 10)
        //                               ),
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     )
        //                   ],
        //                 ),
        //               ),
        //
        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: const Text('Location',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
        //               ),
        //               Container(
        //                 width: MediaQuery.of(context).size.width/1.1,
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(5),
        //                   color: const Color.fromRGBO(7, 59, 76, 0.18),
        //                 ),
        //                 child: TextFormField(
        //                   controller: location,
        //                   focusNode: locaitonNode,
        //                   onFieldSubmitted: (v){},
        //                   validator: (v){
        //                     validator: (value) {
        //                       if (value == null || value.isEmpty) {
        //                         return 'Please enter the location';
        //                       }
        //                       return null;
        //                     };
        //                   },
        //                   decoration: const InputDecoration(
        //                     border: InputBorder.none,
        //                     contentPadding: EdgeInsets.only(left: 10),
        //                   ),
        //                 ),
        //               ),
        //
        //               const SizedBox(height: 10,),
        //
        //               SizedBox(
        //                   width: MediaQuery.of(context).size.width/1.1,
        //                   child: MyButton(
        //                       title: 'Post Now',
        //                       backgroundColor: AppColors.color1,
        //                       textColor: Colors.white,
        //                       clickme: (){
        //                         if(_otherFormKey.currentState!.validate()){
        //                           addProduct();
        //                         }else{
        //                           return Util.flushBarErrorMessage('Please check all fields', Icons.sms_failed, Colors.red, context);
        //                         }
        //                       })),
        //
        //               const SizedBox(height: 10.0,),
        //
        //
        //             ]),
        //       ),
        //     ),
        //   ),
        // ),
    );
  }
}
