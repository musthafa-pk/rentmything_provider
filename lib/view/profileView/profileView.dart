import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/authView/loginScreen.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
import 'package:rentmything/view/profileView/editprofile.dart';
import 'package:rentmything/view/splashView/successView.dart';

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
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BottomNavigationPage()), (route) => false);
            },
            child: Icon(Icons.arrow_back_rounded,color: AppColors.color1,)),
      ),
      body: FutureBuilder(
          future: userProfile(),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            if(snapshot.hasError){
              return Center(child: Text('Some Error Occured!'),);
            }if(snapshot.hasData){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('My Profile',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${snapshot.data['data']['name']}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                            Text('${snapshot.data['data']['phone_number']}',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10),),
                            Text('${snapshot.data['data']['email']}',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10)),
                          ],
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile()));
                            },
                            child: Icon(Icons.edit))
                      ],
                    ),
                  ),
                  SizedBox(height: 40,),
                  ProfileTabs(tabname:'Settings' ,tabicon:Icon(Icons.settings,color: Colors.white),tabcolor: AppColors.color4 ,),
                  SizedBox(height: 20,),
                  ProfileTabs(tabname:'Help & Support' ,tabicon:Icon(Icons.support,color: Colors.white),tabcolor: AppColors.color5 ,),
                  SizedBox(height: 20,),
                  InkWell(onTap: (){
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
                  },child: ProfileTabs(tabname:'Logout' ,tabicon:Icon(Icons.logout_rounded,color: Colors.white,),tabcolor: AppColors.color6 ,)),
                  SizedBox(height: 20,),

                ],
              );
            }
            else{
              return Center(child: Text('Please restart your application'),);
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
          SizedBox(width: 50,),
          CircleAvatar(
              radius: 30,
              backgroundColor: tabcolor,
              child: tabicon
          ),
          SizedBox(width: 30,),
          Text(tabname,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Color.fromRGBO(0, 0, 0, 0.56)),)
        ],
      ),
    );
  }
}