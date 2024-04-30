import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class DistrictSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromRGBO(7, 59, 76, 0.18),
      ),
      child: TypeAheadField<String>(
        suggestionsCallback: (search) => getSuggestions(search),
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        // textFieldConfiguration: TextFieldConfiguration(
        //   controller: locationController,
        //   decoration: InputDecoration(
        //     border: InputBorder.none,
        //     hintText: 'District, place',
        //     contentPadding: EdgeInsets.only(left: 10),
        //   ),
        // ),
        onSelected: (String value) {
        locationController.text = value;
      },
      ),
    );
  }

  List<String> keralaDistricts = [
    'Alappuzha',
    'Ernakulam',
    'Idukki',
    'Kannur',
    'Kasaragod',
    'Kollam',
    'Kottayam',
    'Kozhikode',
    'Malappuram',
    'Palakkad',
    'Pathanamthitta',
    'Thiruvananthapuram',
    'Thrissur',
    'Wayanad'
  ];

  List<String> getSuggestions(String query) {
    return keralaDistricts.where((district) => district.toLowerCase().contains(query.toLowerCase())).toList();
  }

  final TextEditingController locationController = TextEditingController();
}
