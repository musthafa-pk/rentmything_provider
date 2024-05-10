import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/res/components/AppBarBackButton.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/splashView/successView.dart';
import 'package:http/http.dart' as http;

import '../../../res/components/myButton.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:AppBarBackButton(),
        title: Text('Reset Password',style: TextStyle(
          color: AppColors.color1,fontSize: 16
        ),),
      ),
      body: Container(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Text(
                        //   'Reset Password',
                        //   style: TextStyle(
                        //     fontSize: 24.0,
                        //     fontWeight: FontWeight.bold,
                        //     color: AppColors.color1
                        //   ),
                        // ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          style: TextStyle(color: AppColors.color1),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 12,color: AppColors.color1),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.color1,
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.color1)
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_confirmPasswordVisible,
                          style: TextStyle(color: AppColors.color1),
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(fontSize: 12,color: AppColors.color1),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.color1)
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _confirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter confirm password';
                            } else if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        MyButton(
                          title: 'Reset Password',
                          backgroundColor: AppColors.color1,
                          textColor: Colors.white,
                          clickme: () {
                            if (_formKey.currentState!.validate()) {
                              _resetPassword();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _resetPassword() async {
    // Implement your password reset logic here
    // For example, you can call an API to reset the password

    // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint
    var url = Uri.parse(AppUrl.resetPassword);

    // Create a map containing the password data
    var body = {
      'email': Util.userEmail,
      'password': _passwordController.text,
      // Add any other necessary fields for your API request
    };

    // Send a POST request to the API endpoint
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Adjust content type if necessary
      },
      body: json.encode(body),
    );
    print(response.statusCode);
    print(jsonEncode(body));
    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Util.flushBarErrorMessage('Password successfuly changed !', Icons.verified, Colors.green, context);
      // Password reset successful, handle response data if needed
      print('Password reset successful');
    } else {
      var responseData = jsonDecode(response.body);
      Util.flushBarErrorMessage('${responseData['message']}', Icons.warning, Colors.red, context);
      // Password reset failed, handle error
      print('Password reset failed: ${response.body}');
      // You can display an error message to the user or handle the error in another way
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
