// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:rentmything/res/app_colors.dart';
//
// import 'package:rentmything/res/app_url.dart';
//
// import 'package:http/http.dart' as http;
// import 'package:rentmything/utils/utls.dart';
// import 'package:rentmything/view/authView/loginScreen.dart';
// import 'package:rentmything/view/authView/otp_screen.dart';
//
//
// class SignUp extends StatefulWidget {
//   const SignUp({super.key});
//
//   @override
//   State<SignUp> createState() => _SignUpState();
// }
//
// class _SignUpState extends State<SignUp> {
//
//   final TextEditingController fullName = TextEditingController();
//   final TextEditingController phoneNumber = TextEditingController();
//   final TextEditingController email = TextEditingController();
//   final TextEditingController password =  TextEditingController();
//   final TextEditingController confirmPassword = TextEditingController();
//   final TextEditingController otpField = TextEditingController();
//
//   final FocusNode fullNameNode = FocusNode();
//   final FocusNode phoneNumberNode = FocusNode();
//   final FocusNode emailNode = FocusNode();
//   final FocusNode PasswordNode = FocusNode();
//   final FocusNode confirmPasswordNode = FocusNode();
//   final FocusNode otpFieldNode = FocusNode();
//   final FocusNode signupBtnNode = FocusNode();
//
//   //singup api function
//   Future<dynamic> signUpApi() async {
//     String url = AppUrl.userAdd ;
//     Map<String, dynamic> postData ={
//       "name": fullName.text,
//       "password": password.text,
//       "email": email.text,
//       "phone_number":phoneNumber.text,
//     };
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(postData),
//       );
//       print(jsonEncode(postData));
//       if (response.statusCode == 200) {
//         var responseData = jsonDecode(response.body);
//         print('API request successful');
//         print(responseData);
//         Navigator.push(context,MaterialPageRoute(builder: (context)=>OtpScreen(email: email.text,)));
//         Util.flushBarErrorMessage('User Registered successfully !',Icons.verified,Colors.green, context);
//         return responseData;
//       } else {
//         var responseData = jsonDecode(response.body);
//         print(responseData);
//         Util.snackBar('Some error occured,${responseData['message']}',context,);
//         print('else worked...');
//         print(response);
//         print("API request failed with status code: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("Error making POST request: $e");
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: InkWell(onTap: (){
//           Navigator.pop(context);
//         },child: Icon(Icons.arrow_circle_left_rounded,color: AppColors.color1,)),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding: const EdgeInsets.only(left:15.0),
//                 child: Text('Sign Up',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 27,letterSpacing: 1),),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Stack(
//                     children: [
//                       CircleAvatar(radius: 50,backgroundColor: Color.fromRGBO(220, 228, 230, 1),),
//                       Positioned(
//                         right: 0,
//                         bottom: 0,
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: AppColors.color1,
//                               borderRadius: BorderRadius.circular(50)
//                           ),
//                           child: const Padding(
//                             padding:  EdgeInsets.all(8.0),
//                             child: Icon(Icons.add,color: Colors.white,),
//                           ),
//                         ),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Full Name'),
//                     SizedBox(height: 10,),
//                     Container(
//                       // width: MediaQuery.of(context).size.width/1.1,
//                       decoration: BoxDecoration(
//                           color: Color.fromRGBO(220, 228, 230, 1),
//                           borderRadius: BorderRadius.circular(6)
//                       ),
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.only(left: 10),
//                         ),
//                         controller: fullName,
//                         onFieldSubmitted: (value){
//
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 10,),
//
//                     Text('Phone Number'),
//                     SizedBox(height: 10,),
//                     Container(
//                       // width: MediaQuery.of(context).size.width/1.1,
//                       decoration: BoxDecoration(
//                           color: Color.fromRGBO(220, 228, 230, 1),
//                           borderRadius: BorderRadius.circular(6)
//                       ),
//                       child: TextFormField(
//                         controller: phoneNumber,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.only(left: 10),
//                         ),
//                         onFieldSubmitted: (value){},
//                       ),
//                     ),
//                     SizedBox(height: 10,),
//
//                     Text('Email'),
//                     SizedBox(height: 10,),
//                     Container(
//                       width: MediaQuery.of(context).size.width/1.1,
//                       decoration: BoxDecoration(
//                           color: Color.fromRGBO(220, 228, 230, 1),
//                           borderRadius: BorderRadius.circular(6)
//                       ),
//                       child: TextFormField(
//                         controller: email,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.only(left: 10),
//                         ),
//                         onFieldSubmitted: (value){},
//                       ),
//                     ),
//                     SizedBox(height: 10,),
//
//                     Text('Password'),
//                     SizedBox(height: 10,),
//                     Container(
//                       width: MediaQuery.of(context).size.width/1.1,
//                       decoration: BoxDecoration(
//                           color: Color.fromRGBO(220, 228, 230, 1),
//                           borderRadius: BorderRadius.circular(6)
//                       ),
//                       child: TextFormField(
//                         controller: password,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.only(left: 10),
//                         ),
//                         onFieldSubmitted: (value){},
//                       ),
//                     ),
//
//                     SizedBox(height: 10,),
//
//                     Text('Confirm Password'),
//                     SizedBox(height: 10,),
//                     Container(
//                       width: MediaQuery.of(context).size.width/1.1,
//                       decoration: BoxDecoration(
//                           color: Color.fromRGBO(220, 228, 230, 1),
//                           borderRadius: BorderRadius.circular(6)
//                       ),
//                       child: TextFormField(
//                         controller: confirmPassword,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.only(left: 10),
//                         ),
//                         onFieldSubmitted: (value){
//
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 10,),
//
//                     Container(
//                         width: MediaQuery.of(context).size.width/1.1,
//                         decoration: BoxDecoration(
//                             color: AppColors.color1,
//                             borderRadius: BorderRadius.circular(9)
//                         ),
//                         child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(backgroundColor: AppColors.color1),
//                             onPressed: (){
//                               signUpApi();
//                             },
//                             focusNode: signupBtnNode,
//                             child: Padding(padding: EdgeInsets.all(15),
//                               child: Text('Sign Up',style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16,
//                               ),),))),
//                     SizedBox(height: 10,),
//
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text('Already have an account ? ',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400)),
//                         InkWell(onTap: (){
//                           Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
//                         },child: Text('Sign In',style: TextStyle(color: Colors.red,fontSize: 10,fontWeight: FontWeight.w400),))
//                       ],
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }