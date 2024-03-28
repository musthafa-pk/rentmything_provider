import 'dart:convert';


import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rentmything/res/app_colors.dart';

import 'package:rentmything/res/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/cartView/cartView.dart';
import 'package:rentmything/view/chatView/chatView.dart';
import 'package:rentmything/view/favourite/favourite.dart';
import 'package:rentmything/view/homeView/customTabbar.dart';
import 'package:rentmything/view/homeView/popular.dart';
import 'package:rentmything/view/homeView/vehiclescategory.dart';
import 'package:rentmything/view/myAdView/myAdView.dart';
import 'package:rentmything/view/notificationView/notificationView.dart';
import 'package:rentmything/view/productDetailsView/productdetailsView.dart';
import 'package:rentmything/view/profileView/profileView.dart';
import 'package:rentmything/view/rentoutView/rentOut1.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // int _currentIndex = 0;

  final List<String> images = [
    'assets/images/50offimage.jpg',
    'assets/images/lmtoff.jpg',
    // 'assets/images/van.jpg',
    'assets/images/25off.jpg'
  ];

  //getpopular items api
  // List<dynamic> popularProducts = [];

  // Future<dynamic> getpopularitems() async {
  //   // Define the endpoint URL
  //
  //   String apiUrl = AppUrl.listPopular;
  //   Map<String,dynamic> postData = {
  //     'user_id':Util.userId
  //   };
  //
  //   try {
  //     // Make the POST request
  //     http.Response response = await http.post(
  //         Uri.parse(apiUrl),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: jsonEncode(postData)
  //     );
  //     if (response.statusCode == 200) {
  //       print('get popular items success');
  //       var responseData = jsonDecode(response.body);
  //       print(responseData);
  //
  //         popularProducts.clear();
  //         popularProducts.addAll(responseData['data']);
  //         print('popular items list is:${popularProducts}');
  //
  //       print('popular data :$popularProducts');
  //       print('Response: $responseData');
  //     } else {
  //       print('Error: ${response.statusCode}');
  //       print('Error Message: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  //add to favourite api
  // static Future<dynamic> addtofavourite(String productID,context) async {
  //
  //   Map<String, dynamic> postData ={
  //     "user_id":Util.userId,
  //     "prod_id":productID
  //   };
  //   String url = AppUrl.wishlistAdd;
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(postData),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print('adding to fav success');
  //       var responseData = jsonDecode(response.body);
  //       Util.flushBarErrorMessage('${responseData['message']}', Icons.verified, Colors.green,context);
  //       return responseData;
  //     } else {
  //       var responseData = jsonDecode(response.body);
  //       print('failed response:${responseData}');
  //       Util.flushBarErrorMessage('${responseData['message']}',Icons.sms_failed,Colors.red,context);
  //       print("API request failed with status code: ${response.statusCode}");
  //       print(responseData);
  //
  //     }
  //   } catch (e) {
  //     print("Error making POST request: $e");
  //   }
  // }

  final _TabPages = <Widget>[
    PopularView(),
    VehiclesCategory(category: 'vehicles',),
    VehiclesCategory(category: 'Electronics',),
    VehiclesCategory(category: 'Machineries',),
    VehiclesCategory(category: 'Tools',),
  ];

  final _Tabs = <Tab>[
    const Tab(icon: SizedBox(child: Image(image: AssetImage('assets/icons/popular.png',),height: 24,width: 24,),),text: 'Popular',),
    const Tab(icon: SizedBox(child: Image(image: AssetImage('assets/icons/car.png'),height: 24,width: 24,),),text: 'Vehicles',),
    const Tab(icon: SizedBox(child: Image(image: AssetImage('assets/icons/electronics.png'),height: 24,width: 24,),),text: 'Electronics',),
    const Tab(icon: SizedBox(child: Image(image: AssetImage('assets/icons/machinary.png'),height: 24,width: 24,),),text: 'Machineries',),
    const Tab(icon: SizedBox(child: Image(image: AssetImage('assets/icons/tools.png'),height: 24,width: 24,),),text: 'Tools',),
  ];

  @override
  void initState() {
    // getpopularitems();
    print('Utils.userId: ${Util.userId}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:_Tabs.length,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: MediaQuery.of(context).size.height/4.3,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: AppColors.color1,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rent My Thing',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const NotificationPage()));
                                },
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      child: Image(
                                        image: AssetImage(
                                            'assets/icons/notification.png'),
                                        height: 24,
                                        width: 24,
                                      ),
                                    ),
                                    // Positioned widget to place the notification count badge
                                    Positioned(
                                      right:0,
                                      top: 0,
                                      child: Container(
                                        height: 10,
                                        width: 10,
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: AppColors.color6, // or any other color you want for the badge background
                                          borderRadius: BorderRadius.circular(10),
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FavouritePage()));
                                },
                                child: SizedBox(
                                  child: Image(
                                    image:
                                    AssetImage('assets/icons/favourite.png'),
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: AppColors.color2, borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8,top: 8,bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: SizedBox(
                                  // height: 40,
                                  width: MediaQuery.of(context).size.width / 2.9,
                                  child: const TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Location',
                                        contentPadding: EdgeInsets.all(10),
                                        suffixIcon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black,
                                        ),
                                        hintStyle: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400)),
                                  )),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            const Expanded(
                              child: TextField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: 'Search Now',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color:
                                        Color.fromRGBO(255, 255, 255, 0.66)),
                                    suffixIcon: Icon(
                                      Icons.search_sharp,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TabBar(
                        tabs: _Tabs,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white60,
                      isScrollable:true,
                      dividerHeight: 0,
                      indicatorPadding: EdgeInsets.zero,
                    ),

                    // const Padding(
                    //   padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    //   child: SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child: Row(children: [
                    //       SizedBox(
                    //           width: 100,
                    //           child: Column(
                    //             children: [
                    //               Image(
                    //                 image: AssetImage('assets/icons/car.png'),
                    //                 height: 24,
                    //                 width: 24,
                    //               ),
                    //               Text(
                    //                 'Vehicles',
                    //                 style: TextStyle(
                    //                     fontSize: 12,
                    //                     fontWeight: FontWeight.w400,
                    //                     color: Colors.white),
                    //               )
                    //             ],
                    //           )),
                    //       SizedBox(
                    //           width: 100,
                    //           child: Column(
                    //             children: [
                    //               Image(
                    //                 image: AssetImage(
                    //                     'assets/icons/electronics.png'),
                    //                 height: 24,
                    //                 width: 24,
                    //               ),
                    //               Text(
                    //                 'Electronics',
                    //                 style: TextStyle(
                    //                     fontSize: 12,
                    //                     fontWeight: FontWeight.w400,
                    //                     color: Colors.white),
                    //               )
                    //             ],
                    //           )),
                    //       SizedBox(
                    //           width: 100,
                    //           child: Column(
                    //             children: [
                    //               Image(
                    //                 image:
                    //                 AssetImage('assets/icons/machinary.png'),
                    //                 height: 24,
                    //                 width: 24,
                    //               ),
                    //               Text(
                    //                 'Machineries',
                    //                 style: TextStyle(
                    //                     fontSize: 12,
                    //                     fontWeight: FontWeight.w400,
                    //                     color: Colors.white),
                    //               )
                    //             ],
                    //           )),
                    //       SizedBox(
                    //           width: 100,
                    //           child: Column(
                    //             children: [
                    //               Image(
                    //                 image: AssetImage('assets/icons/tools.png'),
                    //                 height: 24,
                    //                 width: 24,
                    //               ),
                    //               Text(
                    //                 'Tools',
                    //                 style: TextStyle(
                    //                     fontSize: 12,
                    //                     fontWeight: FontWeight.w400,
                    //                     color: Colors.white),
                    //               )
                    //             ],
                    //           )),
                    //       SizedBox(
                    //           width: 100,
                    //           child: Column(
                    //             children: [
                    //               Icon(
                    //                 Icons.chair,
                    //                 color: Colors.white,
                    //               ),
                    //               Text(
                    //                 'Furnitures',
                    //                 style: TextStyle(
                    //                     fontSize: 12,
                    //                     fontWeight: FontWeight.w400,
                    //                     color: Colors.white),
                    //               )
                    //             ],
                    //           )),
                    //     ]),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          // backgroundColor: Colors.white,
          // floatingActionButton: InkWell(
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => RentOut1(),
          //         ));
          //   },
          //   child: Container(
          //     width: 120,
          //     decoration: BoxDecoration(
          //         color: AppColors.color1, borderRadius: BorderRadius.circular(50)),
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             'Rent Out',
          //             style: TextStyle(
          //                 fontSize: 12,
          //                 color: Colors.white,
          //                 fontWeight: FontWeight.w500),
          //           ),
          //           SizedBox(
          //             width: 10.0,
          //           ),
          //           Container(
          //               decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   borderRadius: BorderRadius.circular(100)),
          //               child: Icon(
          //                 Icons.add,
          //                 color: AppColors.color1,
          //               )),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          body:  TabBarView(
              children: _TabPages
          ),
        ),
      ),
    );
  }
}
