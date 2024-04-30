import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/res/components/AppBarBackButton.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
import 'package:rentmything/view/splashView/successView.dart';
class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final TextEditingController email = TextEditingController();
  final TextEditingController otp = TextEditingController();

  final FocusNode emailNode = FocusNode();
  final FocusNode otpNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  Future<dynamic> makeotp() async {
    print('make otp');
    String url = AppUrl.forgotpwd;
    Map<String,dynamic> data = {
      "email":email.text
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON and return it
        return jsonDecode(response.body);
      } else {
        var responseData = jsonDecode(response.body);
        Util.flushBarErrorMessage('${responseData['message']}', Icons.sms_failed, Colors.red, context);
        // If the server returns an error response, throw an exception with the error message
        throw Exception('Failed to post data: ${response.body}');
      }
    } catch (e) {
      // Catch any errors that occur during the HTTP request and throw them
      throw Exception('Failed to post data: $e');
    }
  }

  Future<dynamic> submitotp() async {
    String url = AppUrl.loginwithotp;
    Map<String,dynamic> data = {
      "email":email.text,
      "otp":otp.text
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('respp');
        print(responseData);
        setState(() {
          Util.userId = responseData['data']['_id'];
          Util.userEmail = responseData['data']['email'];
          Util.userPhoneNumber = responseData['data']['phone_number'];
        });
        print(Util.userId);
        // If the server returns a 200 OK response, parse the JSON and return it
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNavigationPage(),), (route) => false);
        return jsonDecode(response.body);
      } else {
        var responseData = jsonDecode(response.body);
        Util.flushBarErrorMessage('${responseData['message']}', Icons.sms_failed, Colors.red, context);
        // If the server returns an error response, throw an exception with the error message
        throw Exception('Failed to post data: ${response.body}');
      }
    } catch (e) {
      // Catch any errors that occur during the HTTP request and throw them
      throw Exception('Failed to post data: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with OTP'),
        leading: AppBarBackButton(),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Email',style: TextStyle(fontFamily: 'Poppins'),),
                  const SizedBox(height: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(220, 228, 230, 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextFormField(
                      controller: email,
                      focusNode: emailNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: '',
                      ),
                      maxLength: 35,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        Util.fieldFocusChange(context, emailNode, otpNode);
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  MyButton(title: 'Generate OTP',
                      backgroundColor: AppColors.color1,
                      textColor: Colors.white,
                      clickme: (){
                    if(_formKey.currentState!.validate()){
                      makeotp();
                    }
                  }),
                  SizedBox(height: 20,),
                  Text('Enter OTP',style: TextStyle(fontFamily: 'Poppins'),),
                  Container(
                    width: MediaQuery.of(context).size.width/1.1,
                    child: OtpTextField(
                      numberOfFields: 6,
                      fillColor: Colors.black.withOpacity(0.1),
                      filled: true,
                      keyboardType: TextInputType.number,
                      focusedBorderColor: AppColors.color1,
                      onCodeChanged: (v){
                          otp.text = v;
                          print(otp);
                      },
                      onSubmit: (code){
                        print('otp is $code');
                        setState(() {
                          otp.text = code;
                        });
                      },
                    ),
                  ),
                  // TextFormField(
                  //   controller: otp,
                  //   focusNode: otpNode,
                  //   keyboardType: TextInputType.number,
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder()
                  //   ),
                  // ),
                  SizedBox(height: 20,),
                  MyButton(title: 'Submit', backgroundColor: AppColors.color1, textColor: Colors.white, clickme: submitotp),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
