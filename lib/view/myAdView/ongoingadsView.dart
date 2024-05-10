import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';

import 'package:http/http.dart' as http;
import 'package:rentmything/res/components/RentTypeWidget.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/productDetailsView/productdetailsView.dart';

class OngoingAds extends StatefulWidget {
  const OngoingAds({super.key});

  @override
  State<OngoingAds> createState() => _OngoingAdsState();
}

class _OngoingAdsState extends State<OngoingAds> {

  List<dynamic> myposts = [];

  // get my posts
  Future<dynamic> getmypost() async {
    Map<String, dynamic> postData = {
      "id":Util.userId
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
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
                                                RentTypeWidget(listofProducts: myposts, index: index, renttype: myposts[index]['time_period']),
                                                const SizedBox(
                                                  width: 60,
                                                ),
                                                const SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child: Image(image: AssetImage('assets/icons/unfavourite.png')),
                                                )
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
    );
  }
}