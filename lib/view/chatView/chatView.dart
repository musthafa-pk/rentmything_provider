import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  List<String> messages = [];
  IO.Socket? socket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/person1.jpg'),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gayathri',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(5, 171, 207, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Icon(Icons.more_vert_outlined, color: AppColors.color1),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(color: AppColors.color1),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage('assets/images/van.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Van Fresh 2024',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Posted On : 1-3-2024',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    buildMessage(isSentByMe: true, message: 'Hey'),
                    buildMessage(isSentByMe: false, message: 'Hellooooooooooo'),
                    buildMessage(isSentByMe: true, message: 'hey, is it available?'),
                    buildMessage(isSentByMe: false, message: 'Yes, its available'),
                    buildMessage(isSentByMe: true, message: 'place ?'),
                    buildMessage(isSentByMe: false, message: 'Kozhikode, Nadakkavu'),
                    buildMessage(isSentByMe: true, message: 'Final price?'),
                    buildMessage(isSentByMe: false, message: '10000'),
                    buildMessage(isSentByMe: true, message: 'ok'),
                    buildMessage(isSentByMe: false, message: 'when it is available?'),
                    buildMessage(isSentByMe: true, message: 'Come at sunday , i will send you current location'),
                    buildMessage(isSentByMe: false, message: 'Ok'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(7, 59, 76, 0.18),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type your message...',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.color1,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: () {
                    // Handle send button functionality
                    String message = _messageController.text;
                    // Clear the text field
                    _messageController.clear();
                    // You can perform any further action with the message
                  },
                  icon: Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMessage({required bool isSentByMe, required String message}) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: isSentByMe ? AppColors.color1 : Colors.grey[300],
          borderRadius: isSentByMe
              ? BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
            bottomLeft: Radius.circular(22),
          )
              : BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
            bottomRight: Radius.circular(22),
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        child: Text(
          message,
          style: TextStyle(
            color: isSentByMe ? Colors.white : AppColors.color1,
          ),
        ),
      ),
    );
  }
}
