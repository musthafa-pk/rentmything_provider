import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/view/cartView/cartView.dart';
import 'package:rentmything/view/chatView/chatView.dart';
import 'package:rentmything/view/homeView/homeScreen.dart';
import 'package:rentmything/view/myAdView/myAdView.dart';
import 'package:rentmything/view/profileView/profileView.dart';


class BottomNavigationPage extends StatefulWidget {
  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    ChatPage(),
    MyAdsView(),
    Cartview(),
    ProfileView()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SizedBox(child: Image.asset('assets/icons/home.png'),height: 24,width: 24,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(child: Image.asset('assets/icons/msg.png'),height: 24,width: 24,),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(child: Image.asset('assets/icons/ad.png'),height: 24,width: 24,),
            label: 'My Ads',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(child: Image.asset('assets/icons/cart.png'),height: 24,width: 24,),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(child: Image.asset('assets/icons/profile.png'),height: 24,width: 24,),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.color1,
        unselectedItemColor: Color.fromRGBO(0, 0, 0, 0.74),
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}
