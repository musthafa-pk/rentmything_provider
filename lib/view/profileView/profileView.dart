import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/authView/loginScreen.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
import 'package:rentmything/view/profileView/editprofile.dart';
import 'package:rentmything/view/profileView/settings.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  dynamic userData = {};

  Future<dynamic> userProfile() async {
    String url = AppUrl.userDetails;
    Map<String,dynamic> data ={
      "id":Util.userId
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
        var responseData = jsonDecode(response.body);
          userData.clear();
          userData.addAll(responseData);
        return responseData;
      } else {
        // Failed POST request
        print('Failed to make POST request');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      // Exception occurred during the request
      print('Error occurred during POST request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const BottomNavigationPage()), (route) => false);
            },
            child: const Icon(Icons.arrow_back_rounded,color: AppColors.color1,)),
      ),
      body: FutureBuilder(
          future: userProfile(),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }
            if(snapshot.hasError){
              return const Center(child: Text('Some Error Occured!'),);
            }if(snapshot.hasData){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(50)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 200,
                                height:  200,
                                child: QrImageView(
                                  data:snapshot.data['data']['_id'],
                                  version: QrVersions.auto,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: (){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Row(
                                          children: [
                                            Icon(Icons.info,color: AppColors.color1,),
                                            Text("Info"),
                                          ],
                                        ),
                                        content: Text("Show this code to add rent data!"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Close"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                  child: Icon(Icons.info,color: AppColors.color1,)))
                        ],
                      ),
                    ],
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('My Profile',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${snapshot.data['data']['name']}',style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                            Text('${snapshot.data['data']['phone_number']}',style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 10),),
                            Text('${snapshot.data['data']['email']}',style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 10)),
                          ],
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const EditProfile()));
                            },
                            child: const Icon(Icons.edit))
                      ],
                    ),
                  ),
                  const SizedBox(height: 40,),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings()));
                    },
                      child: ProfileTabs(tabname:'Settings' ,tabicon:const Icon(Icons.settings,color: Colors.white),tabcolor: AppColors.color4 ,)),
                  const SizedBox(height: 20,),
                  ProfileTabs(tabname:'Help & Support' ,tabicon:const Icon(Icons.support,color: Colors.white),tabcolor: AppColors.color5 ,),
                  const SizedBox(height: 20,),
                  InkWell(onTap: ()async{
                    Util.clearUserPrefs();
                    await Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const LoginScreen()));
                  },child: ProfileTabs(tabname:'Logout' ,tabicon:const Icon(Icons.logout_rounded,color: Colors.white,),tabcolor: AppColors.color6 ,)),
                  const SizedBox(height: 20,),

                ],
              );
            }
            else{
              return const Center(child: Text('Please restart your application'),);
            }
          }
      ),
    );
  }
}


//widgets
class ProfileTabs extends StatelessWidget {
  String tabname;
  Icon tabicon;
  Color tabcolor;
  ProfileTabs({required this.tabname,required this.tabicon,required this.tabcolor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          const SizedBox(width: 50,),
          CircleAvatar(
              radius: 30,
              backgroundColor: tabcolor,
              child: tabicon
          ),
          const SizedBox(width: 30,),
          Text(tabname,style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Color.fromRGBO(0, 0, 0, 0.56)),)
        ],
      ),
    );
  }
}