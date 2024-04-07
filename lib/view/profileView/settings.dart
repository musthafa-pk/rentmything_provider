import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_circle_left_rounded,color: AppColors.color1,)),
        title: Text('Settings')
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings page under work'),
              Text('1.Theme changing'),
              Text('2.Password changing'),
            ],
          ),
        ),
      ),
    );
  }
}
