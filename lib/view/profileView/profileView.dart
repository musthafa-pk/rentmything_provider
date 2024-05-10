import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:rentmything/res/components/AppBarBackButton.dart';
import 'package:rentmything/res/components/profileTabs.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/authView/loginScreen.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
import 'package:rentmything/view/profileView/editprofile.dart';
import 'package:rentmything/view/profileView/helpsupport.dart';
import 'package:rentmything/view/profileView/settings/settings.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  dynamic userData = {};

  void _inviteFriends() {
    // Message to be shared with friends
    String message = 'Hey! Check out this cool app. You can download it from the following link';

    // Open share dialog
    FlutterShare.share(
        title: 'Rent My Thing',
        chooserTitle: 'Rent My Thing',
        linkUrl: 'https://drive.google.com/file/d/1iIuGdQoUrySssAY1X5P6rCfVlWXLXfoq/view?usp=sharing',
      text: message
    );
  }

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
            child: const Icon(Icons.arrow_circle_left,color: AppColors.color1,size: 35,)),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
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
                    const SizedBox(height: 20,),
                    Center(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const EditProfile()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/1.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                               snapshot.data['data']['image'] == null ? Center(child: CircleAvatar(radius: 50,)) : CircleAvatar(
                                  radius: 45,
                                  backgroundImage: NetworkImage('${snapshot.data['data']['image']}',),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${snapshot.data['data']['name']}',style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.color1,
                                        fontSize: 16),),
                                    Text('${snapshot.data['data']['phone_number']}',style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: AppColors.color1,
                                        fontSize: 10),),
                                    Text('${snapshot.data['data']['email']}',style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: AppColors.color1,
                                        fontSize: 10)),
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 40,),
                    SizedBox(
                      height: 50,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings()));
                        },
                          child: ProfileTabs(tabname:'Settings' ,tabicon:const Icon(Icons.settings,color: Colors.white),tabcolor: AppColors.color4 ,)),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      height: 50,
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HelpAndSupportPage(),));
                          },
                            child: ProfileTabs(tabname:'Help & Support' ,tabicon:const Icon(Icons.support,color: Colors.white),tabcolor: AppColors.color5 ,))),
                    const SizedBox(height: 20,),
                    SizedBox(
                        height: 50,
                        child: InkWell(
                            onTap: (){
                              _inviteFriends();
                            },
                            child: ProfileTabs(tabname:'Invite Friends' ,tabicon:const Icon(Icons.person_add_alt_outlined,color: Colors.white),tabcolor: AppColors.color1 ,))),
                    const SizedBox(height: 20,),
                    SizedBox(
                      height: 50,
                      child: InkWell(onTap: ()async{
                        Util.clearUserPrefs();
                        await Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const LoginScreen()));
                      },child: ProfileTabs(tabname:'Logout' ,tabicon:const Icon(Icons.logout_rounded,color: Colors.white,),tabcolor: AppColors.color6 ,)),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 200,
                              width: 200,
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
                                                Text("Info",style: TextStyle(color: AppColors.color1),),
                                              ],
                                            ),
                                            content: Text("Show this code to add rent data!",style: TextStyle(
                                              color: AppColors.color1
                                            ),),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Close",style: TextStyle(color: AppColors.color1),),
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
                  ],
                );
              }
              else{
                return const Center(child: Text('Please restart your application'),);
              }
            }
        ),
      ),
    );
  }
}


//widgets
