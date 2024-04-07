import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> options;
  final String hintText;
  final ValueChanged<String> onChanged;

  const CustomDropdown({super.key, 
    required this.options,
    this.hintText = '',
    required this.onChanged,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(border: InputBorder.none),
        value: _selectedOption,
        style: TextStyle(color: Colors.white), // Set the text color based on whether an option is selected or not
        onChanged: (value) {
          setState(() {
            _selectedOption = value;
          });
          widget.onChanged(value!);
        },
        hint: Text(
          widget.hintText,
          style: const TextStyle(color: Colors.white), // Set the hint text color to black
        ),
        items: widget.options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option,
              style: const TextStyle(color: Colors.black), // Set the dropdown menu item text color to black
            ),
          );
        }).toList(),
      ),
    );
  }
}
