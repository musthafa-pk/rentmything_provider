import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/utils/utls.dart';

class BuyyingChat extends StatefulWidget {
  final String senderId;
  final String reciverId;
  final String customerName;

  BuyyingChat({required this.customerName,required this.senderId, required this.reciverId, Key? key}) : super(key: key);

  @override
  State<BuyyingChat> createState() => _BuyyingChatState();
}

class _BuyyingChatState extends State<BuyyingChat> {
  final TextEditingController _messageController = TextEditingController();
  StreamController<List<dynamic>> _messageStreamController = StreamController<List<dynamic>>();
  List<dynamic> messages = [];
  late Timer _timer;
  late ScrollController _scrollController;

  Future<void> sendMessage() async {
    String url = AppUrl.sendmessage;
    Map<String, dynamic> body = {
      "message": _messageController.text,
      "receiver_id": widget.reciverId,
      "sender_id": Util.userId,
      "created_by":Util.userId,
    };
    String jsonBody = json.encode(body);

    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonBody);

      if (response.statusCode == 200) {
        // Message sent successfully, you may want to update UI accordingly
      } else {
        throw Exception('Failed to make POST request. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (error) {
      Util.flushBarErrorMessage('${error}', Icons.sms_failed, Colors.red, context);
      throw error;
    }
  }

  void getChat() async {
    String url = AppUrl.getsinglechat;
    Map<String, dynamic> body = {
      'user1': widget.senderId,
      'user2': widget.reciverId
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
          messages = chatListData['data'];
          _messageStreamController.add(chatListData['data']);
        });
        double maxScrollExtent = _scrollController.position.maxScrollExtent;
        double currentScrollPosition = _scrollController.position.pixels;
        if ((maxScrollExtent - currentScrollPosition) < 100 || currentScrollPosition == 0) {
          _scrollController.jumpTo(maxScrollExtent);
        }
        return chatListData['data'];
      } else {
        throw Exception('Failed to make POST request. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      getChat();
    });
    super.initState();
  }
  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels == 0) {
        // At the top of the list
        // Optionally, you can fetch more messages if needed
      } else {
        // At the bottom of the list
        // This is not necessary for your case, but you can add additional logic here if needed
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _messageStreamController.close();
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: Row(
          children: [
            CircleAvatar(radius: 20,
            backgroundColor: AppColors.color1,
            child: Text(widget.customerName.toString().substring(0,1),style: TextStyle(
              color: Colors.white
            ),),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.customerName}',style: TextStyle(fontSize: 18),),
                  Text('online',style: TextStyle(fontSize: 12,color: Colors.green),)
                ],
              ),
            )
          ],
        ),
        actions: const [
          Icon(Icons.more_vert_outlined, color: AppColors.color1),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(color: AppColors.color1),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/van.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // const SizedBox(width: 20),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
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
                          padding: EdgeInsets.all(8.0),
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
            Expanded(
              child: StreamBuilder<List<dynamic>>(
                stream: _messageStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        bool isSentByMe = snapshot.data?[index]['sender_id'] == Util.userId;
                        print(isSentByMe);
                        return buildMessage(
                            isSentByMe: isSentByMe,
                            message: '${snapshot.data?[index]['message']}',
                          senderName: '${snapshot.data?[index]['receiver_id']['name']}'
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.color2,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            hintText: 'Type your message...',
                            border: InputBorder.none,

                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        sendMessage();
                        _messageController.clear();
                        getChat();
                      });
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessage({required bool isSentByMe, required String message, required String senderName}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSentByMe)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.color1,
              child: Text(
                senderName.substring(0, 1), // Displaying the first character of sender's name
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        Expanded(
          child: Align(
            alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: isSentByMe ? AppColors.color1 : Colors.grey[300],
                borderRadius: isSentByMe
                    ? const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                  bottomLeft: Radius.circular(22),
                )
                    : const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isSentByMe) // Display sender's name above the message if it's not sent by me
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        senderName,
                        style: TextStyle(
                          color: AppColors.color1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isSentByMe ? Colors.white : AppColors.color1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isSentByMe)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.color1,
              child: Text(
                senderName.substring(0, 1), // Displaying the first character of sender's name
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }


}
