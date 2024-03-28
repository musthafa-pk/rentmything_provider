import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
import 'package:rentmything/view/cartView/finishedads.dart';
import 'package:rentmything/view/cartView/rentpurchased.dart';
import 'package:rentmything/view/myAdView/rentedView.dart';


class Cartview extends StatefulWidget {
  const Cartview({super.key});

  @override
  State<Cartview> createState() => _CartviewState();
}

class _CartviewState extends State<Cartview> {

  final _cartTabPages = <Widget>[
    RentPurchaseView(),
    FinishedAds(),
  ];

  final _cartTabs = <Tab>[
    const Tab(text: 'Rented Items',),
    const Tab(text:'Finished'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _cartTabs.length,
      child: Scaffold(
          appBar: AppBar(
              leading: InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> BottomNavigationPage()));
                  },
                  child: Icon(Icons.arrow_circle_left,color: AppColors.color1,)),
              title: Center(child: Text('My Cart',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),)),
              bottom: TabBar(tabs: _cartTabs,
                labelColor: AppColors.color1,
                indicatorColor: AppColors.color1,
              )
          ),
          body: TabBarView(children: _cartTabPages)
      ),
    );
  }
}