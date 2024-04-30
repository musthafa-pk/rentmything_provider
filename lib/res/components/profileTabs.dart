import 'package:flutter/material.dart';
class ProfileTabs extends StatelessWidget {
  String tabname;
  Icon tabicon;
  Color tabcolor;
  ProfileTabs({required this.tabname,required this.tabicon,required this.tabcolor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          const SizedBox(width: 50,),
          CircleAvatar(
              radius: 30,
              backgroundColor: tabcolor,
              child: tabicon
          ),
          const SizedBox(width: 30,),
          Text(tabname,style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Color.fromRGBO(0, 0, 0, 0.56)),)
        ],
      ),
    );
  }
}