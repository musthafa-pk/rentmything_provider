import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class ShimmerEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Adjust the item count as needed
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 30,
            ),
            title: Container(
              height: 20,
              color: Colors.grey[300],
            ),
            subtitle: Container(
              height: 10,
              color: Colors.grey[300],
            ),
          ),
        );
      },
    );
  }
}