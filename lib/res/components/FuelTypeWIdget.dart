import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
class FuelType extends StatefulWidget {
  final Function(String) onFuelTypeSelected;
  const FuelType({required this.onFuelTypeSelected,Key? key}) : super(key: key);

  @override
  State<FuelType> createState() => _FuelTypeState();
}

class _FuelTypeState extends State<FuelType> {
  int selectedIndex = 0; // Variable to keep track of the selected item index

  @override
  Widget  build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildSegmentedButton('Petrol', 0),
          SizedBox(width: 10),
          buildSegmentedButton('Diesel', 1),
          SizedBox(width: 10),
          buildSegmentedButton('Electric', 2),
          SizedBox(width: 10),
          buildSegmentedButton('CNG', 3),
          SizedBox(width: 10),
          buildSegmentedButton('Other', 4),
        ],
      ),
    );
  }

  Widget buildSegmentedButton(String text, int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          widget.onFuelTypeSelected(text);
        });
      },
      child: Container(
        width: 115,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.color1 : const Color.fromRGBO(7, 59, 76, 0.18),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: isSelected ? Colors.white : null),
          ),
        ),
      ),
    );
  }
}
