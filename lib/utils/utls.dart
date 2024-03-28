import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class Util{

  // usercredentials

  static String? userId;
  static String? userEmail;
  static String? userPhoneNumber;
  static String? userName;

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
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
        messageColor: Colors.black,
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

  static void makingPhonecall(BuildContext context)async{
    bool? res = await FlutterPhoneDirectCaller.callNumber('9544688490');
    if(!res!) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
          'Couldnot make a phone call'
      )));
    }
  }
}