import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
import 'package:rentmything/view/cartView/finishedads.dart';
import 'package:rentmything/view/cartView/rentpurchased.dart';


class Cartview extends StatefulWidget {
  const Cartview({super.key});

  @override
  State<Cartview> createState() => _CartviewState();
}

class _CartviewState extends State<Cartview> {

  final _cartTabPages = <Widget>[
    const RentPurchaseView(),
    const FinishedAds(),
  ];

  final _cartTabs = <Tab>[
    const Tab(text: 'Rent Taken',),
    const Tab(text:'Rent Finished'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _cartTabs.length,
      child: Scaffold(
          appBar: AppBar(
              leading: InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> const BottomNavigationPage()));
                  },
                  child: const Icon(Icons.arrow_circle_left,color: AppColors.color1,)),
              title: const Center(child: Text('My Cart',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),)),
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