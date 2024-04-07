import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';
import 'package:rentmything/view/chatView/buyyingChat.dart';
import 'package:rentmything/view/chatView/listofchat.dart';
import 'package:rentmything/view/chatView/sellingChat.dart';

class chatView extends StatefulWidget {
  const chatView({super.key});

  @override
  State<chatView> createState() => _chatViewState();
}

class _chatViewState extends State<chatView> {

  final _adTabPages = <Widget>[
    ListofChats(),
    ListofChats()
  ];

  final _addTabs = <Tab>[
    const Tab(text: 'Buyying',),
    const Tab(text:'Selling'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _addTabs.length,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Chat'),
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