import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
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

  //signup api function
  Future<dynamic> signUpApi() async {
    String url = AppUrl.userAdd;
    Map<String, dynamic> postData = {
      "name": fullName.text,
      "password": password.text,
      "email": email.text,
      "phone_number": phoneNumber.text,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postData),
      );
      print(jsonEncode(postData));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('API request successful');
        print(responseData);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(
                  email: email.text,
                )));
        Util.flushBarErrorMessage(
            'User Registered successfully !', Icons.verified, Colors.green, context);
        return responseData;
      } else {
        var responseData = jsonDecode(response.body);
        print(responseData);
        Util.snackBar('Some error occured,${responseData['error']}', context);
        print('else worked...');
        print(response);
        print("API request failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error making POST request: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_circle_left_rounded, color: AppColors.color1),
        ),
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
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 27, letterSpacing: 1),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Color.fromRGBO(220, 228, 230, 1),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: (){
                              Util.toastMessage('This feuture not available now');
                            },
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
                      const Text('Full Name'),
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
                          ),
                          controller: fullName,
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
                      const Text('Phone Number'),
                      const SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(220, 228, 230, 1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: TextFormField(
                          controller: phoneNumber,
                          focusNode: phoneNumberNode,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            Util.fieldFocusChange(context, phoneNumberNode, emailNode);
                          },
                        ),
                      ),
                      const SizedBox(height: 10,),
                      const Text('Email'),
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
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 10),
                          ),
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
                      const Text('Password'),
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(left: 10,top: 10),
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
                      const Text('Confirm Password'),
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(left: 10,top: 10),
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
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
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
}
