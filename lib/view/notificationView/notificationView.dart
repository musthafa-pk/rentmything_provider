import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        leading: InkWell(onTap: (){
          Navigator.pop(context);
        },child: Icon(Icons.arrow_circle_left_rounded,color: AppColors.color1,)),
      ),
      body: SafeArea(child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context,index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Notification 1'),
                            Row(
                              children: [
                                Icon(Icons.remove_red_eye,color: Colors.black,),
                                Icon(Icons.delete,color: Colors.red,),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
          )
        ],
      )),
    );
  }
}