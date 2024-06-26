import 'package:flutter/material.dart';
import 'package:flutter_ace/src/pages/main_page/avatar.dart';
import 'package:flutter_ace/src/pages/main_page/info.dart';
import 'package:flutter_ace/src/pages/main_page/progress_bar.dart';

class SoldierankMain extends StatelessWidget {
  final String soldierType;
  final DateTime? joinDate;
  final DateTime? dischargeDate;
  final DateTime? preOutingDate;
  final DateTime? nextVacationDate;
  final DateTime? nextEgressionDate;

  const SoldierankMain({
    super.key,
    required this.soldierType,
    required this.joinDate,
    required this.dischargeDate,
    required this.preOutingDate,
    required this.nextVacationDate,
    required this.nextEgressionDate,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double paddingValue = size.width * 0.1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.all(paddingValue),
            child: Avatar(
              soldiertype: soldierType,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingValue),
            child: ProgressBar(
              joinDate: joinDate,
              dischargeDate: dischargeDate,
              preOutingDate: preOutingDate,
              nextVacationDate: nextVacationDate,
              nextEgressionDate: nextEgressionDate,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.all(paddingValue),
            child: Info(
              joinDate: joinDate,
              dischargeDate: dischargeDate,
              nextVacationDate: nextVacationDate,
            ),
          ),
        ),
      ],
    );
  }
}
