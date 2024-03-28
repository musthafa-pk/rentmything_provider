import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/view/productDetailsView/productdetailsView.dart';


class FinishedAds extends StatefulWidget {
  const FinishedAds({super.key});

  @override
  State<FinishedAds> createState() => _FinishedAdsState();
}

class _FinishedAdsState extends State<FinishedAds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Center(
          child: Text('rent taken finished ads...'),
        )
    );
  }
}