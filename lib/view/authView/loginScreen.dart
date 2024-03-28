import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rentmything/res/app_colors.dart';

import '../../res/components/button.dart';
import '../../utils/routes/route_names.dart';
import '../../utils/utls.dart';
import '../../view_model/auth_view_model.dart';




class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {

  ValueNotifier<bool>obscurePassword = ValueNotifier<bool>(true);

  final userController = TextEditingController();
  final passController = TextEditingController();

  FocusNode emailFocusNode    = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

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

    final authViewModel = Provider.of<AuthViewModel>(context);

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
                        Text('Hello there!',
                            style: GoogleFonts.poppins(fontSize: 20)),
                        Text('Welcome',
                            style: GoogleFonts.poppins(fontSize: 13)),
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
                Text('Login', style: GoogleFonts.poppins(
                    fontSize: 25, fontWeight: FontWeight.w600)),
                const SizedBox(height: 30,),
                Row(
                  children: [
                    const Icon(Icons.alternate_email, color: Colors.grey,),
                    const SizedBox(width: 15,),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: userController,
                        focusNode: emailFocusNode ,
                        decoration: InputDecoration(
                          hintText: 'User ID',
                          hintStyle: GoogleFonts.poppins(fontSize: 13),
                        ),
                        style: GoogleFonts.poppins(fontSize: 14),
                        onSubmitted:(value){
                          Util.fieldFocusChange(context, emailFocusNode, passwordFocusNode);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                SizedBox(
                  child: ValueListenableBuilder(
                      valueListenable: obscurePassword,
                      builder: (context,value,child){
                        return  Row(
                          children: [
                            const Icon(Icons.lock, color: Colors.grey,),
                            const SizedBox(width: 15,),
                            SizedBox(
                              width: 300,
                              child: TextField(
                                controller: passController,
                                focusNode: passwordFocusNode,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: GoogleFonts.poppins(fontSize: 13),
                                  suffixIcon:InkWell(
                                      onTap:(){
                                        obscurePassword.value = !obscurePassword.value;
                                      },child:Icon(
                                    obscurePassword.value ? Icons.visibility_off_outlined:
                                    Icons.visibility,
                                  )),
                                ),
                                style: GoogleFonts.poppins(fontSize: 14),
                                obscureText: obscurePassword.value,
                              ),
                            ),
                          ],
                        );
                      }),
                ),

                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: (){

                      },
                      child: Text('Forgot password?', style: TextStyle(
                        fontFamily: 'Poppins',color: AppColors.color1,
                        fontSize: 10,
                      ),),
                    )
                  ],
                ),
                const SizedBox(height: 30,),

                Button(
                  title: 'Login',
                  loading: authViewModel.loading,
                  onPress: (){
                    if(userController.text.isEmpty){
                      Util.flushBarErrorMessage('please enter email',Icons.sms_failed,Colors.red, context);
                    }else if(passController.text.isEmpty){
                      Util.flushBarErrorMessage('please enter password',Icons.sms_failed,Colors.red, context);
                    }else if(passController.text.length<6){
                      Util.flushBarErrorMessage('please enter 6 digit password', Icons.sms_failed,Colors.red,context);
                    }else{
                      Map data ={
                        'user_name': userController.text,
                        'password' : passController.text,
                      };
                      authViewModel.loginApi(data , context);
                    }
                  },
                ),

                const SizedBox(height: 10,),
                Center(child: Text('or', style: GoogleFonts.poppins(
                    color: Colors.grey, fontSize: 10),)),
                const SizedBox(height: 10,),
                Container(
                  height: 50,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 16.0,
                          spreadRadius: .2
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png',
                            scale: 30,),
                          const SizedBox(width: 10,),
                          Text('Login with Google', style: GoogleFonts.poppins(
                              color: Colors.black38, fontSize: 13),),

                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('create new account?',
                      style: GoogleFonts.poppins(fontSize: 10),),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RoutesName.signUp);
                        },
                        child: Text('Register', style: TextStyle(fontFamily: 'Poppins',fontSize: 10,
                        color: AppColors.color1)))
                  ],
                )
              ],
            ),
          ),
        ),
      ),);
  }

}