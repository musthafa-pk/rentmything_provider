import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';

import '../../res/app_url.dart';

import 'package:http/http.dart' as http;

import '../../utils/utls.dart';

class ViewChat extends StatefulWidget {
  final String senderId;
  final String productId;
  final String receiverId;

  ViewChat({
    Key? key,
    required this.senderId,
    required this.productId,
    required this.receiverId,
  }) : super(key: key);

  @override
  State<ViewChat> createState() => _ViewChatState();
}

class _ViewChatState extends State<ViewChat> {
  TextEditingController _messageController = TextEditingController();
  List<dynamic> _messages = [
    'Hello!',
    'Hi there!',
    'How are you?',
  ]; // Example messages, you can replace this with your actual chat data

  void getChat() async {
    String url = AppUrl.getsinglechat;
    Map<String, dynamic> body = {
      'user1': widget.senderId,
      'user2': widget.receiverId
    };
    String jsonBody = json.encode(body);

    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonBody);
      if (response.statusCode == 200) {
        dynamic chatListData = json.decode(response.body);

        setState(() {
          _messages = chatListData['data'];
        });
      } else {
        throw Exception('Failed to make POST request. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (error) {
      print('error is :$error');
      throw error;
    }
  }
  Future<void> savemessage(String message) async {
    String url = AppUrl.sendmessage;
    Map<String, dynamic> body = {
      "message": message,
      "receiver_id": widget.receiverId,
      "sender_id": Util.userId,
      "prod_id":widget.productId,
    };
    String jsonBody = json.encode(body);

    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonBody);

      if (response.statusCode == 200) {
        Util.flushBarErrorMessage('saved', Icons.verified, Colors.green, context);
        // Message sent successfully, you may want to update UI accordingly
      } else {
        throw Exception('Failed to make POST request. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (error) {
      Util.flushBarErrorMessage('${error}', Icons.sms_failed, Colors.red, context);
      throw error;
    }
  }
  void _sendMessage(String message) {
    // Here you would implement the logic to send the message
    setState(() {
      _messages.add(message);
      _messageController.clear();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    getChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  print('message length:${_messages.length}');
                  print('message :${_messages[index]['message']}');
                  // Access senderId and message from the current message map
                  String? senderId = _messages[index]['senderId'];
                  String? message = _messages[index]['message'];
                  // Check if senderId or message is null
                  if (senderId == null || message == null) {
                    // Handle the case where senderId or message is null
                    return Container(); // or any other appropriate handling
                  }
                  // Check if the message sender is the current user or not
                  bool isCurrentUser = senderId == widget.senderId;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text('${_messages[index]['message']}'),
                      ),
                    ),
                  );
                },
              )
              ,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.color2,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          hintText: 'Type a message...',
                          border: InputBorder.none
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.color1
                    ),
                    onPressed: () {
                      String message = _messageController.text.trim();
                      if (message.isNotEmpty) {
                        _sendMessage(message);
                        savemessage(message);
                      }
                    },
                    child: Icon(Icons.send,color: Colors.white,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
