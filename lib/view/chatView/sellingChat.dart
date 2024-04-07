import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
class SellingChat extends StatefulWidget {
  const SellingChat({super.key});

  @override
  State<SellingChat> createState() => _SellingChatState();
}

class _SellingChatState extends State<SellingChat> {
  final TextEditingController _messageController = TextEditingController();
  List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Row(
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
        actions: const [
          Icon(Icons.more_vert_outlined, color: AppColors.color1),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 10),
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
                    color: const Color.fromRGBO(7, 59, 76, 0.18),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type your message...',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
                  icon: const Icon(Icons.send, color: Colors.white),
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
