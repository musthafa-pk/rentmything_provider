import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/productDetailsView/productdetailsView.dart';
import 'package:rentmything/view/renteddetail.dart';
import 'package:rentmything/view/rentoutView/rentOut1.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class PopularView extends StatefulWidget {
  const PopularView({Key? key}) : super(key: key);

  @override
  State<PopularView> createState() => _PopularViewState();
}

class _PopularViewState extends State<PopularView> {

  int _currentIndex = 0;

  final List<String> images = [
    'assets/images/50offimage.jpg',
    'assets/images/lmtoff.jpg',
    // 'assets/images/van.jpg',
    'assets/images/25off.jpg'
  ];

  List<dynamic> popularProducts = [];
  List<dynamic> rentedProducts = [];

  Future<dynamic> getpopularitems() async {
    // Define the endpoint URL

    String apiUrl = AppUrl.listPopular;
    Map<String, dynamic> postData = {'user_id': Util.userId};

    try {
      // Make the POST request
      http.Response response = await http.post(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(postData));
      if (response.statusCode == 200) {
        print('get popular items success');
        var responseData = jsonDecode(response.body);
        print(responseData);
          popularProducts.clear();
          popularProducts.addAll(responseData['data']);
          print('popular items list is:${popularProducts}');
        print('popular data :$popularProducts');
        print('Response: $responseData');
        return popularProducts;
      } else {
        print('Error: ${response.statusCode}');
        print('Error Message: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  //add to favourite api
  Future<dynamic> addtofavourite(String productID, context) async {
    Map<String, dynamic> postData = {
      "user_id": Util.userId,
      "prod_id": productID
    };
    String url = AppUrl.wishlistAdd;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        print('adding to fav success');
        var responseData = jsonDecode(response.body);
        Util.flushBarErrorMessage('${responseData['message']}',
            Icons.verified, Colors.green, context);
        setState(() {

        });
        return responseData;
      } else {
        var responseData = jsonDecode(response.body);
        print('failed response:${responseData}');
        Util.flushBarErrorMessage('${responseData['message']}',
            Icons.sms_failed, Colors.red, context);
        print("API request failed with status code: ${response.statusCode}");
        print(responseData);
      }
    } catch (e) {
      print("Error making POST request: $e");
    }
  }

  // get rented items data
  Future<dynamic> getrentedData() async {
    Map<String, dynamic> postData = {
      "id":Util.userId
    };
    String url = AppUrl.getRentedData;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        print('geting rented Data');
        var responseData = jsonDecode(response.body);
        print(responseData);
        return responseData['data'];
      } else {
        var responseData = jsonDecode(response.body);
        print('failed response:${responseData}');
        Util.flushBarErrorMessage('${responseData['message']}',
            Icons.sms_failed, Colors.red, context);
        print("API request failed with status code: ${response.statusCode}");
        print(responseData);
      }
    } catch (e) {
      print("Error making POST request: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getpopularitems();
    getrentedData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RentOut1(),
              ));
        },
        child: Container(
          width: 120,
          decoration: BoxDecoration(
              color: AppColors.color1, borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Rent Out',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)),
                    child: Icon(
                      Icons.add,
                      color: AppColors.color1,
                    )),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                  items: images.map((imagePath) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width / 1.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey,
                                image: DecorationImage(
                                    image: AssetImage(imagePath),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        // Center(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: images.map((image){
                        //       int index = images.indexOf(image);
                        //       return Container(
                        //         width: 8.0,
                        //         height: 8.0,
                        //         margin:EdgeInsets.symmetric(vertical: 10.0,horizontal: 2),
                        //         decoration: BoxDecoration(
                        //           shape: BoxShape.circle,
                        //           color: _currentIndex == index ? Colors.blueAccent : Colors.grey
                        //         ),
                        //       );
                        //     }).toList(),
                        //   ),
                        // )
                      ],
                    );
                  }).toList(),
                  options: CarouselOptions(
                      autoPlay: true,
                      // enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, _) {
                        setState(() {
                          _currentIndex = index;
                        });
                      })),
            ),

            //neeed scrooooooooooooool
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Text(
                'My Rentals',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),

            SizedBox(
              height: 120,
              child: FutureBuilder(
                future: getrentedData(),
                builder: (context,snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return _buildShimmerEffect();
                  }else if(snapshot.hasError){
                    return Center(child: Text('Some error'),);
                  }else if(snapshot.hasData){
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            // shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Map<String,dynamic> rentedItem = snapshot.data[index];
                              DateTime startDate = DateTime.parse(rentedItem['start_date']);
                              DateTime endDate = DateTime.parse(rentedItem['end_date']);
                              DateTime now = DateTime.now();
                              double progress = now.isBefore(endDate)?
                                  now.difference(startDate).inDays.toDouble() /
                              endDate.difference(startDate).inDays.toDouble():1.0;
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, bottom: 5.0),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>RentedDetail(data: snapshot.data[index],)));
                                  },
                                  child: Container(
                                    height: 105,
                                    width: MediaQuery.of(context).size.width / 1.5,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 0.5,
                                            color: const Color.fromRGBO(
                                                167, 167, 167, 0.51)),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: const [
                                          BoxShadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 5,
                                            color: Color.fromRGBO(0, 106, 152, 0.25),
                                          )
                                        ]),
                                    child:  Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(2.0),
                                              child: Text(
                                                '${snapshot.data[index]['prod_id']['name']}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 80,
                                                  child: Flexible(
                                                    child: Text('10 Month Agreement',
                                                        style: TextStyle(
                                                            fontSize: 8,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.red),
                                                        maxLines: 2,
                                                        overflow:
                                                        TextOverflow.ellipsis),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 80,
                                                  child: Flexible(
                                                      child: Text(
                                                        '${snapshot.data[index]['time_left']}',
                                                        style: TextStyle(
                                                            fontSize: 8,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.red),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      )),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10.0, bottom: 10.0),
                                              child: LinearProgressIndicator(
                                                value: progress,
                                                backgroundColor:
                                                Color.fromRGBO(217, 217, 217, 1),
                                                color: Color.fromRGBO(25, 178, 0, 1),
                                                minHeight: 8.0,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    );
                  }else
                  return Text('Please restart your application');
                }
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10.0),
              child: Text(
                'Popular',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),

            FutureBuilder(
              future: getpopularitems(),
              builder: (context,snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return _buildShimmerEffect();
                }else if(snapshot.hasError){
                  return Center(child: Text('Some error happened !'),);
                }else if(snapshot.hasData){
                  return _buildPopularProductsList();
                }else{
                  return
                    Center(child: Text('Please restart your application !'),);
                }
              }
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: popularProducts.length, // Number of shimmer items
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 100,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopularProductsList() {
    // Return the actual list of popular products
    return ListView.builder(
      itemCount: popularProducts.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // Build each item in the list
        return ListView.builder(
            itemCount: popularProducts.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 2, bottom: 2),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetails(
                              productId: '${popularProducts[index]['_id']}',
                              createdUserId: '${popularProducts[index]['created_by']}',
                            )));
                  },
                  child: Stack(
                    children: [
                      Container(
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(19),
                              border: Border.all(
                                  width: 0.5,
                                  color: Color.fromRGBO(
                                      167, 167, 167, 0.51))),
                          width:
                          MediaQuery.of(context).size.width / 1.1,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                      BorderRadius.circular(15),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/van.jpg'),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '₹ ${popularProducts[index]['price']}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.w500,
                                              letterSpacing: 1),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.color1,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  18)),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 9,
                                                top: 2,
                                                bottom: 2,
                                                right: 9),
                                            child: Text(
                                              '${popularProducts[index]['subtype1']}',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.w700,
                                                  fontSize: 10,
                                                  color: Color.fromRGBO(
                                                      255,
                                                      255,
                                                      255,
                                                      0.66),
                                                  letterSpacing: 1.6),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '${popularProducts[index]['name']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Color.fromRGBO(
                                                0, 0, 0, 0.66)),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_pin,
                                          color: Colors.blue,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${popularProducts[index]['location']}',
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.w400,
                                              fontSize: 10,
                                              color: Color.fromRGBO(
                                                  0, 0, 0, 0.66)),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                      // Text('${popularProducts}'),
                      Positioned(
                          top: 10,
                          right: 10,
                          child: popularProducts[index]
                          ['wishlist'] ==
                              true
                              ? InkWell(
                              onTap: () {
                                setState(() {
                                  addtofavourite(
                                      '${popularProducts[index]['_id']}',
                                      context);
                                });
                              },
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: Image(
                                  image: AssetImage(
                                      'assets/icons/favourite.png'),
                                ),
                              ))
                              : InkWell(
                              onTap: () {
                                setState(() {
                                  addtofavourite(
                                      '${popularProducts[index]['_id']}',
                                      context);
                                });
                              },
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: Image(
                                  image: AssetImage(
                                      'assets/icons/unfavourite.png'),
                                ),
                              ))),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}





