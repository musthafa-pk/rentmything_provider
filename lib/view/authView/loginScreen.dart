import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/view/authView/forgotpassword.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../res/components/button.dart';
import '../../utils/routes/route_names.dart';
import '../../utils/utls.dart';
import '../../view_model/auth_view_model.dart';




class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {

  ValueNotifier<bool>obscurePassword = ValueNotifier<bool>(true);

  final userController = TextEditingController();
  final passController = TextEditingController();

  FocusNode emailFocusNode    = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    final String apiUrl = AppUrl.loginApi; // Replace this with your API endpoint

    // Example JSON data to send in the POST request
    Map<String, dynamic> postData = {
     'user_name':userController.text,
      'password':passController.text
    };

    // Convert postData to JSON string
    String jsonString = json.encode(postData);

    try {
      // Make POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonString,
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        // If successful, print response body
        print('Response: ${response.body}');
        setState(()async {
          final userPrefrences = await SharedPreferences.getInstance();
          userPrefrences.setString('userId',responseData['login_id']);
          userPrefrences.setString('userName',responseData['name']);
          userPrefrences.setString('userEmail',responseData['email']);
          // userPrefrences.setString('userPhone', responseData['phone_number']);
          Util.userId = userPrefrences.getString('userId');
          Util.userName = userPrefrences.getString('userName');
          Util.userEmail = userPrefrences.getString('userEmail');
          print(Util.userId);
          print(Util.userName);
          print(Util.userEmail);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNavigationPage(),), (route) => false);
          Util.flushBarErrorMessage('Hi , ${Util.userName} Welcome Back !', Icons.verified, Colors.green, context);
        });
      } else {
        var responseData = jsonDecode(response.body);
        Util.flushBarErrorMessage('${responseData['message']}', Icons.warning, Colors.red, context);
        // If request was not successful, print error message
        print('Failed to create post. Error: ${response.statusCode}');
      }
    } catch (e) {
      Util.flushBarErrorMessage(e.toString(), Icons.warning, Colors.red, context);
      // If an error occurs during the request, print error message
      print('Error creating post: $e');
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    userController.dispose();
    passController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    obscurePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello there!',style: TextStyle(color: AppColors.color1,fontSize: 18),),
                        Row(
                          children: [
                            Text('Welcome to',
                                style: TextStyle(fontSize: 16,color: AppColors.color1)),
                            Text(' Rent My Thing !',
                                style: TextStyle(fontSize: 16,color: Colors.red,fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  child: Lottie.asset('assets/lottie/loginanime.json'),
                ),
                // Image.asset(
                //   'assets/images/rentlogo.png'
                // ),
                Text('Login', style:TextStyle(
                  color: AppColors.color1,
                    fontSize: 25, fontWeight: FontWeight.w600)),
                const SizedBox(height: 30,),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: TextFormField(
                    controller: userController,
                    focusNode: emailFocusNode,
                    decoration: InputDecoration(
                      hintText: 'User ID',
                      suffixIcon: Icon(Icons.person),
                      hintStyle: TextStyle(fontSize: 13,color: AppColors.color1),
                      // Set maximum input length to 25 characters
                      counterText: '', // Removes the default character counter
                      counterStyle: TextStyle(fontSize: 0), // Hides the counter
                      counter: Offstage(), // Hides the counter widget
                    ),
                    style: TextStyle(fontSize: 14,color: AppColors.color1),
                    onFieldSubmitted: (value) {
                      Util.fieldFocusChange(context, emailFocusNode, passwordFocusNode);
                    },
                    maxLength: 35, // Repeat the maxLength here to enforce it programmatically
                  ),
                ),

                const SizedBox(height: 15,),
                SizedBox(
                  child: ValueListenableBuilder(
                    valueListenable: obscurePassword,
                    builder: (context, value, child) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: TextFormField(
                          controller: passController,
                          focusNode: passwordFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(fontSize: 13,color: AppColors.color1),
                            suffixIcon: InkWell(
                              onTap: () {
                                obscurePassword.value = !obscurePassword.value;
                              },
                              child: Icon(
                                obscurePassword.value ? Icons.visibility_off_outlined : Icons.visibility,
                              ),
                            ),
                            // Set maximum input length to 10 characters
                            counterText: '', // Removes the default character counter
                            counterStyle: TextStyle(fontSize: 0), // Hides the counter
                            counter: Offstage(), // Hides the counter widget
                          ),
                          style: TextStyle(fontSize: 14,color: AppColors.color1),
                          obscureText: obscurePassword.value,
                          maxLength: 15, // Repeat the maxLength here to enforce it programmatically
                        ),
                      );
                    },
                  ),
                ),


                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Forgotpassword()));
                      },
                      child: const Text('Forgot password?', style: TextStyle(
                        fontFamily: 'Poppins',color: AppColors.color1,
                        fontSize: 10,
                      ),),
                    )
                  ],
                ),
                const SizedBox(height: 30,),

                Button(
                  title: 'Login',
                  loading: isLoading,
                  onPress: (){
                    if(userController.text.isEmpty){
                      Util.flushBarErrorMessage('please enter userID',Icons.warning,Colors.red, context);
                    }else if(passController.text.isEmpty){
                      Util.flushBarErrorMessage('please enter password',Icons.warning,Colors.red, context);
                    }else if(passController.text.length<6){
                      Util.flushBarErrorMessage('please enter 6 digit password', Icons.warning,Colors.red,context);
                    }else{
                      Map data ={
                        'user_name': userController.text,
                        'password' : passController.text,
                      };
                      login();
                      // authViewModel.loginApi(data , context);
                    }
                  },
                ),

                // const SizedBox(height: 10,),
                // Center(child: Text('or', style: GoogleFonts.poppins(
                //     color: Colors.grey, fontSize: 10),)),
                // const SizedBox(height: 10,),
                // InkWell(
                //   onTap: (){
                //     Util.toastMessage('This function not available now');
                //   },
                //   child: Container(
                //     height: 50,
                //     width: MediaQuery
                //         .of(context)
                //         .size
                //         .width,
                //     decoration: BoxDecoration(
                //       boxShadow: const [
                //         BoxShadow(
                //             color: Colors.black26,
                //             blurRadius: 16.0,
                //             spreadRadius: .2
                //         ),
                //       ],
                //       borderRadius: BorderRadius.circular(20),
                //       color: Colors.white,
                //     ),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Image.network(
                //               'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png',
                //               scale: 30,),
                //             const SizedBox(width: 10,),
                //             Text('Login with Google', style: GoogleFonts.poppins(
                //                 color: Colors.black38, fontSize: 13),),
                //
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Create new account?',
                      style: TextStyle(fontSize: 10,color: AppColors.color1),),
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, RoutesName.signUp);
                      },
                      child: Text(' Register',
                        style: TextStyle(fontFamily: 'Poppins',fontSize: 10,
                          color: AppColors.color6),),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),);
  }

}