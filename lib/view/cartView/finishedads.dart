import 'package:flutter/material.dart';


class FinishedAds extends StatefulWidget {
  const FinishedAds({super.key});

  @override
  State<FinishedAds> createState() => _FinishedAdsState();
}

class _FinishedAdsState extends State<FinishedAds> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body:  Center(
          child: Text('rent taken finished ads...'),
        )
    );
  }
}