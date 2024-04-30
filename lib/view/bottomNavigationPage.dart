import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/view/cartView/cartView.dart';
import 'package:rentmything/view/chatView/chatView.dart';
import 'package:rentmything/view/homeView/homeScreen.dart';
import 'package:rentmything/view/myAdView/myAdView.dart';
import 'package:rentmything/view/profileView/profileView.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({Key? key});

  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  DateTime? currentBackPressTime;
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeView(),
    const chatView(),
    const MyAdsView(),
    const Cartview(),
    const ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return Future.value(false);
    } else {
      bool exitConfirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Exit'),
            content: Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Return false to cancel the pop
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Return true to proceed with pop
                },
                child: Text('Yes'),
              ),
            ],
          );
        },
      );
      return exitConfirmed;
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SizedBox(height: 24, width: 24, child: Image.asset('assets/icons/home.png')),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(height: 24, width: 24, child: Image.asset('assets/icons/msg.png')),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(height: 24, width: 24, child: Image.asset('assets/icons/ad.png')),
              label: 'My Ads',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(height: 24, width: 24, child: Image.asset('assets/icons/cart.png')),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(height: 24, width: 24, child: Image.asset('assets/icons/profile.png')),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.color1,
          unselectedItemColor: const Color.fromRGBO(0, 0, 0, 0.74),
          onTap: _onItemTapped,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
