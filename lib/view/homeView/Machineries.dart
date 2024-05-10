import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:rentmything/res/components/RentTypeWidget.dart';
import 'package:rentmything/view/productDetailsView/productdetailsView.dart';

class Machineries extends StatefulWidget {
  String category;
  Machineries({required this.category,super.key});

  @override
  State<Machineries> createState() => _MachineriesState();
}

class _MachineriesState extends State<Machineries> {

  List<dynamic> listofelectronics = [];
  Future<dynamic> getmachineries() async {
    Map<String, dynamic> data = {
      "category":widget.category
    };
    // Define your endpoint URL
    String url = AppUrl.getProductbycatego;

    try {
      // Make the POST request
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the response body from JSON
        var responseData = jsonDecode(response.body);
        print(responseData);
        setState(() {
          listofelectronics.clear();
          listofelectronics.addAll(responseData['data']);
        });
        // Return the decoded response data
        return responseData;
      } else {
        // If the request was not successful, throw an exception
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Catch any errors that occur during the request
      print('Error: $e');
      // Throw an exception with the error message
      throw Exception('Error making POST request: $e');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    getmachineries();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Text('${vehiclescategory}'),
          Expanded(
              child: ListView.builder(
                itemCount:listofelectronics.length,
                itemBuilder: (context, index) {
                  return Center(
                    child:
                    listofelectronics.length == 0 ? Center(child: Text('NO Data',style: TextStyle(color: AppColors.color1),)) :
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                          productId: '${listofelectronics[index]['_id']}',
                          createdUserId: '${listofelectronics[index]['created_by']}',)));
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
                                      color: const Color.fromRGBO(167, 167, 167, 0.51))),
                              width: MediaQuery.of(context).size.width / 1.1,
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
                                            listofelectronics[index]['image'] != null && listofelectronics[index]['image'].isNotEmpty ? listofelectronics[index]['image'][0] : 'https://via.placeholder.com/150', // Display the first image if available, otherwise display a placeholder image
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
                                              '₹ ${listofelectronics[index]['price']}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.color1,
                                                  letterSpacing: 1),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            RentTypeWidget(listofProducts: listofelectronics, index: index, renttype: listofelectronics[index]['time_period']),
                                          ],
                                        ),
                                        Padding(padding: const EdgeInsets.all(4),
                                          child: Text('${listofelectronics[index]['name']}',style: const TextStyle(fontWeight: FontWeight.w400,
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
                                            Text('${listofelectronics[index]['location']}',style: const TextStyle(fontWeight: FontWeight.w400,
                                                fontSize: 10,
                                                color: Color.fromRGBO(0, 0, 0, 0.66)),)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          Positioned(
                              top: 10,
                              right: 10,
                              child:listofelectronics[index]['rent_status'] == false ? InkWell(
                                onTap: (){
                                  // addtofavourite('${snapshot.data['data'][index]['_id']}', context);
                                },
                                child: const SizedBox(height: 24,width: 24,child: Image(
                                  image: AssetImage('assets/icons/unfavourite.png'),),
                                ),
                              ):InkWell(
                                onTap: (){
                                  // addtofavourite('${snapshot.data['data'][index]['_id']}', context);
                                },
                                child: const SizedBox(height: 24,width: 24,child: Image(
                                  image: AssetImage('assets/icons/favourite.png'),),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  );
                },)
          )
        ],
      ),
    );
  }
}
