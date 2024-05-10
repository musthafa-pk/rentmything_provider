import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../res/app_colors.dart';
import '../../view_model/services/splash_services.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  SplashService splashService = SplashService();
  String appVersion='';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
    splashService.checkAuthentication(context);
  }


  Future<void> _getAppVersion() async {
    print('getin ap versino');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
      print('v is:${appVersion}');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: SizedBox(
                child: Image(
                  image: AssetImage('assets/images/LOGO 2.png'),
                ),
              ),
            ),
            Text('Version:${appVersion},',style: TextStyle(fontSize: 16,color: AppColors.color1),)
          ],
        ),
      ),
    );
  }
}