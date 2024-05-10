import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:http/http.dart' as http;
import 'package:rentmything/view/chatView/buyyingChat.dart';
import 'package:rentmything/view/chatView/veiw_chat.dart';

class ListofChats extends StatefulWidget {
  const ListofChats({Key? key}) : super(key: key);

  @override
  State<ListofChats> createState() => _ListofChatsState();
}

class _ListofChatsState extends State<ListofChats> {
  late Future<List<dynamic>> chatListFuture;

  @override
  void initState() {
    super.initState();
    chatListFuture = getChatList();
  }

  Future<List<dynamic>> getChatList() async {
    final String apiUrl = AppUrl.chatlist;

    Map<String, dynamic> postData = {
      "user_id": Util.userId,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        print('chat list is:${response.body}');
        dynamic responseData = jsonDecode(response.body);
        return responseData['chats'];
      } else {
        throw Exception('Failed to load chat list');
      }
    } catch (e) {
      throw Exception('Error fetching chat list: $e');
    }
  }

  Future<void> _refreshChatList() async {
    setState(() {
      chatListFuture = getChatList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshChatList,
        child: FutureBuilder<List<dynamic>>(
          future: chatListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              List<dynamic> chatList = snapshot.data!;
              return ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      print('product id:${chatList[index]['prod_id']['_id']}');
                      print('sender id:${Util.userId}');
                      print('reciver id:${Util.userId == chatList[index]['sender_id']
                          ? '${chatList[index]['receiver_id']}'
                          : '${chatList[index]['sender_id']}'}');
                      // Navigator.push(context, MaterialPageRoute(builder: (context) =>ViewChat(
                      //     senderId: Util.userId!,
                      //     productId: chatList[index]['prod_id']['_id'],
                      //     receiverId:  Util.userId == chatList[index]['sender_id']
                      //             ? '${chatList[index]['receiver_id']}'
                      //             : '${chatList[index]['sender_id']}'
                      // )));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuyyingChat(
                            customerName: Util.userId == chatList[index]['sender_id']
                                ? '${chatList[index]['receiver_name']}'
                                : '${chatList[index]['sender_name']}',
                            senderId: Util.userId!,
                            productId: chatList[index]['prod_id']['_id'],
                            reciverId: Util.userId == chatList[index]['sender_id']
                                ? '${chatList[index]['receiver_id']}'
                                : '${chatList[index]['sender_id']}',
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.color2,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          chatList[index]['image'] != null && chatList[index]['image'].isNotEmpty ? chatList[index]['image'][0] : 'https://via.placeholder.com/150', // Display the first image if available, otherwise display a placeholder image
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${chatList[index]['prod_id']['name']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                          color: AppColors.color1,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: AppColors.color1,
                                            backgroundImage: NetworkImage('${chatList[index]['image']}'),
                                            child: Text(
                                              '${Util.userId == chatList[index]['sender_id'] ? '${chatList[index]['receiver_name'].toString().substring(0, 1)}' : '${chatList[index]['sender_name'].toString().substring(0, 1)}'}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                letterSpacing: 1,



                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  Util.userId == chatList[index]['sender_id']
                                                      ? '${chatList[index]['receiver_name']}'
                                                      : '${chatList[index]['sender_name']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: AppColors.color1,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                                Text('${chatList[index]['message']}',style: TextStyle(color: AppColors.color1),),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 10,
                            child: Icon(Icons.more_vert),
                          ),
                          // Positioned(
                          //   right:10,
                          //   bottom:10,
                          //   child: CircleAvatar(
                          //     radius: 15,
                          //     backgroundColor:AppColors.color1,
                          //     child: Text('${chatList[index].length}',style: TextStyle(color: Colors.white),),)),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No chat data available'),
              );
            }
          },
        ),
      ),
    );
  }
}
