import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors.dart';


class Button extends StatelessWidget {

  final String title;
  final bool loading;
  final VoidCallback onPress;

  const Button({
    super.key,
    required this.title,
    this.loading=false,
    required this.onPress ,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onPress ,
      child: Container(
        height: 50,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.color1,
        ),
        child: Center(
            child: loading ? const CircularProgressIndicator(color: Colors.white,) : Text(
              title, style: GoogleFonts.poppins(color: Colors
                .white, fontSize: 15),)),
      ),
    );
  }
}