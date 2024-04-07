import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
import 'package:rentmything/view/myAdView/ongoingadsView.dart';
import 'package:rentmything/view/myAdView/rentedView.dart';

class MyAdsView extends StatefulWidget {
  const MyAdsView({super.key});

  @override
  State<MyAdsView> createState() => _MyAdsViewState();
}

class _MyAdsViewState extends State<MyAdsView> {

  final _adTabPages = <Widget>[
    const OngoingAds(),
    const RentedItems()
  ];

  final _addTabs = <Tab>[
    const Tab(text: 'On Going Ads',),
    const Tab(text:'Rented Items'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _addTabs.length,
        child: Scaffold(
            appBar: AppBar(
              title: const Center(child: Text('My Ads')),
              leading: InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const BottomNavigationPage()));
                  },
                  child: const Icon(Icons.arrow_circle_left,color: AppColors.color1,)),
              bottom: TabBar(tabs: _addTabs,
                labelColor: AppColors.color1,
                indicatorColor: AppColors.color1,),
            ),
            body: TabBarView(children: _adTabPages,)
        ));
  }
}