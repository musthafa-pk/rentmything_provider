import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/res/components/AppBarBackButton.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/authView/otp_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController otpField = TextEditingController();

  final FocusNode fullNameNode = FocusNode();
  final FocusNode phoneNumberNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();
  final FocusNode otpFieldNode = FocusNode();
  final FocusNode signupBtnNode = FocusNode();

  final _formKey = GlobalKey<FormState>(); // Key for the form

  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;

  File? _image;

  //signup api function
  Future<dynamic> signUpApi() async {
    if(_image == null){
      Util.flushBarErrorMessage('Please pick image', Icons.sms_failed, Colors.red, context);
      return;
    }
    String url = AppUrl.userAdd;
    var request = http.MultipartRequest('POST',Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    request.fields['name'] = fullName.text;
    request.fields['password'] = password.text;
    request.fields['email'] = email.text;
    request.fields['phone_number'] = phoneNumber.text;


    // Map<String, dynamic> postData = {
    //   "name": fullName.text,
    //   "password": password.text,
    //   "email": email.text,
    //   "phone_number": phoneNumber.text,
    // };
    try {
      // final response = await http.post(
      //   Uri.parse(url),
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: jsonEncode(postData),
      // );
      final response = await request.send();
      print(response.statusCode);
      // print(object)
      // print(jsonEncode(postData));
      if (response.statusCode == 200) {
        // var responseData = jsonDecode(response.body);
        print('API request successful');
        // print
        // (responseData);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(
                  email: email.text,
                )));
        Util.flushBarErrorMessage(
            'User Registered successfully !', Icons.verified, Colors.green, context);
        // return responseData;
      } else {
        print('erru');
        // var responseData = jsonDecode(response.body);
        // print(responseData);
        final responseBody = await response.stream.bytesToString();
        print('resp:$responseBody');
        final errorResponse = jsonDecode(responseBody);
        print('API request failed with status code: ${response.statusCode}');
        print('Error message: ${errorResponse['message']}');
        Util.flushBarErrorMessage('${errorResponse['message']}', Icons.warning, Colors.red, context);
        // Util.flushBarErrorMessage('Some error occured,${errorResponse['message']}', context);
        print('else worked...');
        print("API request failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print('eee');
      Util.flushBarErrorMessage('${e.toString()}', Icons.warning, Colors.red, context);
      print("Error making POST request: $e");
      return null;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            // Wrap your form with Form widget and assign the key
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 27, letterSpacing: 1,color: AppColors.color1),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        _buildCircleAvatar(),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap:_pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.color1,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Full Name',style: TextStyle(color:AppColors.color1),),
                      const SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(220, 228, 230, 1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 10),
                            counterText: ''
                          ),
                          controller: fullName,
                          maxLength: 35,
                          style: TextStyle(color: AppColors.color1),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                              Util.fieldFocusChange(context, fullNameNode, phoneNumberNode);
                          },
                        ),
                      ),

                      const SizedBox(height: 10,),
                      const Text('Phone Number',style: TextStyle(color:AppColors.color1)),
                      const SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(220, 228, 230, 1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: TextFormField(
                          controller: phoneNumber,
                          focusNode: phoneNumberNode,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                            style: TextStyle(color: AppColors.color1),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (!isNumeric(value)) {
                              return 'Please enter a valid phone number';
                            }
                            if(value.contains('.')){
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                              Util.fieldFocusChange(context, phoneNumberNode, emailNode);
                            }
                        ),
                      ),


                      const SizedBox(height: 10,),
                      const Text('Email',style: TextStyle(color:AppColors.color1)),
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
                          style: TextStyle(color: AppColors.color1),
                          decoration: const InputDecoration(
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
                              Util.fieldFocusChange(context, emailNode, passwordNode);
                          },
                        ),
                      ),

                      const SizedBox(height: 10,),
                      const Text('Password',style: TextStyle(color:AppColors.color1)),
                      const SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(220, 228, 230, 1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: TextFormField(
                          controller: password,
                          focusNode: passwordNode,
                          style: TextStyle(color: AppColors.color1),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(left: 10,top: 10),
                            counterText: '',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscurePassword = !_isObscurePassword;
                                });
                              },
                              icon: Icon(
                                _isObscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          obscureText: _isObscurePassword,
                          maxLength: 15,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            Util.fieldFocusChange(context, passwordNode, confirmPasswordNode);
                          },
                        ),
                      ),
                      const SizedBox(height: 10,),
                      const Text('Confirm Password',style: TextStyle(color:AppColors.color1)),
                      const SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(220, 228, 230, 1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: TextFormField(
                          controller: confirmPassword,
                          focusNode: confirmPasswordNode,
                          style: TextStyle(color: AppColors.color1),
                          maxLength: 15,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(left: 10,top: 10),
                            counterText: '',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscureConfirmPassword = !_isObscureConfirmPassword;
                                });
                              },
                              icon: Icon(
                                _isObscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          obscureText: _isObscureConfirmPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            } else if (value != password.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            Util.fieldFocusChange(context, confirmPasswordNode, signupBtnNode);
                          },
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                          color: AppColors.color1,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.color1,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Validate the form
                              signUpApi();
                            }
                          },
                          focusNode: signupBtnNode,
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account ? ',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400,color: AppColors.color1),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleAvatar() {
    if (_image != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(_image!),
      );
    } else {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Color.fromRGBO(220, 228, 230, 1),
      );
    }
  }
}

