import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class Util{

  // usercredentials

  static String? userId;
  static String? userEmail;
  static String? userPhoneNumber;
  static String? userName;

  static List<File> imageFiles = [];
  
  static final Future<SharedPreferences>  prefs = SharedPreferences.getInstance();

  // next field focused in textField
  static fieldFocusChange(
      BuildContext context,
      FocusNode current,
      FocusNode nextFocus,){
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }



  static double averageRating(List<int>rating){
    var avgRating = 0;
    for(int i = 0; i<rating.length; i++){
      avgRating = avgRating+ rating[i];
    }
    return double.parse((avgRating/rating.length).toStringAsFixed(1));
  }



  static toastMessage(String message){
    Fluttertoast.showToast(msg: message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );}


  static flushBarErrorMessage(String message ,IconData icon,Color iconColor, BuildContext context){
    showFlushbar(context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        positionOffset: 20,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(20),
        icon: Icon(icon,color: iconColor,),
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        messageColor: Colors.black,
        borderWidth: 1,
        borderColor: AppColors.color2,
        duration: const Duration(seconds: 3),
      )..show(context),
    );}



  static snackBar(String message , BuildContext context){
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text(message))
    );
  }

  //format date time
  static String formatDateTime(String dateTimeString) {
    // Convert the dateTimeString to a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the DateTime object as DD/MM/YYYY
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);

    return formattedDate;
  }

  static void makingPhonecall(BuildContext context,String phone_number)async{
    bool? res = await FlutterPhoneDirectCaller.callNumber(phone_number);
    if(!res!) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
          'Couldnot make a phone call'
      )));
    }
  }
//sharedprefrences clearing using for logout
  static Future<void> clearUserPrefs() async {
    final userPreference = await SharedPreferences.getInstance();
    await userPreference.remove('token');
    await userPreference.remove('userId');
    await userPreference.remove('userEmail');
    await userPreference.remove('userName');
    Util.userId = '';
    Util.userEmail = '';
    Util.userName = '';
  }

  //launch url
  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



}