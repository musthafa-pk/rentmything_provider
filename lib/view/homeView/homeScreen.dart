

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/favourite/favourite.dart';
import 'package:rentmything/view/homeView/Machineries.dart';
import 'package:rentmything/view/homeView/appliancescategory.dart';
import 'package:rentmything/view/homeView/elctronicscategory.dart';
import 'package:rentmything/view/homeView/popular.dart';
import 'package:rentmything/view/homeView/searchPage.dart';
import 'package:rentmything/view/homeView/searchresult.dart';
import 'package:rentmything/view/homeView/tools.dart';
import 'package:rentmything/view/homeView/vehiclescategory.dart';
import 'package:rentmything/view/notificationView/notificationView.dart';

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

  List<dynamic> notificaitonlist = [];


  Future<dynamic> getnotification() async {
    print('get notification called....');
    // Define the endpoint URL

    String apiUrl = AppUrl.getnotification;
    Map<String, dynamic> postData = {'user_id': Util.userId};

    try {
      // Make the POST request
      http.Response response = await http.post(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(postData));
      if (response.statusCode == 200) {
        print('get notifications');
        var responseData = jsonDecode(response.body)['data'];
        setState(() {
          notificaitonlist.clear();
          notificaitonlist.addAll(responseData);
        });
        return notificaitonlist;
      } else {
        print('Error: ${response.statusCode}');
        print('Error Message: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void checkNotifications() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      getnotification().then((notifications) {
        setState(() {
          notificaitonlist.clear();
          notificaitonlist.addAll(notifications);
        });
      }).catchError((error) {
        print('Error fetching notifications: $error');
      });
    });
  }

  final _TabPages = <Widget>[
    const PopularView(),
    VehiclesCategory(category: 'vehicles',),
    ElectronicsCategory(category: 'Electronics',),
    Machineries(category: 'Machineries',),
    Tools(category: 'Tools',),
    AppliancesCategory(category: 'Appliances')
  ];

  final _Tabs = <Tab>[
    const Tab(icon: SizedBox(child: Image(image: AssetImage('assets/icons/popular.png',),height: 24,width: 24,),),text: 'Popular',),
    const Tab(icon: SizedBox(child: Image(image: AssetImage('assets/icons/car.png'),height: 24,width: 24,),),text: 'Vehicles',),
    const Tab(icon: SizedBox(child: Image(image: AssetImage('assets/icons/electronics.png'),height: 24,width: 24,),),text: 'Electronics',),
    const Tab(icon: SizedBox(child: Image(image: AssetImage('assets/icons/machinary.png'),height: 24,width: 24,),),text: 'Machineries',),
    const Tab(icon: SizedBox(child: Image(image: AssetImage('assets/icons/tools.png'),height: 24,width: 24,),),text: 'Tools',),
    const Tab(icon: SizedBox(child: Image(image: AssetImage('assets/icons/tools.png'),height: 24,width: 24,),),text: 'Appliances',),
    const Tab(icon: SizedBox(child: Image(image: AssetImage('assets/icons/tools.png'),height: 24,width: 24,),),text: 'Furnitures',),
    const Tab(icon: SizedBox(child: Image(image: AssetImage('assets/icons/tools.png'),height: 24,width: 24,),),text: 'Cloth',),
    const Tab(icon: SizedBox(child: Image(image: AssetImage('assets/icons/tools.png'),height: 24,width: 24,),),text: 'Land & Building',),
    const Tab(icon: SizedBox(child: Image(image: AssetImage('assets/icons/tools.png'),height: 24,width: 24,),),text: 'Other',),
  ];


  TextEditingController _searchController = TextEditingController();
  TextEditingController _suggestionController = TextEditingController();
  List<String> suggestions = [];

  List<String> getSuggestions(String query) {
    // In a real application, you would fetch suggestions based on the query from an API or local database
    // For demonstration purposes, I'll return some dummy suggestions
    List<String> dummySuggestions = ['Suggestion 1', 'Suggestion 2', 'Suggestion 3'];
    return dummySuggestions
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }


  @override
  void initState() {
    // getpopularitems();
    getnotification();
    checkNotifications();
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
            toolbarHeight: MediaQuery.of(context).size.height/3.5,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                color: AppColors.color1,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
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
                                    const SizedBox(
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
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color:notificaitonlist.any((notification) => notification['read'] == 'N')? AppColors.color6 : Colors.transparent, // or any other color you want for the badge background
                                          borderRadius: BorderRadius.circular(10),
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const FavouritePage()));
                                },
                                child: const SizedBox(
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
                                  child: TextField(
                                    controller: _suggestionController,
                                    onChanged: (value){
                                      setState(() {
                                        suggestions = getSuggestions(value);
                                      });
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Location',
                                        contentPadding: EdgeInsets.all(10),
                                        suffixIcon: SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Image(image: AssetImage('assets/icons/locationmarker.png'),),
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
                             Expanded(
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage(location:_suggestionController.text ,)));
                                },
                                child: Container(
                                  child: Text('Search Now....',style: TextStyle(
                                    color: AppColors.color2
                                  ),),
                                )
                              ),
                                                         ),
                          ],
                        ),
                      ),
                    ),
                    TabBar(
                      tabAlignment: TabAlignment.start,
                        tabs: _Tabs,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white60,
                      isScrollable:true,
                      dividerHeight: 0,
                      indicatorPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
          ),
          body:  TabBarView(
              children: _TabPages
          ),
        ),
      ),
    );
  }
}
