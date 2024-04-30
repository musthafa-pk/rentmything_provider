import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/view/rentoutView/rentOut1.dart';
class RentOutButton extends StatelessWidget {
  const RentOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RentOut1(),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width/3,
        decoration: BoxDecoration(
          color: AppColors.color1,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              SizedBox(width: 10,),
              Text(
                'Rent Out',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),

              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Icon(
                  Icons.add,
                  color: AppColors.color1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}