import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/res/components/customDropdown.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
import 'package:rentmything/view/profileView/editprofile.dart';

class MarkingasRented extends StatefulWidget {
  final String prod_id;
  final String cust_id;

  MarkingasRented({required this.prod_id, required this.cust_id, Key? key})
      : super(key: key);

  @override
  State<MarkingasRented> createState() => _MarkingasRentedState();
}

class _MarkingasRentedState extends State<MarkingasRented> {
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final TextEditingController price = TextEditingController();

  late DateTime _startDate;
  late DateTime _endDate;
  String? renttype;

  Future<void> rentingdata(String customerID) async {
    final String url = AppUrl.addrentdata; // Replace with your API endpoint

    // Convert DateTime objects to ISO 8601 strings
    String startDateISO = _startDate.toIso8601String();
    String endDateISO = _endDate.toIso8601String();

    // Example JSON data to be sent in the request body
    Map<String, dynamic> data = {
      'prod_id': widget.prod_id,
      'created_by':Util.userId,
      'start_date': startDateISO,
      'end_date': endDateISO,
      'amount': price.text,
      'rent_type': renttype,
      'customer_id':customerID
    };

    // Convert data to JSON format
    String requestBody = json.encode(data);

    try {
      // Make POST request
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );
      print('req body :$requestBody');
      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigationPage()),
        );
        Util.flushBarErrorMessage(
          '${responseData['message']} ',
          Icons.verified,
          Colors.green,
          context,
        );
        // Handle successful response
        print('Request successful: ${response.body}');
      } else {
        // Handle unsuccessful response
        Util.flushBarErrorMessage(
          response.body,
          Icons.sms_failed,
          Colors.red,
          context,
        );
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    }
  }

  Future<dynamic> fetchUserProfile() async {
    String url = AppUrl.userDetails;
    Map<String, dynamic> data = {
      "id": widget.cust_id
    };
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Failed POST request
        print('Failed to make POST request');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return null;
      }
    } catch (e) {
      // Exception occurred during the request
      print('Error occurred during POST request: $e');
      return null;
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          print('startdate: $_startDate');
        } else {
          _endDate = pickedDate;
          print('end date:$_endDate');
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_circle_left_rounded, color: AppColors.color1,),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: fetchUserProfile(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              dynamic userData = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      CircleAvatar(radius: 50,
                      backgroundColor: AppColors.color1,
                      child: Text('${userData['data']['name'].toString().substring(0,1)}',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: Colors.white),),),
                      Text('${userData['data']['name']}'),
                      Text('${userData['data']['email']}'),
                      Text('${userData['data']['phone_number']}'),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context, true),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.color2,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Start Date: ${_startDate.toLocal().toString().split(' ')[0]}',
                                    style: const TextStyle(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context, false),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.color2,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'End Date: ${_endDate.toLocal().toString().split(' ')[0]}',
                                    style: const TextStyle(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),


                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 180,
                              decoration: const BoxDecoration(
                                color: AppColors.color1,
                              ),
                              child: CustomDropdown(
                                options: const ['Daily', 'Monthly', 'Hourly'],
                                onChanged: (value) {
                                  setState(() {
                                    renttype = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(child: MyTextFieldWidget(labelName: 'Price', controller: price, validator: (vlaue){}))
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          print('pressed..');
                          rentingdata(userData['data']['_id']);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.color1,
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 110, right: 110, top: 13, bottom: 13),
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}

