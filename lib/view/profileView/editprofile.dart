import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/res/components/AppBarBackButton.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/profileView/profileView.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  String? userImage;
  File? _image;
  String? base64Image;
  bool isEditing = false;
  List<dynamic> userData = [];

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
        final dynamic responseData = jsonDecode(response.body);
        setState(() {
          name.text = responseData['data']['name'];
          email.text = responseData['data']['email'];
          phoneNumber.text = responseData['data']['phone_number'];
          userImage = responseData['data']['image'];
        });
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during HTTP request: $error');
    }
  }

  Future<void> saveuserData() async {
    if(_image == null){
      Util.flushBarErrorMessage('Pick image first', Icons.sms_failed, Colors.red, context);
      return;
    }
    final url = Uri.parse(AppUrl.userEdit);
    var request = http.MultipartRequest('POST',url);
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    request.fields['id'] = Util.userId!;
    request.fields['name'] = name.text;
    request.fields['password'] = '111111';
    request.fields['email'] = email.text;
    request.fields['phone_number'] = phoneNumber.text;

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const ProfileView()), (route) => false);
      } else {
        final responseBody = await response.stream.bytesToString();
        print('responseBody$responseBody');
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during HTTP request: $error');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _showImagePickerDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Image Source",style: TextStyle(color: AppColors.color1),),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Text("Camera",style:  TextStyle(color: AppColors.color1),),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Gallery",style: TextStyle(color: AppColors.color1),),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_circle_left_rounded, color: AppColors.color1,size: 35,),
        )
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(_image!),
                      )
                          : (userImage != null
                          ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('$userImage'),
                      )
                          : Center(child: CircleAvatar(radius: 50))),
                      isEditing == true
                          ? Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _showImagePickerDialog,
                          child: Icon(Icons.edit),
                        ),
                      )
                          : const Text(''),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: MyTextFieldWidget(
                  labelName: 'User Name',
                  controller: name,
                  enabled: isEditing,
                  validator: () {},
                  length: 22,
                ),
              ),
              SizedBox(
                child: MyTextFieldWidget(
                  labelName: 'Phone Number',
                  controller: phoneNumber,
                  enabled: isEditing,
                  length: 10,
                  keybordtype: TextInputType.number,
                  validator: () {},
                ),
              ),
              MyTextFieldWidget(
                labelName: 'Email',
                controller: email,
                enabled: isEditing,
                validator: () {},
              ),

              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 52,
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

  MyButtonWidget({required this.buttonName,required this.bgColor,required this.onPressed,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 296,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: bgColor,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: bgColor),
        onPressed: onPressed as void Function()?,
        child: Text(buttonName,style: const TextStyle(color: Colors.white),),
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
  IconData? icon;
  Function? paste;
  int? length;
  TextInputType? keybordtype;
  MyTextFieldWidget({
    this.keybordtype,
    this.length,
    this.paste,
    this.icon,
    required this.labelName,
    required this.controller,
    required this.validator,
    this.enabled,
    this.isObsecure = false,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(labelName,style: TextStyle(color: AppColors.color1),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 323.0,
              height: 40.0,
              child: TextFormField(
                controller: controller,style: TextStyle(color:AppColors.color1light),
                enabled: enabled,
                obscureText: isObsecure,
                keyboardType: keybordtype,
                validator:  (value) {
                  return null;
                },
                maxLength: length,
                decoration: InputDecoration(
                  filled: true,
                  suffixIcon: InkWell(
                      onTap: (){},
                      child: Icon(icon)),
                  fillColor: AppColors.color2,
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
