
import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/chatView/buyyingChat.dart';
import 'package:rentmything/view/chatView/chatView.dart';
import 'package:rentmything/view/productDetailsView/qrcode_scanner.dart';
import 'package:rentmything/view/rentoutView/markingasrented.dart';

class ProductDetails extends StatefulWidget {
  String? productId;
  String? createdUserId;
  ProductDetails({required this.productId,required this.createdUserId,super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  // api calling function to get product details
  Map<String,dynamic> productDetails = {};

  bool itsmyproduct = false;

  final TextEditingController userid = TextEditingController();

  Future<dynamic> getproductDetails() async {
    String url = AppUrl.getProductDetials;
    Map<String, dynamic> postData ={
      'productId':widget.productId,
      'user_id':Util.userId
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        print('p details:${response.body}');
        var responseData = jsonDecode(response.body);
        setState(() {
          productDetails.clear();
          productDetails.addAll(responseData['data']);
          userid.text = responseData['data']['_id'];
        });
        print('productDetails :$productDetails');
        return responseData;
      } else {
        var responseData = jsonDecode(response.body);
        print("API request failed with status code: ${response.statusCode}");
        print(responseData);

      }
    } catch (e) {
      print("Error making POST request: $e");
      return null;
    }
  }
  //end

  void _shareProductDetails() async {
    try {
      // Define the text content to share
      String productDetails = '''
      HYUNDAI NEW I20 2023
      Brand: Hyundai
      Price: ₹3400 per day
      Location: Kozhikode, Vadakara
      Musthafa
      Posted On: 1-3-2024
      Description:
      - Parking Sensors: Yes
      - Power Steering: Yes
      - Power Windows: Front & rear
      - AM/FM Radio: Yes
      - Rear parking Camera: Yes
      ''';

      // Share the product details
      await FlutterShare.share(
        title: 'Product Details',
        text: productDetails,
      );
    } catch (e) {
      print('Error sharing: $e');
      // Handle errors here
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print('product id is:${widget.productId}');
    print(('user id:${widget.createdUserId}'));
    getproductDetails();
    _productDetailsFuture = getproductDetails();
    if(Util.userId == widget.createdUserId){
      setState(() {
        itsmyproduct = true;
      });
    }else{
      setState(() {
        itsmyproduct = false;
      });
    }
    super.initState();
  }
  late Future<dynamic> _productDetailsFuture;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: (){
                Util.makingPhonecall(context,productDetails['created_by']['phone_number']);
              },
              child: Container(
                width: 50,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(217,217,217,1), borderRadius: BorderRadius.circular(8)),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.call,color: AppColors.color1,),
                    ],
                  ),
                ),
              ),
            ),
            itsmyproduct == false ?  InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> BuyyingChat(customerName: productDetails['created_by']['name'], senderId: Util.userId!, reciverId: productDetails['created_by']['_id'])));
              },
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                    color: AppColors.color1, borderRadius: BorderRadius.circular(8)),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat,color: Colors.white,),
                      Text(
                        'Chat Now',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
            ) :
            productDetails['rent_status'] == 'true' ? InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MarkingasRented(cust_id: '${productDetails['created_by']['_id']}',prod_id: '${productDetails['_id']}',)));
              },
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                    color: AppColors.color1, borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.domain_verification,color: Colors.white,),
                      const SizedBox(width: 10,),
                      Text(
                        'Change Status',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
            ):InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>QrcodeScanPage(
                  productid:productDetails['_id'] ,
                )));
              },
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                    color: AppColors.color1, borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code,color: Colors.white,),
                      const SizedBox(width: 10,),
                      Text(
                        'Add Rent Data',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: (){
              _shareProductDetails();
            },
            child: const Icon(
              Icons.share,
            ),
          ),
          SizedBox(width: 10,),
          const Icon(Icons.favorite),
          SizedBox(width: 20,),
        ],
        leading: InkWell(onTap: (){
          Navigator.pop(context);
        },child: const Icon(Icons.arrow_circle_left)),
      ),
      body: FutureBuilder(
        future: _productDetailsFuture,
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
            {
              return Center(child: CircularProgressIndicator(),);
            }else if(snapshot.hasError){
            return Center(child:  Text('Error: ${snapshot.error}'),);
          }else{
            return SingleChildScrollView(
              child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            '${productDetails['name'] ?? 'N/A'}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.color1, borderRadius: BorderRadius.circular(4)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 4, left: 16, right: 16.0),
                              child: Text(
                                '${productDetails['brand'] ?? 'N/A'}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SingleChildScrollView(
                          child: Row(children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/images/redcar.jpg',
                                        ),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/images/redcar.jpg',
                                        ),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/images/bluecar.jpg',
                                        ),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '₹ ${productDetails['price'] ?? 'N/A'}',
                                    style:
                                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: const Color.fromRGBO(255, 24, 93, 1),
                                          borderRadius: BorderRadius.circular(6)),
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0, right: 10.0, top: 2, bottom: 2),
                                        child: Text(
                                          'Daily',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_pin,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    '${productDetails['location'] ?? 'N/A'}',
                                    style:
                                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: 90,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromRGBO(0, 106, 152, 0.25),
                                                offset: Offset(2, 2),
                                                spreadRadius: -2,
                                                blurRadius: 19)
                                          ],
                                          border: Border.all(
                                            width: 0.5,
                                            color: const Color.fromRGBO(167, 167, 167, 0.51),
                                          )),
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Row(children: [
                                          Icon(
                                            Icons.speed,
                                            size: 13,
                                            color: AppColors.color1,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${productDetails['subtype2'] != null ? productDetails['subtype2'] + ' KM' : 'N/A'}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 8,
                                              color: AppColors.color1,
                                            ),
                                          )

                                        ]),
                                      ),
                                    ),
                                    Container(
                                      width: 90,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromRGBO(0, 106, 152, 0.25),
                                                offset: Offset(2, 2),
                                                spreadRadius: -2,
                                                blurRadius: 19)
                                          ],
                                          border: Border.all(
                                            width: 0.5,
                                            color: const Color.fromRGBO(167, 167, 167, 0.51),
                                          )),
                                      child:  Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Row(children: [
                                          Icon(
                                            Icons.water_drop,
                                            size: 12,
                                            color: AppColors.color1,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${productDetails['subtype3'] ?? 'N/A'}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 8,
                                                color: AppColors.color1),
                                          )
                                        ]),
                                      ),
                                    ),
                                    Container(
                                      width: 90,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromRGBO(0, 106, 152, 0.25),
                                                offset: Offset(2, 2),
                                                spreadRadius: -2,
                                                blurRadius: 19)
                                          ],
                                          border: Border.all(
                                            width: 0.5,
                                            color: const Color.fromRGBO(167, 167, 167, 0.51),
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(children: [
                                          const Icon(
                                            Icons.calendar_month,
                                            size: 12,
                                            color: AppColors.color1,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${productDetails['year'] ?? 'N/A'}',
                                            style: const TextStyle(
                                              color: AppColors.color1,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 8,
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("User Details"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.color2,
                                              ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                                                    child: TextFormField(
                                                      controller: userid,
                                                      readOnly: true,
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        suffixIcon: InkWell(
                                                          onTap: (){
                                                            if(userid.text.trim() == ""){
                                                              print('enter text');
                                                            } else {
                                                              print(userid.text);
                                                              FlutterClipboard.copy(userid.text).then(( value ) =>
                                                                  print('copied'));
                                                            }
                                                          },
                                                            child: Icon(Icons.copy))
                                                      ),
                                                    ),
                                                  )),
                                              Text(
                                                'Name: ${productDetails['created_by']['name']}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Verified By:',
                                                  ),
                                                  Icon(Icons.phone, size: 18, color: Colors.grey),
                                                  Icon(Icons.mail, size: 18, color: Colors.blue),
                                                  Icon(Icons.credit_card, size: 18, color: Colors.grey),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Posted On: ${DateFormat('yyyy-MM-dd HH:mm a').format(DateTime.parse(productDetails['createdAt']))}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(0, 0, 0, 0.66),
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 1.1,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(210, 220, 223, 0.62),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Stack(
                                            children: [
                                              CircleAvatar(
                                                radius: 50,
                                                backgroundColor: AppColors.color1,
                                                child: Text(
                                                  '${productDetails['created_by']['name'].toString().substring(0, 1)}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 28,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              productDetails['created_by']['is_active'] == 'Y'
                                                  ? Positioned(
                                                bottom: 0,
                                                right: 10,
                                                child: Container(
                                                  padding: const EdgeInsets.all(2),
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                  child: const Icon(
                                                    Icons.verified,
                                                    color: Colors.blue,
                                                    size: 20,
                                                  ),
                                                ),
                                              )
                                                  : Positioned(
                                                bottom: 0,
                                                right: 10,
                                                child: Container(
                                                  padding: const EdgeInsets.all(2),
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                  child: const Icon(
                                                    Icons.verified,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${productDetails['created_by']['name']}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              Text(
                                                'Posted On: ${DateFormat('yyyy-MM-dd HH:mm a').format(DateTime.parse(productDetails['createdAt']))}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(0, 0, 0, 0.66),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Discription',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: 0.5),
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(210, 220,223, 0.60)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${productDetails['description'] ?? 'N/A'}'),
                                    ),
                                  ),
                                ],
                              ),
                              Text(' # test rent status :${productDetails['rent_status']}'),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Rating'),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          }

        }
      ),
    );
  }
}
