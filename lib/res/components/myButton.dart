import 'package:flutter/material.dart';

import '../app_colors.dart';
class MyButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback clickme;
  const MyButton({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
    required this.clickme,
    super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:clickme,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: AppColors.color1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(child: Text(title,style: TextStyle(color: textColor,fontFamily: 'Poppins',fontWeight: FontWeight.w500,fontSize: 16),)),
        ),
      ),
    );
  }
}