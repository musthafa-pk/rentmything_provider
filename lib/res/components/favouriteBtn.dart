import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentmything/res/app_url.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:http/http.dart' as http;

class FavoriteButton extends StatefulWidget {
  final bool isWishlist;
  final String productId;
  final BuildContext context;

  const FavoriteButton({
    required this.isWishlist,
    required this.productId,
    required this.context,
    Key? key,
  }) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState(isWishlist);
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isWishlist;
  _FavoriteButtonState(this.isWishlist);

  Future<dynamic> addtofavourite(String productID, context) async {
    Map<String, dynamic> postData = {
      "user_id": Util.userId,
      "prod_id": productID
    };
    String url = AppUrl.wishlistAdd;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        print('adding to fav success');
        var responseData = jsonDecode(response.body);
        Util.flushBarErrorMessage('${responseData['message']}',
            Icons.verified, Colors.green, context);
        setState(() {

        });
        return responseData;
      } else {
        var responseData = jsonDecode(response.body);
        print('failed response:$responseData');
        Util.flushBarErrorMessage('${responseData['message']}',
            Icons.sms_failed, Colors.red, context);
        print("API request failed with status code: ${response.statusCode}");
        print(responseData);
      }
    } catch (e) {
      print("Error making POST request: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    isWishlist = widget.isWishlist;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isWishlist = !isWishlist;
          addtofavourite(widget.productId, widget.context);
        });
      },
      child: SizedBox(
        height: 24,
        width: 24,
        child: Image(
          image: AssetImage(
            isWishlist ? 'assets/icons/favourite.png' : 'assets/icons/unfavourite.png',
          ),
        ),
      ),
    );
  }
}
