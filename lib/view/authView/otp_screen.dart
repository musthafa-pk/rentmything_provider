import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
class OtpScreen extends StatefulWidget {
  String? email;
  OtpScreen({required this.email,Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otp_data;
  Future<dynamic> verifywithotp() async {
    String url = AppUrl.emailVerifiication;
    Map<String,dynamic> postData = {
      "email":widget.email,
      "otp":otp_data
    };

    try {
      final response = await http.post(
          Uri.parse(url),
          body: postData
      );
      print(jsonEncode(postData));

      if (response.statusCode == 200) {
        // Successful API call
        var responseData = jsonDecode(response.body);
        print(responseData);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>BottomNavigationPage()));
        return jsonDecode(response.body);
      } else {
        // API call failed
        print("API request failed with status code: ${response.statusCode}");

      }
    } catch (e) {
      // Exception occurred during API call
      print("Error making GET request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_circle_left,color: AppColors.color1,),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ON Progress......'),
            Text('CODE',style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.color1,
              fontSize: 80.0,
            ),),
            Text('Verification',style: TextStyle(
                color: AppColors.color1,
                fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 20.0,),
            Text('Enter Verification code sent from team chaavie',textAlign:TextAlign.center,),
            SizedBox(height: 20.0,),
            OtpTextField(
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              keyboardType: TextInputType.number,
              focusedBorderColor: AppColors.color1,
              onSubmit: (code){
                print('otp is ${code}');
                setState(() {
                  otp_data = code;
                });
              },
            ),
            SizedBox(height: 20.0,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: (){
                    verifywithotp();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:AppColors.color1,
                  ),
                  child: Text('Next',style: TextStyle(color: Colors.white),)),
            )
          ],
        ),
      ),
    );
  }
}