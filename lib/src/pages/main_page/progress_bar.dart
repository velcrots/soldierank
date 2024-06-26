import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProgressBar extends StatefulWidget {
  final DateTime? joinDate;
  final DateTime? dischargeDate;
  final DateTime? preOutingDate;
  final DateTime? nextVacationDate;
  final DateTime? nextEgressionDate;

  const ProgressBar({
    super.key,
    required this.joinDate,
    required this.dischargeDate,
    required this.preOutingDate,
    required this.nextVacationDate,
    required this.nextEgressionDate,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  double dischargePercent = 0.0;
  double vacationPercent = 0.0;
  double egressionPercent = 0.0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (widget.joinDate != null && widget.dischargeDate != null) {
        setState(() {
          dischargePercent = DateTime.now()
                  .difference(widget.joinDate!)
                  .inMilliseconds /
              widget.dischargeDate!.difference(widget.joinDate!).inMilliseconds;
        });
      }
      if (widget.preOutingDate != null && widget.nextVacationDate != null) {
        setState(() {
          vacationPercent =
              DateTime.now().difference(widget.preOutingDate!).inMilliseconds /
                  widget.nextVacationDate!
                      .difference(widget.preOutingDate!)
                      .inMilliseconds;
        });
      }
      if (widget.preOutingDate != null && widget.nextEgressionDate != null) {
        setState(() {
          egressionPercent =
              DateTime.now().difference(widget.preOutingDate!).inMilliseconds /
                  widget.nextEgressionDate!
                      .difference(widget.preOutingDate!)
                      .inMilliseconds;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 전역 관련 프로그레스 바
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '전역',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.left,
            ),
            Text(
              widget.dischargeDate != null
                  ? dateFormat.format(widget.dischargeDate!)
                  : '',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        SizedBox(height: 5),
        LinearProgressIndicator(
          value: dischargePercent,
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${(dischargePercent * 100).toStringAsFixed(9)}%',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        SizedBox(height: 10),

        // 휴가 및 외출 관련 프로그레스 바
        Row(
          children: [
            // 휴가 관련 프로그레스 바
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '휴가',
                        style: TextStyle(fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.nextVacationDate != null
                            ? dateFormat.format(widget.nextVacationDate!)
                            : '',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: vacationPercent,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${(vacationPercent * 100).toStringAsFixed(6)}%',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 20), // 두 프로그레스 바 사이에 간격을 추가

            // 외출 관련 프로그레스 바
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '외출',
                        style: TextStyle(fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.nextEgressionDate != null
                            ? dateFormat.format(widget.nextEgressionDate!)
                            : '',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: egressionPercent,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${(egressionPercent * 100).toStringAsFixed(6)}%',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
