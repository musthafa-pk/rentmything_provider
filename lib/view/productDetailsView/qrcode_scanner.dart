import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rentmything/view/profileView/profileView.dart';
import 'package:rentmything/view/rentoutView/markingasrented.dart';
class QrcodeScanPage extends StatefulWidget {
  String productid;
  QrcodeScanPage({required this.productid,super.key});

  @override
  State<QrcodeScanPage> createState() => _QrcodeScanPageState();
}

class _QrcodeScanPageState extends State<QrcodeScanPage> {

  late QRViewController _controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? scanned_customerid;
  @override
  void initState() {
    // TODO: implement initState
    print('product id is :${widget.productid}');
    super.initState();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    _controller.scannedDataStream.listen((scanData) {
      setState(() {
        scanned_customerid = scanData.code;
        print('scanned cus id:$scanned_customerid');
      });
      // Handle scanned data here
      if(scanData.code!.isNotEmpty){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MarkingasRented(prod_id: widget.productid,cust_id:scanned_customerid! ,)));
        _controller.dispose();
      }
      print(scanData.code);
      // You can add further logic here, such as navigating to a new page
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Use customer profile tab qr code to get customer detials'),
          Expanded(
            flex: 5,
              child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ))

        ],
      ),
    );
  }
}
