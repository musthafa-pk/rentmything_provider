import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';

class RentedDetail extends StatefulWidget {
  final Map<String,dynamic> data;
  const RentedDetail({required this.data, super.key});

  @override
  State<RentedDetail> createState() => _RentedDetailState();
}

class _RentedDetailState extends State<RentedDetail> {

  late Timer _timer;
  late StreamController<String> _streamController;

  @override
  void initState() {
    // TODO: implement initState
    _streamController = StreamController<String>();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _streamController.add(_calculateTimeLeft());
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _streamController.close();
    super.dispose();
  }

  String _calculateTimeLeft() {
    DateTime endDate = DateTime.parse(widget.data['end_date']);
    DateTime now = DateTime.now();
    Duration duration = endDate.difference(now);

    int days = duration.inDays;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);

    return '$days days, $hours hours, $minutes minutes';
  }


  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateTime.parse(widget.data['start_date']);
    DateTime endDate = DateTime.parse(widget.data['end_date']);
    DateTime now = DateTime.now();

    // calculate diffrence between start and end date
    Duration duration = endDate.difference(startDate);

    // Extract Days and hours from the duration
    int days = duration.inDays;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);

    //calculate total minutes
    int totalMinutes = duration.inMinutes;

    // Calculate the progress percentage
    double progress = now.isBefore(endDate)
        ? now.difference(startDate).inDays.toDouble() /
        endDate.difference(startDate).inDays.toDouble()
        : 1.0;
    //calculate agrement duration
    // int agrementduration = endDate.difference(startDate).inDays;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_circle_left_rounded,color: AppColors.color1,),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price : ${widget.data['amount']}'),
              Text('Rent Type : ${widget.data['rent_type']}'),
              Text('Rent Status : ${widget.data['rent_status']}'),
              Text('Rent Started : ${widget.data['start_date']}'),
              Text('Rent End : ${widget.data['end_date']}'),
              Text(
                'Total Agreement Duration: $days days, $hours hours, $minutes minutes',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              // Text('Time Left :$days days, $hours hours, $minutes'),
              // StreamBuilder<String>(
              //   stream: _streamController.stream,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       return Text('Time Left: ${snapshot.data}');
              //     } else {
              //       return Text('Calculating time left...');
              //     }
              //   },
              // ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Progress: ${(progress * 100).toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
