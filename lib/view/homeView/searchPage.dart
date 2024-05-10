import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/productDetailsView/productdetailsView.dart';

class SearchPage extends StatefulWidget {
  String? location;
  SearchPage({this.location,Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> _suggestions = [];
  ScrollController scrollController = ScrollController();
  final FocusNode searchFocusNode = FocusNode();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFilterDrawerOpen = false;
  RangeValues _currentRangeValues = RangeValues(0, 1000);
  TextEditingController newlocationController = TextEditingController();

  // Function to toggle the filter drawer
  void toggleFilterDrawer() {
    setState(() {
      isFilterDrawerOpen = !isFilterDrawerOpen;
    });
  }
  Future<void> searchapi(String query) async {
    try {
      // Your API endpoint URL
      String url = AppUrl.searchapi;

      // Your request headers, if needed
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        // Add any other headers required by your API
      };

      // Your request body, in this case, you might send the search query
      Map<String, dynamic> body = {
        'searchdata': query,
        'location':widget.location,
      };

      // Convert the request body to JSON
      String requestBody = json.encode(body);

      // Make the POST request
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBody,
      );

      // Check the response status code
      if (response.statusCode == 200) {
        print('search success....');
        // Request successful, handle the response data
        var responseData = json.decode(response.body);
        print('response is:${responseData}');
        // Check if 'suggestions' field exists and is not null
        // Check if 'data' field exists and is not null
        if (responseData['data'] != null) {
          print('its nt null');
          // Extract names from each item in the 'data' array
          List<dynamic> suggestions = [];
          suggestions.addAll(responseData['data']);
          print('sss:$suggestions');
          // for (var item in responseData['data']) {
          //   suggestions.add(item['name']);
          // }
          setState(() {
            // Update the suggestions list with the received names
            _suggestions = suggestions;
          });
          print(_suggestions);
        } else {
          print('No suggestions found.');
          // Handle the case where no suggestions are found
          setState(() {
            _suggestions.clear();
          });
        }

        // You can handle the response data here, such as updating the UI with search results.
      } else {
        // Request failed, handle the error
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
        // You can handle the error here, such as displaying an error message to the user.
      }
    } catch (error) {
      // Handle any exceptions thrown during the request
      print('Exception: $error');
      // You can handle exceptions here, such as displaying an error message to the user.
    }
  }

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
        print('failed response:$responseData');
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
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    searchFocusNode.requestFocus();
    // TODO: implement initState
    searchapi('');
    super.initState();
  }
  @override
  Widget _buildSearchResultsList() {
    return ListView.builder(
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        // final suggestion = _suggestions[index];
        return Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 2,
            bottom: 2,
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetails(
                    productId: _suggestions[index]['_id'],
                    createdUserId: _suggestions[index]['created_by'],
                  ),
                ),
              );
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
                      color: const Color.fromRGBO(167, 167, 167, 0.51),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Row(
                    children: [
                      // Replace this with your desired UI for each search result item.
                      // For example, display the product image, price, name, etc.
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(
                                _suggestions[index]['image'] != null && _suggestions[index]['image'].isNotEmpty ? _suggestions[index]['image'][0] : 'https://via.placeholder.com/150', // Display the first image if available, otherwise display a placeholder image
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
                            // Replace these Text widgets with your desired UI
                            Text(
                              '${_suggestions[index]['name']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                letterSpacing: 1,
                                color: AppColors.color1
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                '₹ ${_suggestions[index]['price']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Color.fromRGBO(0, 0, 0, 0.66),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap:(){

                                  },
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${_suggestions[index]['location']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                    color: Color.fromRGBO(0, 0, 0, 0.66),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchList() {
    if (_suggestions.isEmpty) {
      // Return an empty container if there are no search results
      return Center(child: SizedBox(
        height: 150,width: 150,
          child: Lottie.asset('assets/lottie/nodatafound.json')));
    } else {
      // Return the search results list
      return _buildSearchResultsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.color1,
        onPressed: toggleFilterDrawer, // Toggle the filter drawer
        child: Icon(Icons.filter_list_alt,color: Colors.white,),
      ),
      key: _scaffoldKey,
      drawer: SafeArea(
        child:Drawer(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Center(child: Text('Filter', style: TextStyle(color: AppColors.color1))),
                    ExpansionTile(
                      title: Text('Price Range', style: TextStyle(color: AppColors.color1)),
                      children: [
                        // Add your price range selection widget here
                        RangeSlider(
                          values: _currentRangeValues,
                          min: 0,
                          max: 1000,
                          divisions: 100,
                          onChanged: (RangeValues values) {
                            setState(() {
                              _currentRangeValues = values;
                            });
                          },
                          labels: RangeLabels(
                            _currentRangeValues.start.round().toString(),
                            _currentRangeValues.end.round().toString(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.color1
                ),
                onPressed: () {
                  // Add your logic to apply the price range filter here
                },
                child: Text('Apply Filter',style: TextStyle(
                  color: Colors.white
                ),),
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.color1,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap:(){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String location = widget.location.toString(); // variable to store the location
                                      return AlertDialog(
                                        title: Text('Enter Location',style: TextStyle(color: AppColors.color1),),
                                        content: Container(
                                          height: MediaQuery.of(context).size.height/5,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller:newlocationController ,
                                                onChanged: (value) {
                                                  setState(() {
                                                    newlocationController.text = value;
                                                    widget.location = value;
                                                  });
                                                },
                                                style: TextStyle(color: AppColors.color1),
                                                decoration: InputDecoration(
                                                  hintText: 'Enter location',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // close the dialog
                                            },
                                            child: Text('Cancel',style: TextStyle(color: AppColors.color1),),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Handle submit button action here, you can use the location variable
                                              print('Location submitted: $location');
                                              Navigator.of(context).pop(); // close the dialog
                                              searchapi('$location');
                                            },
                                            child: Text('Submit',style: TextStyle(color: AppColors.color1),),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image(image: AssetImage('assets/icons/locationmarker.png')),
                                ),
                              ),
                              SizedBox(width: 10,),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String location = widget.location.toString(); // variable to store the location

                                      return AlertDialog(
                                        title: Text('Enter Location'),
                                        content: Container(
                                          height: MediaQuery.of(context).size.height/5,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller:newlocationController ,
                                                onChanged: (value) {
                                                  setState(() {
                                                    newlocationController.text = value;
                                                    widget.location = value;
                                                  });
                                                },
                                                style: TextStyle(color: AppColors.color1),
                                                decoration: InputDecoration(
                                                  hintText: 'Enter location',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // close the dialog
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Handle submit button action here, you can use the location variable
                                              print('Location submitted: $location');
                                              Navigator.of(context).pop(); // close the dialog
                                            },
                                            child: Text('Submit'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text('${widget.location}', style: TextStyle(color: Colors.white)),
                              ),

                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                  _scaffoldKey.currentState!.openDrawer();
                                });
                              },
                                child: Icon(Icons.filter_list_alt,color: Colors.white,)),
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.only(left:10),
                        child: TextFormField(
                          controller: searchController,
                          focusNode: searchFocusNode,
                          onChanged: (query) {
                            if(query.isEmpty){
                              setState(() {
                                _suggestions = [];
                              });
                            } else {
                              searchapi(query);
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: Icon(Icons.search),
                            hintText: 'Search...',
                          ),
                        ),
                      ),
                      SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),
              Expanded(child: _buildSearchList()), // Use _buildSearchList() instead of _buildPopularProductsList()
            ],
          );
        }
      ),
    );
  }
}
