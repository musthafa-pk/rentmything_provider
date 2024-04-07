import 'package:flutter/material.dart';

class RentPurchaseView extends StatefulWidget {
  const RentPurchaseView({super.key});

  @override
  State<RentPurchaseView> createState() => _RentPurchaseViewState();
}



class _RentPurchaseViewState extends State<RentPurchaseView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Rent taken view.....'),
      ),
    );
  }
}
