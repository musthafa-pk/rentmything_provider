import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/res/components/customDropdown.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
import 'package:rentmything/view/profileView/editprofile.dart';
import 'package:http/http.dart' as http;
class MarkingasRented extends StatefulWidget {
  String prod_id;
  String cust_id;
  MarkingasRented({required this.prod_id,required this.cust_id,super.key});

  @override
  State<MarkingasRented> createState() => _MarkingasRentedState();
}

class _MarkingasRentedState extends State<MarkingasRented> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final TextEditingController price = TextEditingController();

   String? renttype ;


  Future<void>
  rentingdata() async {
    final String url = AppUrl.addrentdata; // Replace with your API endpoint

    // Example JSON data to be sent in the request body
    Map<String, dynamic> data = {
      'prod_id':widget.prod_id,
      'created_by':widget.cust_id,
      'start_date':startDate.text,
      'end_date':endDate.text,
      'amount':price.text,
      'rent_type':renttype
    };

    // Convert data to JSON format
    String requestBody = json.encode(data);

    try {
      // Make POST request
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigationPage()));
        Util.flushBarErrorMessage('${response.body} ', Icons.verified, Colors.green, context);
        // Handle successful response
        print('Request successful: ${response.body}');
      } else {
        // Handle unsuccessful response
        Util.flushBarErrorMessage('${response.body}', Icons.sms_failed,Colors.red, context);
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    print('prod id:${widget.prod_id}');
    print('cust id :${widget.cust_id}');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_circle_left_rounded,color: AppColors.color1,),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyTextFieldWidget(labelName: "Start Date", controller: startDate, validator: (value){}),
            MyTextFieldWidget(labelName: "End Date", controller: endDate, validator: (value){}),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width:180,
                      decoration: BoxDecoration(
                        color: AppColors.color1,
                      ),
                      child: CustomDropdown(options: ['Daily','Monthly','Hourly'], onChanged: (value){
                        setState(() {
                          renttype = value;
                        });
                      })),
                ),
                Expanded(child: MyTextFieldWidget(labelName: 'Price', controller: price, validator: (vlaue){}))
              ],
            ),
            InkWell(
              onTap: (){
                rentingdata();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.color1,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 110,right: 110,top: 13,bottom: 13),
                  child: Text('Confirm',style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
