import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentmything/res/components/AppBarBackButton.dart';
import 'package:http/http.dart' as http;
import 'package:rentmything/res/components/shimmer2.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_url.dart';
import '../../productDetailsView/productdetailsView.dart';

class ProfileWithProducts extends StatefulWidget {
  String userID;
  ProfileWithProducts({required this.userID,super.key});

  @override
  State<ProfileWithProducts> createState() => _ProfileWithProductsState();
}

class _ProfileWithProductsState extends State<ProfileWithProducts> {

  dynamic userData = {};
  List<dynamic> myposts = [];
  bool isLoading = false;

  Future<dynamic> userProfile() async {
    String url = AppUrl.userDetails;
    Map<String,dynamic> data ={
      "id":widget.userID
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
        setState(() {
          isLoading = true;
          userData.clear();
          userData.addAll(responseData);
        });
        return responseData;
      } else {
        setState(() {
          isLoading = false;
        });
        // Failed POST request
        print('Failed to make POST request');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Exception occurred during the request
      print('Error occurred during POST request: $e');
    }
  }

  Future<dynamic> getmypost() async {
    Map<String, dynamic> postData = {
      "id":widget.userID
    };
    String url = AppUrl.listProducts;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        print('getmypost success');
        var responseData = jsonDecode(response.body);
        myposts.clear();
        myposts.addAll(responseData['data']);
        print('myposts is :$myposts');
        return responseData;
      } else {
        var responseData = jsonDecode(response.body);
        print("API request failed with status code: ${response.statusCode}");
        print(responseData);

      }
    } catch (e) {
      print("Error making POST request: $e");
    }
  }

  @override
  void initState() {
    isLoading = false;
    // TODO: implement initState
    userProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(),
      ),
      body: SafeArea(
        child: isLoading ?Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width/1.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    userData['data']['image'] == null ? Center(child: CircleAvatar(radius: 50,)) : CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage('${userData['data']['image']}',),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${userData['data']['name']}',style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.color1,
                            fontSize: 16),),
                        Text('${userData['data']['phone_number']}',style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            color: AppColors.color1,
                            fontSize: 10),),
                        Text('${userData['data']['email']}',style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            color: AppColors.color1,
                            fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: FutureBuilder(
                  future: getmypost(),
                  builder: (context,snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator(),);
                    }else if(snapshot.hasError){
                      return const Center(child: Text('Some error happened !'),);
                    }else{
                      return RefreshIndicator(
                        onRefresh: getmypost,
                        child: ListView.builder(
                            itemCount: myposts.length,
                            itemBuilder: (context,index) {
                              return Padding(
                                padding: const EdgeInsets.all(2.5),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                                      productId: '${myposts[index]['_id']}',
                                      createdUserId: '${myposts[index]['created_by']}',
                                    )));
                                  },
                                  child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(19),
                                          border: Border.all(
                                              width: 0.5,
                                              color: const Color.fromRGBO(167, 167, 167, 0.51))),
                                      width: MediaQuery.of(context).size.width / 1.1,
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                Padding(padding: const EdgeInsets.only(left: 10),
                                                  child: Container(
                                                    height: 80,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius: BorderRadius.circular(15),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          myposts[index]['image'] != null && myposts[index]['image'].isNotEmpty ? myposts[index]['image'][0] : 'https://via.placeholder.com/150', // Display the first image if available, otherwise display a placeholder image
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '₹ ${myposts[index]['price']}',
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w500,
                                                                color: AppColors.color1,
                                                                letterSpacing: 1),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                color: AppColors.color1,
                                                                borderRadius: BorderRadius.circular(18)),
                                                            child: const Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: 9, top: 2, bottom: 2, right: 9),
                                                              child: Text(
                                                                'Daily',
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w700,
                                                                    color:
                                                                    Color.fromRGBO(255, 255, 255, 0.66),
                                                                    letterSpacing: 2),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(padding: const EdgeInsets.all(4),
                                                        child: Text('${myposts[index]['name']}',style: const TextStyle(fontWeight: FontWeight.w400,
                                                            fontSize: 12,
                                                            color: Color.fromRGBO(0, 0, 0, 0.66)),),),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.location_pin,
                                                            color: Colors.blue,
                                                            size: 16,
                                                          ),
                                                          const SizedBox(width: 10,),
                                                          Text('${myposts[index]['location']}',style: const TextStyle(fontWeight: FontWeight.w400,
                                                              fontSize: 10,
                                                              color: Color.fromRGBO(0, 0, 0, 0.66)),)
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            }
                        ),
                      );
                    }
                  }
              ),
            )
          ],
        ):ShimmerEffect(),
      ),
    );
  }
}
