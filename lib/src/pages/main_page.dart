import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ace/src/components/image_data.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start the timer to update the UI every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Dispose the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime joinDate = DateTime(2023, 5, 7);
    DateTime dischargeDate = DateTime(2024, 11, 6);
    DateTime preOutingDate = DateTime(2023, 5, 1);
    DateTime nextVacationDate = DateTime(2023, 6, 10);
    DateTime nextEgressionDate = DateTime(2023, 5, 30);

    double joinProgress =
        (now.isBefore(joinDate) ? 0 : now.difference(joinDate).inSeconds) /
            dischargeDate.difference(joinDate).inSeconds;

    double vacationProgress = (now.isBefore(preOutingDate)
            ? 0
            : now.difference(preOutingDate).inSeconds) /
        dischargeDate.difference(nextVacationDate).inSeconds;

    double egressionProgress = (now.isBefore(preOutingDate)
            ? 0
            : now.difference(preOutingDate).inSeconds) /
        dischargeDate.difference(nextEgressionDate).inSeconds;

    String formattedDischargeDate =
        DateFormat('yyyy-MM-dd').format(dischargeDate);
    String formattedNextVacationDate =
        DateFormat('yyyy-MM-dd').format(nextVacationDate);
    String formattedNextEgressionDate =
        DateFormat('yyyy-MM-dd').format(nextEgressionDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                color: Colors.grey.shade200,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/avatar.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 전역 프로그레스 바
          buildProgressBar(
            context,
            title: '전역',
            progress: joinProgress,
            endDate: formattedDischargeDate,
            fullWidth: true, // Set to true to occupy full width
          ),

          // 휴가 및 외출 프로그레스 바
          Expanded(
            child: buildProgressBars(
              context,
              vacationTitle: '다음 휴가',
              vacationProgress: vacationProgress,
              nextVacationDate: formattedNextVacationDate,
              egressionTitle: '다음 외출',
              egressionProgress: egressionProgress,
              nextEgressionDate: formattedNextEgressionDate,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProgressBar(
    BuildContext context, {
    required String title,
    required double progress,
    required String endDate,
    bool fullWidth = false,
  }) {
    String formattedProgress = title == '전역'
        ? (progress * 100).toStringAsFixed(7)
        : (progress * 100).toStringAsFixed(5);

    return Container(
      height: MediaQuery.of(context).size.height * 0.125,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: fullWidth
                ? MediaQuery.of(context).size.width - 40
                : (MediaQuery.of(context).size.width - 40) / 2,
            child: LinearPercentIndicator(
              percent: progress,
              lineHeight: 10,
              backgroundColor: Colors.blueGrey.shade100,
              progressColor: Colors.teal.shade400,
            ),
          ),
          Positioned(
            top: 20,
            left: 10,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 10,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                endDate,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                '$formattedProgress%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProgressBars(
    BuildContext context, {
    required String vacationTitle,
    required double vacationProgress,
    required String nextVacationDate,
    required String egressionTitle,
    required double egressionProgress,
    required String nextEgressionDate,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: buildProgressBar(
            context,
            title: vacationTitle,
            progress: vacationProgress,
            endDate: nextVacationDate,
          ),
        ),
        Expanded(
          child: buildProgressBar(
            context,
            title: egressionTitle,
            progress: egressionProgress,
            endDate: nextEgressionDate,
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MainPage(),
  ));
}
