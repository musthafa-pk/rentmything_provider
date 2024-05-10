import 'package:flutter/material.dart';

import '../app_colors.dart';
class RentTypeWidget extends StatelessWidget {
  int index;
  String renttype;
  RentTypeWidget({
    super.key,
    required this.listofProducts,
    required this.index,
    required this.renttype
  });

  final List listofProducts;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color:renttype == 'Monthly' ? AppColors.color7
              : renttype == 'Daily' ? AppColors.color8
              :renttype == 'Hourly' ? AppColors.color9
              :renttype == 'Yearly' ? AppColors.color10:
          null,
          borderRadius:
          BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 9,
            top: 2,
            bottom: 2,
            right: 9),
        child: Text(
          '${listofProducts[index]['time_period']}',
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 10,
              color: Color.fromRGBO(
                  255, 255, 255, 0.66),
              letterSpacing: 1.6),
        ),
      ),
    );
  }
}