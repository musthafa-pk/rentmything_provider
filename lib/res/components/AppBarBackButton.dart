import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: const Icon(Icons.arrow_circle_left_rounded, color: AppColors.color1,size: 35,),
    );
  }
}