import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/profileView/profileView.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final email = TextEditingController();


  bool isEditing = false;

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  Future<void> fetchUserData() async {
    final url = Uri.parse(AppUrl.userDetails);
    final requestBody = {
      "id": Util.userId
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print('drivergot');
        print('driver data');
        final dynamic responseData = jsonDecode(response.body);
        print(responseData['data']);
        setState(() {
          name.text = responseData['data']['name'];
          email.text = responseData['data']['email'];
          phoneNumber.text = responseData['data']['phone_number'];
        });
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
        // Handle error - Update UI to indicate an error
      }
    } catch (error) {
      print('Error during HTTP request: $error');
      // Handle error - Update UI to indicate an error
    }
  }

  Future<void> saveuserData() async {
    final url = Uri.parse(AppUrl.userEdit);
    final requestBody = {
      "id": Util.userId,
      "name": name.text,
      "password": "111111",
      "email":email.text,
      "phone_number": phoneNumber.text
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );
      print(jsonEncode(requestBody));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('its changed user data');
        // fetchUserData();
        dynamic responseData = jsonDecode(response.body);
        Util.flushBarErrorMessage('${responseData['message']}', Icons.verified, Colors.green, context);
        print(responseData['data']);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>ProfileView()), (route) => false);
        // setState(() {
        //   name.text = responseData['data']['name'];
        //   email.text = responseData['data']['email'];
        //   phoneNumber.text = responseData['data']['phone_number'];
        // });
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
        // Handle error - Update UI to indicate an error
      }
    } catch (error) {
      print('Error during HTTP request: $error');
      // Handle error - Update UI to indicate an error
    }
  }



  // void handleListResponse(List<dynamic> responseData) {
  //   if (responseData.isNotEmpty) {
  //     setState(() {
  //       userData = responseData[0];
  //       updateUI();
  //     });
  //   } else {
  //     // Handle empty list scenario
  //   }
  // }

  // void handleMapResponse(Map<String, dynamic> responseData) {
  //   setState(() {
  //     userData = responseData['data'][0];
  //     updateUI();
  //   });
  // }

  // void updateUI() {
  //   name.text = userData?['name'] ?? '';
  //   phoneNumber.text = userData?['phone_no'] ?? '';
  //   email.text = userData?['email'] ?? '';
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      )),
                  Text(
                    'Profile',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                      ),
                     isEditing == true ? Positioned(
                        bottom: 0,
                          right: 0,
                          child: Icon(Icons.edit)):Text(''),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                child: MyTextFieldWidget(
                  labelName: 'User Name',
                  controller: name,
                  enabled: isEditing,
                  validator: () {},
                ),
              ),
              SizedBox(
                child: MyTextFieldWidget(
                  labelName: 'Phone Number',
                  controller: phoneNumber,
                  enabled: isEditing,
                  validator: () {},
                ),
              ),
              MyTextFieldWidget(
                labelName: 'Email',
                controller: email,
                enabled: isEditing,
                validator: () {},
              ),
              

              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    SizedBox(
                      height: 52,
                      // width: MediaQuery.of(context).size.width/1.1,
                      child: MyButtonWidget(
                        buttonName: isEditing ? "Save" : "Edit",
                        bgColor: AppColors.color1,
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                            if (!isEditing) {
                              saveuserData();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class MyButtonWidget extends StatelessWidget {
  String buttonName;
  Color bgColor ;
  Function? onPressed;

  MyButtonWidget({required this.buttonName,required this.bgColor,required this.onPressed,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 296,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: bgColor
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: bgColor),
        onPressed: onPressed as void Function()?,
        child: Text(buttonName,style: TextStyle(color: Colors.white),),
      ),
    );
  }
}

class MyTextFieldWidget extends StatelessWidget{
  String labelName;
  TextEditingController controller;
  Function? validator;
  bool? enabled;
  bool isObsecure;
  MyTextFieldWidget({required this.labelName,required this.controller,required this.validator,this.enabled,this.isObsecure = false,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(labelName),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 323.0,
                height: 40.0,
                child: TextFormField(
                  controller: controller,
                  enabled: enabled,
                  obscureText: isObsecure,
                  validator:  (value) {

                  },

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.color2,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  ),
                ),
              )

          ),
        ],
      ),
    );
  }
}