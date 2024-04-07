import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/productDetailsView/productdetailsView.dart';
import 'package:shimmer/shimmer.dart';

class RentedItems extends StatefulWidget {
  const RentedItems({super.key});

  @override
  State<RentedItems> createState() => _RentedItemsState();
}

class _RentedItemsState extends State<RentedItems> {
  List<dynamic> rentedData = [];

  @override
  void initState() {
    super.initState();
    getRentedData();
    print('rented view page');
  }

  Future<void> getRentedData() async {
    print('getting rented items');
    // Define the endpoint URL
    String apiUrl = AppUrl.getRentedData;
    Map<String, dynamic> postData = {'id': Util.userId};
    try {
      // Make the POST request
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postData),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('get rented items success');
        var responseData = jsonDecode(response.body);
        print(responseData);
        setState(() {
          rentedData.clear();
          rentedData.addAll(responseData['data']);
        });
        print('popular items list is:$rentedData');
        print('Response: $responseData');
      } else {
        print('Error: ${response.statusCode}');
        print('Error Message: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: rentedData.isEmpty
            ? _buildShimmerEffect()
            : _buildPopularProductsList(),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5, // Number of shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 100,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
    // Build each item in the list
    return RefreshIndicator(
      onRefresh:getRentedData,
      child: ListView.builder(
        itemCount: rentedData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 2),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(
                      productId: '${rentedData[index]['prod_id']['_id']}',
                      createdUserId: '${rentedData[index]['prod_id']['created_by']}',
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    // height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(
                          width: 0.5, color: const Color.fromRGBO(167, 167, 167, 0.51)),
                    ),
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(15),
                                    image: const DecorationImage(
                                        image: AssetImage('assets/images/van.jpg'),
                                        fit: BoxFit.cover)),
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
                                        '₹ ${rentedData[index]['prod_id']['price']}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.color1,
                                            borderRadius: BorderRadius.circular(18)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 9, top: 2, bottom: 2, right: 9),
                                          child: Text(
                                            '${rentedData[index]['prod_id']['subtype1']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.66),
                                                letterSpacing: 1.6),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      '${rentedData[index]['prod_id']['name']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Color.fromRGBO(0, 0, 0, 0.66)),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_pin,
                                        color: Colors.blue,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '${rentedData[index]['prod_id']['location']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10,
                                            color: Color.fromRGBO(0, 0, 0, 0.66)),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 5.0),
                          child: InkWell(
                            onTap: (){
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>RentedDetail(data: snapshot.data[index],)));
                            },
                            child:  Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                                // '${snapshot.data[index]['time_left']}'
                                                '${rentedData[index]['time_left']}'
                                                ,
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
                                        value: 0.5,
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
