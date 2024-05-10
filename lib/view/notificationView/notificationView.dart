import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rentmything/main.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/res/components/AppBarBackButton.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/notificationView/notificationcontroller.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<dynamic> notificaitonlist = [];




  Future<dynamic> getnotification() async {
    print('get notification called....');
    // Define the endpoint URL

    String apiUrl = AppUrl.getnotification;
    Map<String, dynamic> postData = {'user_id': Util.userId};

    try {
      // Make the POST request
      http.Response response = await http.post(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(postData));
      if (response.statusCode == 200) {
        print('get notifications');
        var responseData = jsonDecode(response.body)['data'];
        print(responseData);
        // setState(() {
        notificaitonlist.clear();
        notificaitonlist.addAll(responseData);
        // });
        print('notifications list is:$notificaitonlist');
        print('notificaiton data :$notificaitonlist');
        print('Response: $responseData');
        return notificaitonlist;
      } else {
        print('Error: ${response.statusCode}');
        print('Error Message: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Function to check for new notifications
  void checkForNewNotifications() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      // Call the getNotification function to fetch notifications
      getnotification().then((notifications) {
        // Compare new notifications with existing notifications
        if (notifications.length > notificaitonlist.length) {
          // Trigger another function when new data is received
          handleNewData('New Notification','Rent my thing has a new notification');

          // Update the notificationList with new notifications
          setState(() {
            notificaitonlist.clear();
            notificaitonlist.addAll(notifications);
          });
        }
      }).catchError((error) {
        print('Error fetching notifications: $error');
      });
    });
  }

  Future<dynamic> deletenotification(String notificationID) async {
    print('delete notification called....');
    // Define the endpoint URL

    String apiUrl = AppUrl.deletenotification;
    Map<String, dynamic> postData = {
      'notification_id':notificationID
    };

    try {
      // Make the POST request
      http.Response response = await http.post(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(postData));
      if (response.statusCode == 200) {
        print('delete notifications');
        var responseData = jsonDecode(response.body)['data'];
      } else {
        print('Error: ${response.statusCode}');
        print('Error Message: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<dynamic> readnotifcation(String msgid) async {
    print('read notification called....');
    // Define the endpoint URL

    String apiUrl = AppUrl.readnotification;
    Map<String, dynamic> postData = {'id': msgid};

    try {
      // Make the POST request
      http.Response response = await http.post(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(postData));
      if (response.statusCode == 200) {
        print('read success...');
      } else {
        print('Error: ${response.statusCode}');
        print('Error Message: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  void _showNotificationPopup(Message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notification Details"),
          content: Text('$Message'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed();
    getnotification();
    checkForNewNotifications();
    // TODO: implement initState
    super.initState();
  }
  void handleNewData(title,message) {
    // Your code to handle new data
   NotificationController.createNewNotification(title,message);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: AppBarBackButton(),
      ),
      body: RefreshIndicator(
        onRefresh: getnotification,
        child: FutureBuilder(
          future: getnotification(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: notificaitonlist.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {

                          readnotifcation(notificaitonlist[index]['_id']);
                          _showNotificationPopup(
                              '${notificaitonlist[index]['message']}'
                          );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${notificaitonlist[index]['message']}',
                                      style: TextStyle(
                                        color: AppColors.color1
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            deletenotification(notificaitonlist[index]['_id']);
                                          });
                                        },
                                        child: Icon(Icons.delete, color: Colors.red, size: 18),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // ElevatedButton(onPressed: (){
                                    //   handleNewData('Rent My Thing', '${notificaitonlist[int.parse(notificaitonlist.length.toString())]['message']}');
                                    // }, child: Text('Press')),
                                    Text('${DateFormat('yyyy-MM-dd HH:mm a').format(DateTime.parse(notificaitonlist[index]['createdAt']))}',style: TextStyle(
                                      color: AppColors.color1
                                    ),),
                                    SizedBox(width: 10),
                                    notificaitonlist[index]['read'] == 'N' ? Icon(Icons.mark_chat_unread, color: Colors.green, size: 18) : Icon(Icons.mark_chat_read_outlined, color: Colors.green, size: 18),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

}
