import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/view/cartView/cartView.dart';
import 'package:rentmything/view/chatView/chatView.dart';
import 'package:rentmything/view/homeView/homeScreen.dart';
import 'package:rentmything/view/myAdView/myAdView.dart';
import 'package:rentmything/view/profileView/profileView.dart';


class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeView(),
    const chatView(),
    const MyAdsView(),
    const Cartview(),
    const ProfileView()
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
            icon: SizedBox(height: 24,width: 24,child: Image.asset('assets/icons/home.png'),),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(height: 24,width: 24,child: Image.asset('assets/icons/msg.png'),),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(height: 24,width: 24,child: Image.asset('assets/icons/ad.png'),),
            label: 'My Ads',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(height: 24,width: 24,child: Image.asset('assets/icons/cart.png'),),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(height: 24,width: 24,child: Image.asset('assets/icons/profile.png'),),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.color1,
        unselectedItemColor: const Color.fromRGBO(0, 0, 0, 0.74),
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}
